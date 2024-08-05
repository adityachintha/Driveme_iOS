//
//  PassengerHomeViewController.swift
//  Driveme_iOS
//
//  Created by Aditya on 2024-08-02.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class PassengerHomeViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var pickupTextField: UITextField!
    @IBOutlet weak var dropOffTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
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

    }
    
    @IBAction func scheduleNowButtonTapped(_ sender: Any) {
        presentRideDetailsPopup()
    }
    
    func presentRideDetailsPopup() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let rideDetailsVC = storyboard.instantiateViewController(withIdentifier: "RideDetailsViewController") as? RideDetailsViewController {
            
            let newRide = createNewRide()
            rideDetailsVC.ride = newRide
            navigationController?.pushViewController(rideDetailsVC, animated: true)

        }
    }
        
    
    func createNewRide() -> Ride {
            let pickupLocation = pickupTextField.text ?? ""
            let dropOffLocation = dropOffTextField.text ?? ""
            
            let passengerName = fetchPassengerName()
            
            let newRide = Ride(context: context)
            newRide.pickupLocation = pickupLocation
            newRide.dropOffLocation = dropOffLocation
            newRide.passengerName = passengerName
            newRide.status = "Initiated"
            
            
            print("Created new Ride with details: \(newRide)")
            print("Passenger Name: \(passengerName)")
            
            return newRide
            
        }
    
    
    
    func fetchPassengerName() -> String {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        if let currentUserEmail = UserDefaults.standard.string(forKey: "currentUserEmail") {
            fetchRequest.predicate = NSPredicate(format: "email == %@", currentUserEmail)
        } else {
                return "Unknown"
                }
        
        
        do {
            let users = try context.fetch(fetchRequest)
            if let passengerName = users.first?.name {
                print("Fetched Passenger Name: \(passengerName)")
                return passengerName
            } else {
                print("No user found with email")
                return "Unknown"
            }
        } catch {
            print("Failed to fetch user: \(error)")
            return "Unknown"
        }
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
}
