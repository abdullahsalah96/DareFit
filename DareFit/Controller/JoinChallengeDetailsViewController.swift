import UIKit

class JoinChallengeDetailsViewController: UIViewController {

    var challenge:Challenge!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    func configureView(){
        //setting challenge data
        self.descriptionLabel.text = challenge.description
        self.nameLabel.text = challenge.firstName
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func subscribeButtonPressed(_ sender: Any) {
        let url = URL(string: challenge.url)
        if let url = url{
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}
