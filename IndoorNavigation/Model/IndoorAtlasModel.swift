//
//  IndoorAtlasModel.swift
//  IndoorNavigation
//
//  Created by jeff on 15/06/2017.
//  Copyright © 2017 jeff. All rights reserved.
//

import Foundation
import IndoorAtlas

protocol IndoorAtlasModelDelegate {
    
    func fetchFloorPlanResponse(_ floorPlan: IAFloorPlan?, _ error: Error?)
    func updateLocationResponse(_ location: CLLocationCoordinate2D)
    
}

class IndoorAtlasModel: NSObject {
    
    // API keys can be generated at <http://developer.indooratlas.com/applications>
    let kAPIKey = "b9f85254-b372-477e-87e9-626accb3b31f"
    let kAPISecret = "j1G7gPYYiE2g6QudwUIiQGuuUBB9mH5mtgoW5GEodxEKYCFqqgbmWz2oF5TY81ZlbA80B1UHheiv9JqfIU5NlcxnKNza+fJRqyVc8W7ivnX+etcRmyraDXPC738Dwg=="
    
    // Floor plan id is same as "FloorplanId" at the <http://developer.indooratlas.com/venues>
    let kFloorplanId = "ad176ace-3f74-40f1-9af3-bfee61e27c30"
    
    let locationManager = IALocationManager.sharedInstance()
    var resourceManger: IAResourceManager?
    fileprivate var floorPlanFetch:IAFetchTask?

    var delegate: IndoorAtlasModelDelegate?

    override init() {
        super.init()
        guard kAPIKey.characters.count > 0 || kAPISecret.characters.count > 0 else {
            print("Configure API key and API secret inside ApiKeys.swift")
            return
        }
        
        guard kFloorplanId.characters.count > 0 else {
            print("Configure floor plan id inside ApiKeys.swift")
            return
        }
        
        authenticateIALocationManager()
        let location = IALocation(floorPlanId: kFloorplanId)
        locationManager.location = location
        locationManager.delegate = self
        resourceManger = IAResourceManager(locationManager: locationManager)!
    }
    
    private func authenticateIALocationManager() {
        // Get IALocationManager shared instance
        let manager = IALocationManager.sharedInstance()
        
        // Set IndoorAtlas API key and secret
        manager.setApiKey(kAPIKey, andSecret: kAPISecret)
    }
    
    func requestLocation() {
        locationManager.startUpdatingLocation()
    }
    
}

extension IndoorAtlasModel: IALocationManagerDelegate {
    
    func indoorLocationManager(_ manager: IALocationManager, didEnter region: IARegion) {
        guard region.type == kIARegionTypeFloorPlan else { return }
        floorPlanFetch?.cancel()
        
        floorPlanFetch = resourceManger?.fetchFloorPlan(withId: region.identifier, andCompletion: { (floorPlan, error) in
            if let error = error {
                print("There was an error during floorplan fetch: \(error.localizedDescription)")
                self.delegate?.fetchFloorPlanResponse(nil, error)
            } else {
                self.delegate?.fetchFloorPlanResponse(floorPlan, nil)
            }
        })
    }
    
    func indoorLocationManager(_ manager: IALocationManager, didUpdateLocations locations: [Any]) {
        // Convert last location to IALocation
        let last = locations.last as! IALocation
        
        // Check that the location is not nil
        if let newLocation = last.location?.coordinate {
            delegate?.updateLocationResponse(newLocation)
        }
    }
    
}
