//
//  PassengerViewController.swift
//  Driveme_iOS
//
//  Created by Aditya on 2024-07-18.
//

import UIKit

class PassengerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for:.documentDirectory, in: .userDomainMask))

        // Do any additional setup after loading the view.
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
