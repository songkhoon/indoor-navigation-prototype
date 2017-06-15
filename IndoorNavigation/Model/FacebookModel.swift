//
//  FacebookModel.swift
//  IndoorNavigation
//
//  Created by jeff on 14/06/2017.
//  Copyright © 2017 jeff. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit

class FacebookModel {
    
    let facebookManager = FBSDKLoginManager()
    var accessToken: FBSDKAccessToken? {
        get {
            return FBSDKAccessToken.current()
        }
    }
    
    func facebookLogin(_ viewController:UIViewController, completion: @escaping (Bool) -> Void) {
        facebookManager.logIn(withReadPermissions: ["public_profile", "email"], from: viewController) { (result, error) in
            if let error = error {
                print("facebook login error. \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(result != nil)
        }
    }
    
    func facebookLogout() {
        facebookManager.logOut()
    }
    
}
