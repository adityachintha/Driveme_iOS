//
//  DriverRequestsViewController.swift
//  Driveme_iOS
//
//  Created by Aditya on 2024-08-02.
//

import UIKit
import CoreData

class DriverRequestsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    var rides: [Ride] = []
    var currentUser: User?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
                
        fetchCurrentUser()
        fetchRides()
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    func fetchCurrentUser() {
            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            if let currentUserEmail = UserDefaults.standard.string(forKey: "currentUserEmail") {
                fetchRequest.predicate = NSPredicate(format: "email == %@", currentUserEmail)
                
                do {
                    let users = try context.fetch(fetchRequest)
                    currentUser = users.first
                } catch {
                    print("Failed to fetch user: \(error)")
                }
            }
        }
    
    func fetchRides() {
            guard let driverName = currentUser?.name else { return }
            
            let fetchRequest: NSFetchRequest<Ride> = Ride.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "driverName == %@", driverName)
        
            let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            do {
                rides = try context.fetch(fetchRequest)
            } catch {
                print("Failed to fetch rides: \(error)")
            }
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return rides.count
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RideRequestCell", for: indexPath) as! RideRequestTableViewCell
            let ride = rides[indexPath.row]
            
            cell.pickupLocationLabel.text = ride.pickupLocation
            cell.dropOffLocationlabel.text = ride.dropOffLocation
            cell.carModelLabel.text = ride.carModel
            cell.transmissionLabel.text = ride.carTransmission
            cell.statusLabel.text = ride.status
            
            cell.acceptAction = { [weak self] in
                self?.updateRideStatus(for: ride, to: "Confirmed")
            }
            
            cell.rejectAction = { [weak self] in
                self?.updateRideStatus(for: ride, to: "Rejected")
            }
            
            if ride.status == "Confirmed" || ride.status == "Rejected" {
                    cell.hideActionButtons()
                } else {
                    cell.acceptButton.isHidden = false
                    cell.rejectButton.isHidden = false
                }
            
            return cell
        }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 300
        }
    
    func updateRideStatus(for ride: Ride, to status: String) {
            ride.status = status
            
            do {
                try context.save()
                tableView.reloadData()
                print("Ride status updated to \(status)")
            } catch {
                print("Failed to update ride status: \(error)")
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
