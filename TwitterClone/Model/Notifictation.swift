//
//  Notifictation.swift
//  TwitterClone
//
//  Created by Vladimir Kovalev on 13.03.2023.
//

import Foundation

enum NotificationType: Int {
    case follow
    case like
    case reply
    case retweet
    case comment
    case mention
}

struct Notification {
    var tweetID: String?
    var timestamp: Date!
    var user: User
    var tweet: Tweet?
    var type: NotificationType!
    
    init(user: User, dictionary: [String: AnyObject]) {
        self.user = user
        
        
        if let tweetID = dictionary["tweetID"] as? String {
            self.tweetID = tweetID
        }

        if let timestamp2 = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp2)
        }
        if let type = dictionary["type"] as? Int {
            self.type = NotificationType(rawValue: type)
        }
    }
}
