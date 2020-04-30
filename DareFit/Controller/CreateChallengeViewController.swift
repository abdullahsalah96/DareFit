//
//  CreateChallengeViewController.swift
//  DareFit
//
//  Created by Abdalla Elshikh on 4/29/20.
//  Copyright © 2020 Abdalla Elshikh. All rights reserved.
//

import UIKit

class CreateChallengeViewController: UIViewController {
    
    //outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var swimmingCardImageView: UIImageView!
    @IBOutlet weak var cyclingCardImageView: UIImageView!
    @IBOutlet weak var runningCardImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureImageViews()
//        Challenges.getChallengeUsers(challenge: Constants.challenges.running) { (users, error) in
//            guard error == nil else{
//                self.showAlert(title: "Alert", message: "There are no users in challenge")
//                return
//            }
//            if let users = users{
//                print(users)
//            }
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configureImageViews(){
        profileImageView.isUserInteractionEnabled = true
        runningCardImageView.isUserInteractionEnabled = true
        cyclingCardImageView.isUserInteractionEnabled = true
        swimmingCardImageView.isUserInteractionEnabled = true
        let profileTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageViewClicked))
        profileImageView.addGestureRecognizer(profileTapRecognizer)
        let runningTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(runningImageViewClicked))
        runningCardImageView.addGestureRecognizer(runningTapRecognizer)
        let swimmingTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(swimmingImageViewClicked))
        swimmingCardImageView.addGestureRecognizer(swimmingTapRecognizer)
        let cyclingTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(cyclingImageViewClicked))
        cyclingCardImageView.addGestureRecognizer(cyclingTapRecognizer)
    }
    
    @objc func profileImageViewClicked(recognizer: UITapGestureRecognizer){
        print("profile")
    }

    @objc func runningImageViewClicked(recognizer: UITapGestureRecognizer){
        print("running")
    }
    @objc func cyclingImageViewClicked(recognizer: UITapGestureRecognizer){
        print("cycling")
    }
    @objc func swimmingImageViewClicked(recognizer: UITapGestureRecognizer){
        print("swimming")
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
            self.resetUserData()
        }
    }
    
    func resetUserData(){
        CurrentUser.currentUser.firstName = ""
        CurrentUser.currentUser.lastName = ""
        CurrentUser.currentUser.uid = ""
        CurrentUser.currentUser.latitude = 0
        CurrentUser.currentUser.longitude = 0
    }
    
    func subscribeToChallenge(challenge:String){
        Challenges.subscribeToChallenge(firstName: CurrentUser.currentUser.firstName, lastName: CurrentUser.currentUser.lastName, long: CurrentUser.currentUser.longitude, lat: CurrentUser.currentUser.latitude, uid: CurrentUser.currentUser.uid, challenge: challenge, completion: {
            (error) in
            guard error == nil else{
                self.showAlert(title: "Can't subscribe to challenge", message: error!)
                return
            }
        })
    }
    
    func unsubscribeFromChallenge(challenge:String){
        Challenges.unsubscribeFromChallenge(uid: CurrentUser.currentUser.uid, challenge: challenge) { (error) in
            guard error == nil else{
                self.showAlert(title: "Can't Unsubscribe", message: error!)
                return
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertVC, animated: true)
    }
}
