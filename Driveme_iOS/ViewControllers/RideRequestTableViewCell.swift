//
//  RideRequestTableViewCell.swift
//  Driveme_iOS
//
//  Created by Aditya on 2024-08-05.
//

import UIKit

class RideRequestTableViewCell: UITableViewCell {

    
    @IBOutlet weak var pickupLocationLabel: UILabel!
    
    
    @IBOutlet weak var dropOffLocationlabel: UILabel!
    
    
    @IBOutlet weak var carModelLabel: UILabel!
    
    
    @IBOutlet weak var transmissionLabel: UILabel!
    
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var acceptButton: UIButton!
    
    @IBOutlet weak var rejectButton: UIButton!
    var acceptAction: (() -> Void)?
    var rejectAction: (() -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    @IBAction func acceptButtonTapped(_ sender: Any) {
        acceptAction?()
    }
    
    @IBAction func rejectButtonTapped(_ sender: Any) {
        rejectAction?()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func hideActionButtons() {
           acceptButton.isHidden = true
           rejectButton.isHidden = true
       }

}
