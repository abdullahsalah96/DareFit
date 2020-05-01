//
//  JoinChallengeViewController.swift
//  DareFit
//
//  Created by Abdalla Elshikh on 4/29/20.
//  Copyright © 2020 Abdalla Elshikh. All rights reserved.
//

import UIKit
import MapKit

class JoinChallengeViewController: UIViewController {
    var challenges:[Challenge] = []
    var selectedChallenge:Challenge!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMapView()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mapView.reloadInputViews()
    }
    
    func configureView(){
        self.activityIndicator.isHidden = true
        displayChallengePins(challenge: Constants.challenges.running)
        displayChallengePins(challenge: Constants.challenges.cycling)
        displayChallengePins(challenge: Constants.challenges.swimming)
    }
    
    func setUpMapView(){
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
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
    
    func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertVC, animated: true)
    }
    
    func viewSelectedChallenge(longitude: Double, latitude: Double){
        //search in available challenges
        for challenge in self.challenges{
            if challenge.longitude == longitude && challenge.latitude == latitude{
                //selected challenge
                self.selectedChallenge = challenge
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.performSegue(withIdentifier: Constants.SegueIDs.joinChallengeDetails, sender: nil)
                return
            }
        }
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        showAlert(title: "Error", message: "Can't fetch challenge details")
    }
}

extension JoinChallengeViewController: MKMapViewDelegate{
    
    //customize pins
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.isEnabled = true
            pinView!.canShowCallout = true
            pinView?.animatesDrop = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return pinView
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    // This delegate method is implemented to respond to taps. as to direct to media type
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            //pressed on accessory button
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            //get challenge details and segue
            viewSelectedChallenge(longitude: view.annotation!.coordinate.longitude, latitude: view.annotation!.coordinate.latitude)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIDs.joinChallengeDetails{
            let vc = segue.destination as! JoinChallengeDetailsViewController
            vc.challenge = self.selectedChallenge
        }
    }
    
    func displayChallengePins(challenge:String){
        //parse data
        Database.getChallenges(inChallenge: challenge, completion: {
            (challenges, error) in
            guard error == nil else{
                self.showAlert(title: "Error", message: error!)
                return
            }
            var annotations = [MKPointAnnotation]()
            if let challenges = challenges{
                //loop through users to display them on map
                for challenge in challenges{
                    // populate challenges array
                    self.challenges.append(challenge)
                    let coordinate = CLLocationCoordinate2D(latitude: challenge.latitude, longitude: challenge.longitude)
                    let first = challenge.firstName
                    let last = challenge.lastName
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = "Click for more details"
                    // Finally we place the annotation in an array of annotations.
                    annotations.append(annotation)
                }
                //show pins
                self.mapView.addAnnotations(annotations)
                self.mapView.reloadInputViews()
            }
        })
    }
}
