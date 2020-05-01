//
//  SignUpViewController.swift
//  DareFit
//
//  Created by Abdalla Elshikh on 4/29/20.
//  Copyright © 2020 Abdalla Elshikh. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView(){
        errorLabel.isHidden = true
        styleTextField(textField: firstNameTextField)
        styleTextField(textField: lastNameTextField)
        styleTextField(textField: emailTextField)
        styleTextField(textField: passwordTextField)
        styleTextField(textField: urlTextField)
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func styleTextField(textField: UITextField){
        textField.layer.masksToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.layer.cornerRadius = 25
        textField.layer.shadowRadius = 50
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.systemBlue.cgColor
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOffset = CGSize(width: 2, height: 2)
        textField.layer.shadowOpacity = 1.0
    }
    
    
    // A function that validates all the fields entered by the user
    func validateFields()->String?{
        if firstNameTextField.text?.trimmingCharacters(in: .whitespaces) == ""{
            return "Please Enter your First Name"
        }else if lastNameTextField.text?.trimmingCharacters(in: .whitespaces) == ""{
            return "Please Enter your Last Name"
        }else if emailTextField.text?.trimmingCharacters(in: .whitespaces) == ""{
            return "Please Enter your Email"
        }else if urlTextField.text?.trimmingCharacters(in: .whitespaces) == ""{
            return "Please a valid website"
        }else if !Authentication.isValidPassword(password: passwordTextField.text!){
            return "Invalid Password, Passwords should be of at least 8 characters containing uppercase/lowercase letters, a number and a special character"
        }else{
            return nil
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        let error = validateFields()
        if error == nil{
            //all fields are filled - sign up user
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespaces)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespaces)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespaces)
            let password = passwordTextField.text!
            let url = urlTextField.text!
            signUp(firstName: firstName, lastName: lastName, email: email, password: password, url:url)
        }else{
           showError(error: error!)
        }
    }
    
    func signUp(firstName: String, lastName: String, email:String, password:String, url:String){
        self.signUpButton.isEnabled = false
        Authentication.signUp(firstName: firstName, lastName: lastName, email: email, password: password, url: url, long: CurrentUser.currentUser.longitude, lat: CurrentUser.currentUser.latitude) { (error) in
            guard error == nil else{
                self.signUpButton.isEnabled = true
                self.showError(error: error!)
                return
            }
            self.errorLabel.isHidden = true
            //fetching user data
            Authentication.getUserData(completion: {
                (error) in
                //error getting user data
                guard error == nil else{
                    self.signUpButton.isEnabled = true
                    self.showError(error: error!)
                    return
                }
                self.signUpButton.isEnabled = true
                print(CurrentUser.currentUser.uid)
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    func showError(error: String){
        errorLabel.isHidden = false
        errorLabel.text = error
    }
    
}

extension SignUpViewController: CLLocationManagerDelegate{
    
func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let locValue:CLLocationCoordinate2D = manager.location!.coordinate
    //set users location
    CurrentUser.currentUser.longitude = locValue.longitude
    CurrentUser.currentUser.latitude = locValue.latitude
    }
}
