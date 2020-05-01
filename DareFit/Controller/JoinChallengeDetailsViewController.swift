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
        self.descriptionLabel.text = challenge.description
        self.nameLabel.text = challenge.firstName
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func subscribeButtonPressed(_ sender: Any) {
    }
    
}
