//
//  ViewController.swift
//  DareFit
//
//  Created by Abdalla Elshikh on 4/29/20.
//  Copyright © 2020 Abdalla Elshikh. All rights reserved.
//

import UIKit
import AVFoundation


class LoginViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    var videoPlayer: AVPlayer?
    var videoPlayerLayer: AVPlayerLayer?
    
    //outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        self.navigationController?.setToolbarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //setup video player
//        setupVideo()
    }
    
    func setupVideo(){
        // Get path of video in assets
        let path = Bundle.main.path(forResource: "video", ofType: ".mp4")
        guard path != nil else{
            print("invalid path")
            return
        }
        // Get url of video
        let url = URL(fileURLWithPath: path!)
        // create video player item
        let item = AVPlayerItem(url: url)
        // attach item to player
        videoPlayer = AVPlayer(playerItem: item)
        //create layer
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer)
        //mute video player
        videoPlayer?.isMuted = true
        //adjust frame
        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.width*2, y: -self.view.frame.height/2, width: self.view.frame.width*5, height: self.view.frame.height*2)
        //attach layer to view
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        let myTime = CMTime(seconds: 15, preferredTimescale: 1000)
        videoPlayer?.currentItem?.seek(to: myTime, completionHandler: {
            success in
            //play video
            self.videoPlayer?.playImmediately(atRate: 0.8)
        })
    }
    
    func configureView(){
        activityIndicator.isHidden = true
        errorLabel.isHidden = true
        styleTextField(textField: emailTextField)
        styleTextField(textField: passwordTextField)
    }
    
    func styleTextField(textField: UITextField){
        textField.layer.masksToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.layer.cornerRadius = 25
        textField.layer.shadowRadius = 50
        textField.layer.borderWidth = 0.0
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOffset = CGSize(width: 2, height: 2)
        textField.layer.shadowOpacity = 1.0
    }
    
    func validateFields()->String?{
        if emailTextField.text?.trimmingCharacters(in: .whitespaces) == ""{
            return "Please a Valid Email Address"
        }else if !Authentication.isValidPassword(password: passwordTextField.text!){
            return "Invalid Password, Passwords should be of at least 8 characters containing uppercase/lowercase letters, a number and a special character"
        }else{
            return nil
        }
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        signInProgress(isSigningIn: true)
//        signIn(email: emailTextField.text!, password: passwordTextField.text!)
        signIn(email: "test@test.com", password: "Test1234*")
        //generating random data
//        randomData()
    }
    
    func randomData(){
        //a function that keeps generating random data for demonstration
        RandomDataGenerator.generateRandomUsers(challenge: Constants.challenges.running)
         let interval:TimeInterval = 5
         DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            //calling function again after interval
            self.randomData()
         }
    }
    
    func signInProgress(isSigningIn:Bool){
        activityIndicator.isHidden = !isSigningIn
        signInButton.isEnabled = !isSigningIn
        signUpButton.isEnabled = !isSigningIn
        if(isSigningIn){
            activityIndicator.startAnimating()
        }else{
            activityIndicator.stopAnimating()
        }
    }
    
    func signIn(email: String, password: String){
        print(email)
        print(password)
        Authentication.signIn(email: email, password: password) { (error) in
            guard error == nil else{
                self.signInProgress(isSigningIn: false)
                self.showError(error: error!)
                return
            }
            //signed in successfully
            self.errorLabel.isHidden = true
            //fetching user data
            Authentication.getUserData(completion: {
                (error) in
                //error getting user data
                guard error == nil else{
                    self.showError(error: error!)
                    self.signInProgress(isSigningIn: false)
                    return
                }
                self.signInProgress(isSigningIn: false)
                self.performSegue(withIdentifier: Constants.SegueIDs.home, sender: nil)
            })
        }
    }
    
    
    @IBAction func signUpPressed(_ sender: Any) {
        performSegue(withIdentifier: Constants.SegueIDs.signUp, sender: nil)
    }
    
    func showError(error: String){
        errorLabel.isHidden = false
        errorLabel.text = error
    }
    
}

