//
//  SuccessViewController.swift
//  Driveme_iOS
//
//  Created by Aditya on 2024-08-03.
//

import UIKit

class SuccessViewController: UIViewController {
    
    @IBOutlet weak var pickupLocationLabel: UILabel!
    @IBOutlet weak var dropOffLocationLabel: UILabel!
    @IBOutlet weak var carModelLabel: UILabel!
    @IBOutlet weak var transmissionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    

    
    var ride: Ride?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let ride = ride {
                    pickupLocationLabel.text = ride.pickupLocation
                    dropOffLocationLabel.text = ride.dropOffLocation
                    carModelLabel.text = ride.carModel
                    transmissionLabel.text = ride.carTransmission
                    dateLabel.text = DateFormatter.localizedString(from: ride.date ?? Date(), dateStyle: .medium, timeStyle: .short)
                    driverNameLabel.text = ride.driverName
                    statusLabel.text = ride.status
                    }
                }
    
    
    @IBAction func goToHomeButtonTapped(_ sender: Any) {
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    
            }


    
    
    

