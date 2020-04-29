//
//  JoinChallengeViewController.swift
//  DareFit
//
//  Created by Abdalla Elshikh on 4/29/20.
//  Copyright © 2020 Abdalla Elshikh. All rights reserved.
//

import UIKit

class JoinChallengeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView(){
       
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        signOut()
    }
    
    
    func signOut(){
        Authentication.signOut { (error) in
            guard error == nil else{
                self.showAlert(title: "Error", message: "Can't logout at the moment")
                return
            }
            //logout
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertVC, animated: true)
    }
    
}
