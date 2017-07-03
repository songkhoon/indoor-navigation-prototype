//
//  IndoorNavigationTests.swift
//  IndoorNavigationTests
//
//  Created by jeff on 08/06/2017.
//  Copyright © 2017 jeff. All rights reserved.
//

import XCTest

@testable import IndoorNavigation
import Firebase

class IndoorNavigationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        FIRDatabase.database().goOnline()
    }
    
    func testFirebase() {
        FIRAuth.auth()?.signIn(withEmail: "jeff@gmail.com", password: "123456", completion: { (user, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                
            }
        })
        let databaseRef = FIRDatabase.database().reference()
        print(databaseRef)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testUserSignInWithEmailPassword() {
        let longRunningExpectation = expectation(description: "SignInUserWithEmailPassword")
        let service = FirebaseService()
        service.userSigninWithEmailPassword(email: "jeff@gmail.com", password: "123456") { (user, error) in
            XCTAssertNil(error)
            if let error = error {
                print(error.localizedDescription)
            } else if let user = user {
                print(user.uid)
            }
            longRunningExpectation.fulfill()
        }
        
        
        waitForExpectations(timeout: 20) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
        }
    }
    
    func testUserAuthentication() {
        let longRunningExpectation = expectation(description: "CheckUserAuthentication")
        let service = FirebaseService()
        service.checkAuthUser { (isAuth) in
            longRunningExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 20) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func testFetchFloorPlanData() {
        let longRunningExceptation = expectation(description: "FetchFloorPlanData")
        let service = FirebaseService()
        service.fetchFloorPlanData { (floorplanData) in
            if let floorplanData = floorplanData as? [String: Any] {
                for waypoints in floorplanData {
                    if let waypoint = waypoints.value as? [String: String] {
                        XCTAssertNotNil(waypoint["name"])
                        XCTAssertNotNil(waypoint["latitude"])
                        XCTAssertNotNil(waypoint["longitude"])
                        print(waypoint["name"], waypoint["latitude"], waypoint["longitude"])
                    }
                }
            }
            longRunningExceptation.fulfill()
        }
        
        waitForExpectations(timeout: 20) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func testPalindrome() {
        let str = "aabaa"
        print(String(str.characters.reversed()))

    }
    
}
