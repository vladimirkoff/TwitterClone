//
//  Tweet.swift
//  TwitterClone
//
//  Created by Vladimir Kovalev on 03.03.2023.
//

import Foundation

struct Tweet {
    let caption: String
    var likes: Int
    var timestamp: Date!
    let tweetID: String
    let uid: String
    let retweetCount: Int
    var user: User
    var didLike = false
    
    init(user: User, tweetID: String, dictionary: [String: Any]) {
        self.tweetID = tweetID
        self.user = user
        
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.uid = dictionary["uid"] as? String ?? ""
        self.retweetCount = dictionary["retweetCount"] as? Int ?? 0
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
    }
    
}
