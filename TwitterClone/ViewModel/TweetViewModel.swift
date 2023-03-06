//
//  TweetViewModel.swift
//  TwitterClone
//
//  Created by Vladimir Kovalev on 03.03.2023.
//

import UIKit

struct TweetViewModel {
    
    let tweet: Tweet
    
    var profileImageUrl: String {
        return tweet.user.profileImageUrl
    }
    
    var timestamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .day, .hour, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        
        return formatter.string(from: tweet.timestamp, to: now) ??  "df"
    }
    
    let user: User
    
    var userName: String  {
        return "@\(user.userName)"
    }
    
    var headerTimestamp: String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "h:mm a • MM/dd/yyyy"
        return formatter.string(from: tweet.timestamp)
    }
    
    var retweetsString: NSAttributedString {
        return attributedText(withValue: tweet.retweetCount, text: " Retweets")
    }
    
    var likesString: NSAttributedString {
        return attributedText(withValue: tweet.likes, text: " Likes")
    }
    
    fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: text, attributes: [.font : UIFont.boldSystemFont(ofSize: 14), .foregroundColor : UIColor.lightGray]))
        return attributedTitle
    }
    
    var userInfo: NSAttributedString {
        let title = NSMutableAttributedString(string: user.fullName, attributes: [.font : UIFont.boldSystemFont(ofSize: 14) ])
        title.append(NSAttributedString(string: " @\(user.userName) • ", attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        title.append(NSAttributedString(string: timestamp, attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        print(timestamp)
        return title
    }
    
    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.user
    }
    
    func size(forWidth width: CGFloat) -> CGSize {
        let measurementlabel = UILabel()
        measurementlabel.text = tweet.caption
        measurementlabel.numberOfLines = 0
        measurementlabel.lineBreakMode = .byWordWrapping
        measurementlabel.translatesAutoresizingMaskIntoConstraints = false
        measurementlabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        return measurementlabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
}
