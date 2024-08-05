//
//  BookingTableViewCell.swift
//  Driveme_iOS
//
//  Created by Aditya on 2024-08-04.
//

import UIKit

class BookingTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var pickupLocationLabel: UILabel!
    @IBOutlet weak var dropoffLocationLabel: UILabel!
    @IBOutlet weak var carModelLabel: UILabel!
    @IBOutlet weak var carTransmissionLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with ride: Ride) {
            pickupLocationLabel.text = ride.pickupLocation
            dropoffLocationLabel.text = ride.dropOffLocation
            carModelLabel.text = ride.carModel
            carTransmissionLabel.text = ride.carTransmission
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            dateLabel.text = dateFormatter.string(from: ride.date ?? Date())
            
            statusLabel.text = ride.status
        }

}
