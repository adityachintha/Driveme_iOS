//
//  LoginViewController.swift
//  Driveme_iOS
//
//  Created by Aditya on 2024-07-18.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var roleSegmentedControl: UISegmentedControl!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let selectedRoleIndex = roleSegmentedControl.selectedSegmentIndex
        let role = selectedRoleIndex == 0 ? "Passenger" : "Driver"
        
        if authenticateUser(email: email, password: password, role: role){
            navigateToRoleBasedScreen(role: role)
        } else {
            showAlert(message: "Email or Password  or Role Selection is Incorrect")
        }
        
    }
    
    @IBAction func navigateToRegister(_ sender: Any) {
        
        let storyboard = UIStoryboard(name:"Main", bundle:nil)
        if let registerVC = storyboard.instantiateViewController(withIdentifier: "RegistrationViewController") as? RegistrationViewController {
            navigationController?.pushViewController(registerVC, animated: true)
        }
    }
    
    
    func authenticateUser (email:String, password:String, role: String) -> Bool {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.predicate = NSPredicate(format: "email == %@ AND password == %@ AND role ==%@", email, password, role)
        request.fetchLimit = 1
        
        do {
            let result = try context.fetch(request)
            return result.count == 1
        } catch {
            print("Failed to fetch user data")
            return false
        }
    }
    
    func navigateToRoleBasedScreen (role:String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if role == "Passenger"{
            if let passengerVC = storyboard.instantiateViewController(withIdentifier: "PassengerViewController") as? PassengerViewController {
                navigationController?.pushViewController(passengerVC, animated: true)
            }
        } else {
            if let driverVC = storyboard.instantiateViewController(withIdentifier: "DriverViewController") as? DriverViewController {
                navigationController?.pushViewController(driverVC, animated: true)
            }
        }
    }
    
    func showAlert(message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
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
