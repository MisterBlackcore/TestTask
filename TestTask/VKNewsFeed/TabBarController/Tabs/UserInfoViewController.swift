import UIKit
import Kingfisher

class UserInfoViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var centerViewForActivityIndicator: UIView!
    
    var activityIndicator = UIActivityIndicatorView()
    
    private let networkServise:Networking = NetworkService()
    private let authService:AuthService = AuthService()
    
    //MARK: - Main Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        centerViewForActivityIndicator.isHidden = true
        parsingJSON()
        customizeProfilePictureImageView()
    }

    //MARK: - Flow Functions
    
    func parsingJSON() {
        showActivityIndicator()
        guard let userId = authService.userId else {
            return
        }
        let params = ["user_ids": userId, "fields" : "photo_100, country, city, sex"]
        networkServise.requestUsers(path: API.user, params: params) { (data, error) in
            if let error = error {
                print("Error recieved requesting data: \(error.localizedDescription)")
            }
            guard let data = data else {
                return
            }
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String:Any] {
                JSONParsingService.shared.parsingUserResponse(json: json)
                    DispatchQueue.main.async {
                        self.fillInInfo()
                        self.stopActivityIndicator()
                }
            }
        }
    }
    
    func showActivityIndicator() {
        centerViewForActivityIndicator.backgroundColor = .black
        centerViewForActivityIndicator.alpha  = 0.7
        centerViewForActivityIndicator.layer.cornerRadius = 10
        centerViewForActivityIndicator.isHidden = false
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.center = CGPoint(x: centerViewForActivityIndicator.frame.size.width/2, y: centerViewForActivityIndicator.frame.size.height/2)
        
        centerViewForActivityIndicator.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        activityIndicator.removeFromSuperview()
        centerViewForActivityIndicator.isHidden = true
    }
    
    func fillInInfo() {
        if let url = JSONParsingService.shared.userInfoRecievedFromJson.userPhotoURL {
            let url = URL(string: url)
            profilePictureImageView.kf.indicatorType = .activity
            profilePictureImageView.kf.setImage(with: url)
        }
        nameLabel.text = JSONParsingService.shared.userInfoRecievedFromJson.firstName
        surnameLabel.text = JSONParsingService.shared.userInfoRecievedFromJson.lastName
        countryLabel.text = JSONParsingService.shared.userInfoRecievedFromJson.country
        cityLabel.text = JSONParsingService.shared.userInfoRecievedFromJson.firstName
        sexLabel.text = JSONParsingService.shared.userInfoRecievedFromJson.sex
    }
    
    func customizeProfilePictureImageView() {
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.size.height/2
    }
    
}
