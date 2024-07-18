//
//  RegistrationViewController.swift
//  Driveme_iOS
//
//  Created by Aditya on 2024-07-18.
//

import UIKit
import CoreData

class RegistrationViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    @IBOutlet weak var roleSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBAction func registerButtonTapped(_ sender: Any) {
        let name = nameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let confirmPassword = confirmPasswordTextField.text ?? ""
        let selectedRoleIndex = roleSegmentedControl.selectedSegmentIndex
        let role = selectedRoleIndex == 0 ? "Passenger" : "Driver"
        
        if password != confirmPassword {
            showAlert(message: "Password did not match")
            return
        }
        
        if isEmailTaken(email: email) {
            showAlert(message: "Email is already registered")
            return
        }
        
        let newUser = User(context: context)
        newUser.name = name
        newUser.email = email
        newUser.password = password
        newUser.role = role
        
        do {
            try context.save()
            showAlert(message: "Registration Successful", completion: { self.navigationController?.popViewController(animated: true)})
        } catch {
            showAlert(message: "Failed to save user")
        }
    }
    
    func isEmailTaken(email: String) -> Bool {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            request.predicate = NSPredicate(format: "email == %@", email)
            request.fetchLimit = 1
            
            do {
                let result = try context.fetch(request)
                return result.count > 0
            } catch {
                print("Failed to fetch user: \(error)")
                return false
            }
        }
    
    func showAlert(message: String, completion: (() -> Void)? = nil) {
            let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                completion?()
            }))
            present(alert, animated: true, completion: nil)
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


