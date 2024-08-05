//
//  RideDetailsViewController.swift
//  Driveme_iOS
//
//  Created by Aditya on 2024-08-02.
//

import UIKit

class RideDetailsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var carModelPicker: UIPickerView!
    @IBOutlet weak var transmissionPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
   
    var carModels = ["Sedan", "Hatchback","Cruiser", "Limo", "Mini"]
    var transmissions = ["Automatic", "Manual", "Semi-Automatic"]
    
    var ride: Ride?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        carModelPicker.delegate = self
        carModelPicker.dataSource = self
        transmissionPicker.delegate = self
        transmissionPicker.dataSource = self
        
    }
    

    @IBAction func nextButtonTapped(_ sender: Any) {
        
        guard let ride = ride else {
                    print("No ride available to update")
                    return
                }
        let selectedCarModel = carModels[carModelPicker.selectedRow(inComponent: 0)]
        let selectedTransmission = transmissions[transmissionPicker.selectedRow(inComponent: 0)]
        let selectedDate = datePicker.date
        
        ride.carModel = selectedCarModel
        ride.carTransmission = selectedTransmission
        ride.date = selectedDate
        
        if let pickupLocation = ride.pickupLocation, let dropOffLocation = ride.dropOffLocation, let passengerName = ride.passengerName {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let driverListVC = storyboard.instantiateViewController(withIdentifier: "DriverListViewController") as? DriverListViewController {
                        
                        driverListVC.context = ride.managedObjectContext
                        driverListVC.newRide = ride
                        navigationController?.pushViewController(driverListVC, animated: true)
                    }
                } else {
                    print("Pickup or Drop Off location is nil")
                }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return pickerView == carModelPicker ? carModels.count : transmissions.count
        }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return pickerView == carModelPicker ? carModels[row] : transmissions[row]
        }
        
    

}
