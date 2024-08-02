//
//  PassengerHomeViewController.swift
//  Driveme_iOS
//
//  Created by Aditya on 2024-08-02.
//

import UIKit
import MapKit
import CoreLocation

class PassengerHomeViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
                
                // Request location access
                locationManager.requestWhenInUseAuthorization()
                
                // Start updating location
                locationManager.startUpdatingLocation()
                
                // Show user location on the map
                mapView.showsUserLocation = true

        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let userLocation = locations.first {
                let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                mapView.setRegion(region, animated: true)
            }
        }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                locationManager.startUpdatingLocation()
            case .denied, .restricted:
                // Handle case where user denied location access
                print("Location access denied or restricted.")
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            @unknown default:
                fatalError()
            }
        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
