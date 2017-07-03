//
//  FirebaseService.swift
//  IndoorNavigation
//
//  Created by jeff on 21/06/2017.
//  Copyright © 2017 jeff. All rights reserved.
//

import Foundation
import Firebase

enum FirebaseError: Error {
    case invalidUser
    case invalidInput(message: String)
}

public class FirebaseService {
    
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
        if FIRApp.defaultApp() == nil {
            FIRApp.configure()
        }
        if let defaultApp = FIRApp.defaultApp() {
            googleModel = GoogleModel(firebaseClientID: defaultApp.options.clientID)
        }
    }
    
    func checkAuthUser(completion: (Bool) -> Void) {
        completion(authUser != nil)
    }
    
    func userRegisterWithEmail(_ name:String, _ email:String, _ password:String, completion: @escaping (UserData?, Error?) -> Void) {
        FIRDatabase.database().goOnline()
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                completion(nil, error)
                return
            }
            
            guard let uid = user?.uid else {
                assert(false, "no user uid")
                return
            }
            let values = ["email": email, "name": name]
            self.usersRef?.child(uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
                if error != nil {
                    completion(nil, error)
                    return
                }
                var userData = UserData()
                userData.uid = uid
                userData.email = email
                completion(userData, nil)
            })
        })
    }

    func userSigninWithEmailPassword(email: String, password: String, completion: @escaping (UserData?, Error?) -> Void) {
        FIRDatabase.database().goOnline()
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                completion(nil, error)
            } else {
                var userData = UserData()
                userData.uid = user?.uid
                completion(userData, nil)
            }
        })
    }
    
    func userSignInWithGoogle(_ idToken:String, _ accessToken: String, completion: @escaping (UserData?, Error?) -> Void) {
        FIRDatabase.database().goOnline()
        let credential = FIRGoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if let error = error {
                completion(nil, error)
            } else if let user = user {
                let email = user.email ?? ""
                let displayName = user.displayName ?? ""
                let gid = user.providerData[0].uid
                let photoURL = user.providerData[0].photoURL?.absoluteString ?? ""
                let values: [String: Any] = ["name": displayName, "email": email, "gid": gid, "photo": photoURL]
                self.usersRef?.child(user.uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
                    if let error = error {
                        completion(nil, error)
                    } else {
                        var userData = UserData()
                        userData.uid = user.uid
                        userData.gid = gid
                        userData.name = displayName
                        userData.email = email
                        userData.profileImageURL = photoURL
                        completion(userData, nil)
                    }
                })
            }
        })
    }
    
    func userSignInWithFacebook(_ viewController: UIViewController, completion: @escaping (UserData?, Error?) -> Void) {
        facebookModel.facebookLogin(viewController) { (success) in
            if success {
                if let accessToken = self.facebookModel.accessToken {
                    FIRDatabase.database().goOnline()
                    let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                    FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                        if let error = error {
                            completion(nil, error)
                        } else if let user = user {
                            let displayName = user.displayName ?? ""
                            let fid = user.providerData[0].uid
                            let email = user.providerData[0].email ?? ""
                            let photo = user.providerData[0].photoURL?.absoluteString ?? ""
                            let values = ["name": displayName, "email": email, "fid": fid, "photo": photo]
                            self.usersRef?.child(user.uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
                                if let error = error {
                                    completion(nil, error)
                                } else {
                                    var userData = UserData()
                                    userData.uid = user.uid
                                    userData.fid = fid
                                    userData.email = email
                                    userData.profileImageURL = photo
                                    completion(userData, nil)
                                }
                            })
                        }
                    })
                } else {
                    completion(nil, FirebaseError.invalidInput(message: "cannot retrieve facebook access token"))
                }
            } else {
                completion(nil, FirebaseError.invalidInput(message: "facebook fail to sign in"))
            }
        }
    }
    
    func userSignOut(completion: (Error?) -> Void) {
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
                completion(nil)
                FIRDatabase.database().goOffline()
            }
        } catch let signoutError {
            completion(signoutError)
        }
    }

    func fetchUserData(completion: @escaping (UserData?, Error?) -> Void) {
        guard let uid = authUser?.uid else {
            completion(nil, FirebaseError.invalidUser)
            return
        }
        
        usersRef?.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(uid) {
                snapshot.ref.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let data = snapshot.value as? [String: Any] {
                        if let name = data["name"] as? String, let email = data["email"] as? String {
                            var userData = UserData()
                            userData.uid = uid
                            userData.name = name
                            userData.email = email
                            completion(userData, nil)
                        }
                    }
                })
            } else {
                self.userSignOut(completion: { (error) in
                    
                })
                completion(nil, FirebaseError.invalidUser)
            }
        })
    }
    
    func fetchFloorPlanData(completion: @escaping (Any) -> Void) {
        databaseRef?.child("indoor-atlas-floorplan").observeSingleEvent(of: .value, with: { (snapshot) in
            if let floorData = snapshot.value as? [String: Any] {
                for data in floorData {
                    if let floors = data.value as? [String: Any] {
                        for floor in floors {
                            if let name = floor.value as? String, floor.key == "name" {
                                print(name)
                            }
                            if let waypoints = floor.value as? [String: [String: String]] {
                                completion(waypoints)
                                for waypoint in waypoints {
//                                    print(waypoint.value["name"])
//                                    print(waypoint.value["latitude"])
//                                    print(waypoint.value["longitude"])
                                }
                            }
                        }
                    }
                }
            }
        })
    }

}
