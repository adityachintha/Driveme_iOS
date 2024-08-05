//
//  DriverListViewController.swift
//  Driveme_iOS
//
//  Created by Aditya on 2024-08-02.
//

import UIKit
import CoreData

class DriverListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var context: NSManagedObjectContext!
    var drivers: [User] = []
    var newRide: Ride?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        tableView.delegate = self
        tableView.dataSource = self
        
        fetchDrivers()
        
    }
    
    func fetchDrivers() {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "role == %@", "Driver")
        
        do {
            drivers = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Failed to fetch drivers: \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drivers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DriverCell", for: indexPath) as? DriverTableViewCell else {
            fatalError("Unable to dequeue DriverTableViewCell")
        }
        let driver = drivers[indexPath.row]
        cell.driverNameLabel.text = driver.name
        print("Dequeued cell for driver: \(String(describing: driver.name))")
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDriver = drivers[indexPath.row]
        newRide?.driverName = selectedDriver.name
        newRide?.status = "Waiting for Confirmation"
        
        do {
            try context.save()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let successVC = storyboard.instantiateViewController(withIdentifier: "SuccessViewController") as? SuccessViewController {
                successVC.ride = newRide
                navigationController?.pushViewController(successVC, animated: true)
                }
        } catch {
            print("Failed to update ride: \(error)")
        }
    }
    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            // Assuming this method is triggered when a driver is selected
//            if let ride = newRide {
//                navigateToSuccess(ride: ride)
//            }
//        }
//
//    func navigateToSuccess(ride: Ride) {
//        // Pop to root view controller
//        navigationController?.popToRootViewController(animated: false)
//        
//        // Now push the SuccessViewController
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            if let successVC = storyboard.instantiateViewController(withIdentifier: "SuccessViewController") as? SuccessViewController {
//                successVC.ride = ride
//                self.navigationController?.pushViewController(successVC, animated: true)
//            }
//        }
//    }
}
