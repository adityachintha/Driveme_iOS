//
//  DriverProfileViewController.swift
//  Driveme_iOS
//
//  Created by Aditya on 2024-08-02.
//

import UIKit
import CoreData

class DriverProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var currentUser: User?

        override func viewDidLoad() {
            super.viewDidLoad()
            
            fetchCurrentUser()
            displayUserInfo()
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
            profileImageView.isUserInteractionEnabled = true
            profileImageView.addGestureRecognizer(tapGestureRecognizer)
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
        
        func displayUserInfo() {
            guard let user = currentUser else { return }
            nameLabel.text = user.name
            emailLabel.text = user.email
            if let profilePictureData = user.profilePicture {
                profileImageView.image = UIImage(data: profilePictureData)
            } else {
                profileImageView.image = UIImage(named: "defaultProfileImage")
            }
        }
        
        @objc func profileImageTapped() {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            present(imagePickerController, animated: true, completion: nil)
        }
        
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedImage = info[.originalImage] as? UIImage {
                profileImageView.image = pickedImage
                saveProfilePicture(image: pickedImage)
            }
            dismiss(animated: true, completion: nil)
        }
        
        func saveProfilePicture(image: UIImage) {
            guard let user = currentUser else { return }
            if let imageData = image.pngData() {
                user.profilePicture = imageData
                do {
                    try context.save()
                    print("Profile picture saved successfully!")
                } catch {
                    print("Failed to save profile picture: \(error)")
                }
            }
        }
    
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        
        UserDefaults.standard.removeObject(forKey: "currentUserEmail")
                
                // Navigate to login screen
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                    navigationController?.pushViewController(loginVC, animated: true)
                }
    }
    

}
