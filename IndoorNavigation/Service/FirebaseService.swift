//
//  FirebaseService.swift
//  IndoorNavigation
//
//  Created by jeff on 21/06/2017.
//  Copyright © 2017 jeff. All rights reserved.
//

import Foundation
import Firebase

protocol FirebaseServiceDelegate {
    
    func checkAuthUserResponse(_ isAuthUser: Bool)
    func signInResponse(_ fuser: FirebaseUserData?, _ error:Error?)
    func signOutResponse(_ error:Error?)
    func registerWithEmailResponse(_ uid: String?, _ error:Error?)

}

struct FirebaseUserData {
    var uid: String?
    var gid: String?
    var fid: String?
    var name: String?
    var email: String?
    var profileImageURL: String?
}

enum FirebaseError: Error {
    case invalidUser
    case invalidInput(message: String)
}

class FirebaseService {
    
    var delegate: FirebaseServiceDelegate?
    let facebookModel = FacebookModel()
    var googleModel: GoogleModel?

    private var databaseRef: FIRDatabaseReference? {
        get {
            if let _ = FIRApp.defaultApp() {
                return FIRDatabase.database().reference()
            }
            return nil
        }
    }
    
    private var usersRef: FIRDatabaseReference? {
        get {
            return databaseRef?.child("users")
        }
    }
    
    private var authUser: FIRUser? {
        get {
            return FIRAuth.auth()?.currentUser
        }
    }
    
    init() {
        FIRApp.configure()
        if let defaultApp = FIRApp.defaultApp() {
            googleModel = GoogleModel(firebaseClientID: defaultApp.options.clientID)
        }
    }
    
    func checkAuthUser() {
        delegate?.checkAuthUserResponse(authUser != nil)
    }
    
    func userRegisterWithEmail(_ name:String, _ email:String, _ password:String) {
        FIRDatabase.database().goOnline()
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                self.delegate?.registerWithEmailResponse(nil, error)
                return
            }
            
            guard let uid = user?.uid else {
                assert(false, "no user uid")
                return
            }
            let values = ["email": email, "name": name]
            self.usersRef?.child(uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
                if error != nil {
                    self.delegate?.registerWithEmailResponse(nil, error)
                    return
                }
                self.delegate?.registerWithEmailResponse(uid, nil)
            })
            
        })
    }

    func userSigninWithEmailPassword(email: String, password: String) {
        FIRDatabase.database().goOnline()
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                self.delegate?.signInResponse(nil, error)
            } else {
                var fuser = FirebaseUserData()
                fuser.uid = user?.uid
                self.delegate?.signInResponse(fuser, nil)
            }
        })
    }
    
    func userSignInWithGoogle(_ idToken:String, _ accessToken: String) {
        FIRDatabase.database().goOnline()
        let credential = FIRGoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if let error = error {
                self.delegate?.signInResponse(nil, error)
            } else if let user = user {
                let email = user.email ?? ""
                let displayName = user.displayName ?? ""
                let gid = user.providerData[0].uid
                let photoURL = user.providerData[0].photoURL?.absoluteString ?? ""
                let values: [String: Any] = ["name": displayName, "email": email, "gid": gid, "photo": photoURL]
                self.usersRef?.child(user.uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
                    if let error = error {
                        self.delegate?.signInResponse(nil, error)
                    } else {
                        var fuser = FirebaseUserData()
                        fuser.uid = user.uid
                        fuser.gid = gid
                        fuser.name = displayName
                        fuser.email = email
                        fuser.profileImageURL = photoURL
                        self.delegate?.signInResponse(fuser, nil)
                    }
                })
            }
        })
    }
    
    func userSignInWithFacebook(_ viewController: UIViewController) {
        facebookModel.facebookLogin(viewController) { (success) in
            if success {
                if let accessToken = self.facebookModel.accessToken {
                    FIRDatabase.database().goOnline()
                    let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                    FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                        if let error = error {
                            self.delegate?.signInResponse(nil, error)
                        } else if let user = user {
                            let displayName = user.displayName ?? ""
                            let fid = user.providerData[0].uid
                            let email = user.providerData[0].email ?? ""
                            let photo = user.providerData[0].photoURL?.absoluteString ?? ""
                            let values = ["name": displayName, "email": email, "fid": fid, "photo": photo]
                            self.usersRef?.child(user.uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
                                if let error = error {
                                    self.delegate?.signInResponse(nil, error)
                                } else {
                                    var fuser = FirebaseUserData()
                                    fuser.uid = user.uid
                                    fuser.fid = fid
                                    fuser.email = email
                                    fuser.profileImageURL = photo
                                    self.delegate?.signInResponse(fuser, nil)
                                }
                            })
                        }
                    })
                } else {
                    self.delegate?.signInResponse(nil, FirebaseError.invalidInput(message: "cannot retrieve facebook access token"))
                }
            } else {
                self.delegate?.signInResponse(nil, FirebaseError.invalidInput(message: "facebook fail to sign in"))
            }
        }
    }
    
    func userSignOut() {
        do {
            if let user = authUser {
                for data in user.providerData {
                    if data.providerID == "google.com" {
                        googleModel?.signOut()
                    } else if data.providerID == "facebook.com" {
                        facebookModel.facebookLogout()
                    }
                }
                try FIRAuth.auth()?.signOut()
                delegate?.signOutResponse(nil)
                FIRDatabase.database().goOffline()
            }
        } catch let signoutError {
            delegate?.signOutResponse(signoutError)
        }
    }

    func fetchUserData(completion: @escaping (FirebaseUserData?, FirebaseError?) -> Void) {
        guard let uid = authUser?.uid else {
            completion(nil, FirebaseError.invalidUser)
            return
        }
        
        usersRef?.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(uid) {
                snapshot.ref.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let data = snapshot.value as? [String: Any] {
                        if let name = data["name"] as? String, let email = data["email"] as? String {
                            var fuser = FirebaseUserData()
                            fuser.uid = uid
                            fuser.name = name
                            fuser.email = email
                            completion(fuser, nil)
                        }
                    }
                })
            } else {
                self.userSignOut()
                completion(nil, FirebaseError.invalidUser)
            }
        })
    }

}
