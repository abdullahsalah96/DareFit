//
//  SignUpViewController.swift
//  DareFit
//
//  Created by Abdalla Elshikh on 4/29/20.
//  Copyright © 2020 Abdalla Elshikh. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView(){
        errorLabel.isHidden = true
    }
    
    // A function that validates all the fields entered by the user
    func validateFields()->String?{
        if firstNameTextField.text?.trimmingCharacters(in: .whitespaces) == ""{
            return "Please Enter your First Name"
        }else if lastNameTextField.text?.trimmingCharacters(in: .whitespaces) == ""{
            return "Please Enter your Last Name"
        }else if emailTextField.text?.trimmingCharacters(in: .whitespaces) == ""{
            return "Please Enter your Email"
        }else if !Authentication.isValidPassword(password: passwordTextField.text!){
            return "Invalid Password, Passwords should be of at least 8 characters containing uppercase/lowercase letters, a number and a special character"
        }else{
            return nil
        }
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        let error = validateFields()
        if error == nil{
            //all fields are filled - sign up user
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespaces)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespaces)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespaces)
            let password = passwordTextField.text!
            signUp(firstName: firstName, lastName: lastName, email: email, password: password)
        }else{
           showError(error: error!)
        }
    }
    
    func signUp(firstName: String, lastName: String, email:String, password:String){
        Authentication.signUp(firstName: firstName, lastName: lastName, email: email, password: password) { (error) in
            guard error == nil else{
                self.showError(error: error!)
                return
            }
            self.errorLabel.isHidden = true
            //fetching user data
            Authentication.getUserData(completion: {
                (error) in
                //error getting user data
                guard error == nil else{
                    self.showError(error: error!)
                    return
                }
                self.performSegue(withIdentifier: Constants.SegueIDs.home, sender: nil)
            })
        }
    }
    
    func showError(error: String){
        errorLabel.isHidden = false
        errorLabel.text = error
    }
    
}
