import UIKit

class AuthViewController: UIViewController {

    @IBOutlet weak var signInButton: UIButton!
    
    private var authService: AuthService!
    
    //MARK: - Main Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeSignInButton()
        authService = AppDelegate.shared().authService
    }
    
    //MARK: - IBActions
    
    @IBAction func signInTouch() {
        authService.wakeUpSession()
    }
    
    func customizeSignInButton() {
        signInButton.layer.cornerRadius = 10
        signInButton.layer.shadowOpacity = 1.0
        signInButton.layer.shadowColor = UIColor.black.cgColor
        signInButton.layer.shadowRadius = 10
    }
    
}
