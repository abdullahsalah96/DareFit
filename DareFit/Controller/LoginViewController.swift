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
        setupVideo()
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
        errorLabel.isHidden = true
        styleTextField(textField: emailTextField)
        styleTextField(textField: passwordTextField)
    }
    
    func styleTextField(textField: UITextField){
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.layer.cornerRadius = 20
        textField.layer.shadowRadius = 3
        textField.layer.borderWidth = 1
        textField.layer.masksToBounds = true
        textField.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0.1)
        textField.layer.shadowColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
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
//        let email = emailTextField.text!.trimmingCharacters(in: .whitespaces)
//        let password = passwordTextField.text!
//        if let error = validateFields(){
//            //There's a problem with fields entered
//            showError(error: error)
//        }else{
//            //sign in
////            signIn(email: email, password: password)
//        }
        signIn(email: "adbo@test.com", password: "Abdo1234*")
    }
    
    func signIn(email: String, password: String){
        Authentication.signIn(email: email, password: password) { (error) in
            guard error == nil else{
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
                    return
                }
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

