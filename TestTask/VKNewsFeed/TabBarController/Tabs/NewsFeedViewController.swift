import UIKit

class NewsFeedViewController: UIViewController, UITabBarDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var centerViewForActivityIndicator: UIView!
    
    var activityIndicator = UIActivityIndicatorView()
    var feedItems:[FeedItem] = []
    
    private let networkServise:Networking = NetworkService()
    
    //MARK: - Main Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parsingJSON()
        tableView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    }
    
    //MARK: - Flow Functions
    
    func parsingJSON() {
        showActivityIndicator()
        let params = ["params": "post, photo"]
        networkServise.requestNews(path: API.newsFeed, params: params) { (data, error) in
            if let error = error {
                print("Error recieved requesting data: \(error.localizedDescription)")
            }
            
            guard let data = data else {
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String:Any] {
                JSONParsingService.shared.parsingNewsFeedJSON(json: json)
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    self.feedItems = JSONParsingService.shared.feedItemsArray
                    self.tableView.reloadData()
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
    
    //MARK: - TableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        cell.fillInCellFields(feedItem: feedItems[indexPath.row])
        cell.selectionStyle = .none
        cell.customizeCell()
        return cell
    }
    
}
