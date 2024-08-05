//
//  PassengerBookingsViewController.swift
//  Driveme_iOS
//
//  Created by Aditya on 2024-08-02.
//

import UIKit
import CoreData

class PassengerBookingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var bookings: [Ride] = []
    
    var currentUserEmail: String? {
        return UserDefaults.standard.string(forKey: "currentUserEmail")
        }
    
    var currentUserName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchCurrentUser()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            fetchBookings()
        }
    
    
    func fetchCurrentUser() {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            
            if let currentUserEmail = currentUserEmail {
                fetchRequest.predicate = NSPredicate(format: "email == %@", currentUserEmail)
                
                do {
                    let users = try context.fetch(fetchRequest)
                    currentUserName = users.first?.name
                    print("Current User Name: \(String(describing: currentUserName))")
                    fetchBookings()
                } catch {
                    print("Failed to fetch user: \(error)")
                }
            }
        }
    
    
    func fetchBookings() {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Ride>(entityName: "Ride")
        
            let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
        
            if let currentUserName = currentUserName {
                    print("Current User Name for fetching bookings: \(currentUserName)")  // Debug statement
                    let predicate = NSPredicate(format: "passengerName == %@", currentUserName)
                    fetchRequest.predicate = predicate
                } else {
                    print("No user is currently logged in.")
                    
                    return
                }
            
            
            do {
                bookings = try managedContext.fetch(fetchRequest)
                print("Fetched \(bookings.count) bookings.")
                
                for booking in bookings {
                    print("Booking: \(booking)")
                    }
                tableView.reloadData()
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookingCell", for: indexPath) as! BookingTableViewCell
            let booking = bookings[indexPath.row]
            
            cell.dateLabel.text = formatDate(date: booking.date)
            cell.pickupLocationLabel.text = booking.pickupLocation
            cell.dropoffLocationLabel.text = booking.dropOffLocation
            cell.carModelLabel.text = booking.carModel
            cell.carTransmissionLabel.text = booking.carTransmission
            cell.statusLabel.text = booking.status
            
            return cell
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 240 // Set your desired cell height here
        }
    
    func formatDate(date: Date?) -> String {
            guard let date = date else { return "N/A" }
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
    
//    private func fetchRecentRides() {
//            let fetchRequest: NSFetchRequest<Ride> = Ride.fetchRequest()
//            let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
//            fetchRequest.sortDescriptors = [sortDescriptor]
//
//            do {
//                if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
//                    rides = try context.fetch(fetchRequest)
//                    tableView.reloadData()
//                }
//            } catch {
//                print("Failed to fetch rides: \(error)")
//            }
//        }

}

//    extension PassengerBookingsViewController: UITableViewDelegate, UITableViewDataSource {
//        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return rides.count
//        }
//
//        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookingCell", for: indexPath) as? BookingTableViewCell else {
//                return UITableViewCell()
//            }
//            let ride = rides[indexPath.row]
//            cell.configure(with: ride)
//            return cell
//        }
//        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//                return 240 // Set your desired cell height here
//            }
//    }
