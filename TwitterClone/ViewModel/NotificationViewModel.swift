//
//  NotificationViewModel.swift
//  TwitterClone
//
//  Created by Vladimir Kovalev on 13.03.2023.
//

import UIKit

struct NotificationViewModel {
    private let notification: Notification
    private let type: NotificationType
    private let user: User
    
    var timestamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .day, .hour, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        
        return formatter.string(from: notification.timestamp, to: now) ??  "2m"
    }
    
    var notificationMessage: String {
        switch type {
            
        case .follow: return "Started following you"
        case .like: return "Liked your tweet"
        case .reply: return "Replied to tweet"
        case .retweet: return "Retweeted tweet"
        case .comment: return "Commented your tweet"
        case .mention: return "Mentioned you"
            
        }
    }
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    var notificationText: NSAttributedString? {
        
        let title = NSMutableAttributedString(string: user.fullName, attributes: [.font : UIFont.boldSystemFont(ofSize: 14) ])
        title.append(NSAttributedString(string: " \(notificationMessage) ", attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        title.append(NSAttributedString(string: timestamp, attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        return title
    }
    
    var shouldHideFollowButton: Bool {
        return type != .follow
    }
    
    var followButtonText: String {
        return user.isFollowed ? "Unfollow" : "Follow"
    }
    
    init(notification: Notification) {
        self.notification = notification
        self.type = notification.type
        self.user = notification.user
    }
        
}
