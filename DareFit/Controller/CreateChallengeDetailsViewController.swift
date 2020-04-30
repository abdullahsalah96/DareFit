import UIKit
import MapKit
import CoreLocation

class CreateChallengeDetailsViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var challengeDescription: UITextView!
    var challenge = ""
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMapView()
        print(challenge)
    }
    
    func setUpMapView(){
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true

        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coor, animated: true)
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func confirmButton(_ sender: Any) {
        //add to database
        Challenges.createChallenge(firstName: CurrentUser.currentUser.firstName, lastName: CurrentUser.currentUser.lastName, long: CurrentUser.currentUser.longitude, lat: CurrentUser.currentUser.latitude, uid: CurrentUser.currentUser.uid, challenge: self.challenge, description: self.challengeDescription.text, completion: {
            (error) in
            guard error == nil else{
                self.showAlert(title: "Error", message: error!)
                return
            }
            //created successfully
            self.showAlert(title: "Done", message: "Challenge Created Successfully")
        })
    }
    
    func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertVC, animated: true)
    }
}

extension CreateChallengeDetailsViewController: MKMapViewDelegate, CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        //set users location
        CurrentUser.currentUser.longitude = locValue.longitude
        CurrentUser.currentUser.latitude = locValue.latitude
        mapView.mapType = MKMapType.standard
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        annotation.title = "\(CurrentUser.currentUser.firstName) \(CurrentUser.currentUser.lastName)"
        annotation.subtitle = "Your location"
        mapView.addAnnotation(annotation)
    }
}
