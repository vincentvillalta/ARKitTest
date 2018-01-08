//
//  MapViewController.swift
//  ARKitDemo
//
//  Created by Vincent Villalta on 1/8/18.
//  Copyright © 2018 Vincent Villalta. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    // MARK: - Variables
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var showARButton: RoundedButton!
    var locationManager = CLLocationManager()
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else if CLLocationManager.authorizationStatus() == .denied {
            self.showSttings()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    // MARK: - LocationManager delegates
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
            case .notDetermined:
                print("NotDetermined")
            case .restricted:
                print("Restricted")
                self.showSttings()
            case .denied:
                print("Denied")
                self.showSttings()
            case .authorizedAlways:
                print("AuthorizedAlways")
            case .authorizedWhenInUse:
                print("AuthorizedWhenInUse")
                locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let coordinateRegion = MKCoordinateRegion.init(center: (locations.last?.coordinate)!, span: MKCoordinateSpanMake(50, 50))
        mapView.setRegion(coordinateRegion, animated: true)
        locationManager.stopUpdatingLocation()
        self.showARButton.isHidden = false
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to initialize GPS: ", error)
    }

    
    
    // MARK: - Actions
    @IBAction func show(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ARViewViewController") as! ARViewViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func showSttings(){
        let alertController = UIAlertController (title: "Location permissions", message: "In order to fully enjoy this app you have to provide location services permissions", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Go to settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)")
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    

}
