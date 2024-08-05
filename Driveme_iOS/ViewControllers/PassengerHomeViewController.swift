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
            
            rideDetailsVC.pickupLocation = pickupTextField.text ?? ""
            rideDetailsVC.dropOffLocation = dropOffTextField.text ?? ""
            rideDetailsVC.passengerName = fetchPassengerName() // Pass the passenger name
            
            rideDetailsVC.saveDetailsCallback = { [weak self] carModel, transmission, date in
                self?.saveRideDetails(carModel: carModel, transmission: transmission, date: date)
            }
           
            
            print("Pickup Location In Home: \(pickupTextField.text ?? "nil")")
            print("Drop Off Location In Home: \(dropOffTextField.text ?? "nil")")
            

            navigationController?.pushViewController(rideDetailsVC, animated: true)

        }
    }
        
    
    func saveRideDetails(carModel: String, transmission: String, date: Date) {
            let pickupLocation = pickupTextField.text ?? ""
            let dropOffLocation = dropOffTextField.text ?? ""
            
            let passengerName = fetchPassengerName()
            
            let newRide = Ride(context: context)
            newRide.pickupLocation = pickupLocation
            newRide.dropOffLocation = dropOffLocation
            newRide.passengerName = passengerName
            newRide.carModel = carModel
            newRide.carTransmission = transmission
            newRide.date = date
            newRide.status = "Initiated"
            
            
            print("Passenger Name: \(passengerName)")
            print("Saving Ride with details: \(newRide)")
            
            do {
                try context.save()
                print("Ride saved successfully!")
              
            } catch{
                print("Failed to Save Ride:\(error)")
            }
            
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
