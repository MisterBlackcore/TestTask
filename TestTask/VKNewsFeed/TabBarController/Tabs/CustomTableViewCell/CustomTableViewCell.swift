import UIKit
import Kingfisher

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var newsSourceImageView: UIImageView!
    @IBOutlet weak var newsSourceNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var newsTextLabel: UILabel!
    @IBOutlet weak var likesNumberLabel: UILabel!
    @IBOutlet weak var repostsNumberLabel: UILabel!
    @IBOutlet weak var commentsNumberLabel: UILabel!
    
    func fillInCellFields(feedItem: FeedItem) {
        if let url = feedItem.feedItemImageURL {
            let url = URL(string: url)
            newsSourceImageView.kf.indicatorType = .activity
            newsSourceImageView.kf.setImage(with: url)
        }
        newsSourceNameLabel.text = feedItem.feedItemName
        dateWrapping(feedItem: feedItem)
        newsTextLabel.text = feedItem.text
        if let comments = feedItem.comments {
            commentsNumberLabel.text = "\(comments)"
        }
        if let likes = feedItem.likes {
            likesNumberLabel.text = "\(likes)"
        }
        if let reposts = feedItem.reposts {
            repostsNumberLabel.text = "\(reposts)"
        }
    }
    
    func dateWrapping(feedItem: FeedItem) {
        if let date = feedItem.date {
            let date = Date(timeIntervalSince1970: date)
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "d MMM 'в' HH:mm"
            let convertedDate = dateFormatter.string(from: date)
            dateLabel.text = convertedDate
        }
    }
    
    func customizeCell() {
        cellView.layer.cornerRadius = 10
        cellView.layer.masksToBounds = true
        newsSourceImageView.layer.cornerRadius = newsSourceImageView.frame.size.height/2
    }
    
}
