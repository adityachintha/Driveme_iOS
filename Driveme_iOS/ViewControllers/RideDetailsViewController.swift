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
    
    var saveDetailsCallback: ((String, String, Date) -> Void)?
    
    var pickupLocation: String?
    var dropOffLocation: String?
    var passengerName: String?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        carModelPicker.delegate = self
        carModelPicker.dataSource = self
        transmissionPicker.delegate = self
        transmissionPicker.dataSource = self
        
    }
    

    @IBAction func nextButtonTapped(_ sender: Any) {
        let selectedCarModel = carModels[carModelPicker.selectedRow(inComponent: 0)]
        let selectedTransmission = transmissions[transmissionPicker.selectedRow(inComponent: 0)]
        let selectedDate = datePicker.date
        
        saveDetailsCallback?(selectedCarModel, selectedTransmission, selectedDate)
        
        if let pickupLocation = pickupLocation, let dropOffLocation = dropOffLocation, let passengerName = passengerName {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let driverListVC = storyboard.instantiateViewController(withIdentifier: "DriverListViewController") as? DriverListViewController {
                        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                        
                        let newRide = Ride(context: context)
                        newRide.pickupLocation = pickupLocation
                        newRide.dropOffLocation = dropOffLocation
                        newRide.carModel = selectedCarModel
                        newRide.carTransmission = selectedTransmission
                        newRide.date = selectedDate
                        newRide.passengerName = passengerName
                        newRide.status = "Initiated"
                        
                        driverListVC.context = context
                        driverListVC.newRide = newRide
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
