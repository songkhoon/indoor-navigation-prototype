//
//  GoogleModel.swift
//  IndoorNavigation
//
//  Created by jeff on 15/06/2017.
//  Copyright © 2017 jeff. All rights reserved.
//

import Foundation
import GoogleSignIn

class GoogleModel {
    
    init(firebaseClientID clientID:String) {
        GIDSignIn.sharedInstance().clientID = clientID
    }
    
    func signOut() {
        GIDSignIn.sharedInstance().signOut()
    }
    
}
