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
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
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
    
    
    func configureView(){
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(signOutIsPressed))
        nameLabel.text = CurrentUser.currentUser.firstName + CurrentUser.currentUser.lastName
    }
    
    @objc func signOutIsPressed(){
        signOut()
    }
    
    func signOut(){
        Authentication.signOut { (error) in
            guard error == nil else{
                self.showAlert(title: "Error", message: "Can't logout at the moment")
                return
            }
            //logout
            self.dismiss(animated: true, completion: nil)
        }
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
