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
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureImageViews()
    }
    
    func configureView(){
       self.mapView.delegate = self
    }
    
    func configureImageViews(){
        profileImageView.isUserInteractionEnabled = true
        let profileTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageViewClicked))
        profileImageView.addGestureRecognizer(profileTapRecognizer)
    }
    
    @objc func profileImageViewClicked(recognizer: UITapGestureRecognizer){
        print("profile")
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
            pinView!.pinTintColor = .red
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
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    
    func displayPinsOnMap(){
        //parse data
        //if there are pins remove them from map
        if self.mapView.annotations.count > 0 {
            self.mapView.removeAnnotations(self.mapView.annotations)
        }
//        let locations = StudentsModel.data
//        var annotations = [MKPointAnnotation]()
//        for dictionary in locations {
//            let lat = CLLocationDegrees(dictionary.latitude)
//            let long = CLLocationDegrees(dictionary.longitude)
//            // The lat and long are used to create a CLLocationCoordinates2D instance.
//            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
//            let first = dictionary.firstName
//            let last = dictionary.lastName
//            let mediaURL = dictionary.mediaURL
//            // Here we create the annotation and set its coordiate, title, and subtitle properties
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = coordinate
//            annotation.title = "\(first) \(last)"
//            annotation.subtitle = mediaURL
//            // Finally we place the annotation in an array of annotations.
//            annotations.append(annotation)
//         }
         // When the array is complete, we add the annotations to the map.
//        self.mapView.addAnnotations(annotations)
        self.mapView.reloadInputViews()
    }
}
