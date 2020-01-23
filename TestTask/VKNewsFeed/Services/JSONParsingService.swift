import Foundation

class JSONParsingService {
    
    var feedItemsArray:[FeedItem] = []
    var userInfoRecievedFromJson = UserResponse()
    
    static let shared = JSONParsingService()
    private init () {}
    
    func parsingNewsFeedJSON(json: [String:Any] ) {
        if let response = json["response"] as? [String:Any] {
            if let items = response["items"] as? [[String:Any]] {
                for item in items {
                    var newsTextIsEmpty = true
                    let feedItem = FeedItem()
                    feedItem.sourceId = item["source_id"] as? Int
                    feedItem.text = item["text"] as? String
                    if feedItem.text != nil {
                        newsTextIsEmpty = false
                    }
                    feedItem.date = item["date"] as? Double
                    if let comments = item["comments"] as? [String:Any] {
                        feedItem.comments = comments["count"] as? Int
                    }
                    if let likes = item["likes"] as? [String:Any] {
                        feedItem.likes = likes["count"] as? Int
                    }
                    if let reposts = item["reposts"] as? [String:Any] {
                        feedItem.reposts = reposts["count"] as? Int
                    }
                    if newsTextIsEmpty == false {
                        feedItemsArray.append(feedItem)
                    }
                }
            }
            for feedItem in feedItemsArray {
                if feedItem.sourceId! > 0 {
                    if let profiles = response["profiles"] as? [[String:Any]]{
                        for profile in profiles {
                            let id = profile["id"] as? Int
                            if feedItem.sourceId == id {
                                if let firstName = profile["first_name"] as? String, let lastName = profile["last_name"] as? String {
                                    feedItem.feedItemName = firstName + " " + lastName
                                    feedItem.feedItemImageURL = profile["photo_100"] as? String
                                }
                            }
                        }
                    }
                } else {
                    if let groups = response["groups"] as? [[String:Any]]{
                        for group in groups {
                            let id = group["id"] as? Int
                            if abs(feedItem.sourceId!) == id {
                                if let name = group["name"] as? String {
                                    feedItem.feedItemName = name
                                    feedItem.feedItemImageURL = group["photo_200"] as? String
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func parsingUserResponse(json: [String:Any]) {
        if let response = json["response"] as? [[String:Any]] {
            for user in response {
                userInfoRecievedFromJson.firstName = user["first_name"] as? String
                userInfoRecievedFromJson.lastName = user["last_name"] as? String
                let sex = user["sex"] as? Int
                switch sex {
                case 1:
                    userInfoRecievedFromJson.sex = "Female"
                case 2:
                    userInfoRecievedFromJson.sex = "Male"
                default:
                    userInfoRecievedFromJson.sex = "N/A"
                }
                if let city = user["city"] as? [String:Any] {
                    userInfoRecievedFromJson.city = city["title"] as? String
                }
                if let country = user["country"] as? [String:Any] {
                    userInfoRecievedFromJson.country = country["title"] as? String
                }
                userInfoRecievedFromJson.userPhotoURL = user["photo_100"] as? String
            }
        }
    }
    
}
