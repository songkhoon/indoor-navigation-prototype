//
//  HomeViewController.swift
//  IndoorNavigation
//
//  Created by jeff on 09/06/2017.
//  Copyright © 2017 jeff. All rights reserved.
//

import UIKit
import MapKit

public protocol HomeViewControllerDelegate {
    func showHistory()
    func showSetting()
    func signOut()
}

class HomeViewController: UIViewController, HomeViewControllerDelegate {

    let homeTitle = "Indoor Navigation"
    var userLocation: CLLocationCoordinate2D?

    let locationManager:CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        return manager
    }()
    
    let mapView:MKMapView = {
        let view = MKMapView()
        return view
    }()
    
    let menuViewController: MenuViewController = {
        let view = MenuViewController()
        return view
    }()
    
    let historyViewController: HistoryViewController = {
        let view = HistoryViewController()
        return view
    }()
    
    lazy var menuBarButton: UIBarButtonItem = {
        let btnShowMenu = UIButton(type: .system)
        btnShowMenu.tag = 0
        btnShowMenu.setImage(self.defaultMenuImage(), for: UIControlState())
        btnShowMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnShowMenu.addTarget(self, action: #selector(handleSlideMenuPress(_:)), for: .touchUpInside)
        let view = UIBarButtonItem(customView: btnShowMenu)
        return view
    }()
    
    lazy var backBarButton: UIBarButtonItem = {
        let view = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleBackButton))
        return view
    }()
    
    var zoomLevel: Int {
        get {
            return Int(log2(360 * (Double(self.mapView.frame.size.width/256) / self.mapView.region.span.longitudeDelta)) + 1);
        }
        
        set (newZoomLevel){
            setCenterCoordinate(coordinate: self.mapView.centerCoordinate, zoomLevel: newZoomLevel, animated: false)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.title = homeTitle
        
        addSlideMenuButton()
        setupMapView()
        menuViewController.homeViewControllerDelegate = self
    }
    
    private func addSlideMenuButton() {
        navigationItem.leftBarButtonItem = menuBarButton
    }
    
    private func setupMapView() {
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.showsUserLocation = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        locationManager.delegate = self
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
    }
    
    private func defaultMenuImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 30, height: 22), false, 0)
        
        UIColor.black.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 3, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 10, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 17, width: 30, height: 1)).fill()
        
        UIColor.white.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 4, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 11, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 18, width: 30, height: 1)).fill()
        
        let defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return defaultMenuImage
    }
    
    @objc
    private func handleSlideMenuPress(_ sender: UIButton) {
        if childViewControllers.contains(menuViewController) {
            menuViewController.hideMenu()
        } else {
            view.addSubview(menuViewController.view)
            addChildViewController(menuViewController)
            menuViewController.showMenu()
        }
    }
    
    @objc
    private func handleBackButton() {
        UIView.animate(withDuration: 0.5, animations: { 
            self.view.frame.origin.x = 0
        }) { (complete) in
            self.historyViewController.removeFromParentViewController()
            self.historyViewController.view.removeFromSuperview()
            self.navigationItem.title = self.homeTitle
            self.addSlideMenuButton()
        }
    }
    
    private func setCenterCoordinate(coordinate: CLLocationCoordinate2D, zoomLevel: Int, animated: Bool){
        let span = MKCoordinateSpanMake(0, 360 / pow(2, Double(zoomLevel)) * Double(self.mapView.frame.size.width) / 256)
        mapView.setRegion(MKCoordinateRegionMake(mapView.centerCoordinate, span), animated: animated)
    }
    
    func showHistory() {
        addChildViewController(historyViewController)
        view.addSubview(historyViewController.view)
        historyViewController.view.frame.origin.x = view.frame.width
        UIView.animate(withDuration: 0.5, animations: {
            self.view.frame.origin.x = -self.view.frame.width
        }) { (complete) in
            self.navigationItem.title = "History"
            self.navigationItem.leftBarButtonItem = self.backBarButton
        }
    }
    
    func showSetting() {
        
    }
    
    func signOut() {
        let viewController = ViewController()
        viewController.signOut()
        present(viewController, animated: true) {
            
        }
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("didChangeAuthorization: \(mapView.userLocation)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations", mapView.userLocation.coordinate)
        if let location = manager.location {
            if userLocation == nil {
                userLocation = location.coordinate
                mapView.setCenter(location.coordinate, animated: false)
                locationManager.stopUpdatingLocation()
            }
            zoomLevel = 20
        } else {
            print("location not found")
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError: \(error.localizedDescription)")
    }
}

extension HomeViewController: MKMapViewDelegate {
}
