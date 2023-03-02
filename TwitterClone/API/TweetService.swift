//
//  TweetService.swift
//  TwitterClone
//
//  Created by Vladimir Kovalev on 02.03.2023.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

struct TweetService {
    static let shared = TweetService()
    
    func uploadTweet(caption: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["uid": uid, "timestamp": Int(NSDate().timeIntervalSince1970), "likes": 0, "retweet": 0, "caption": caption] as [String : Any]
        REF_TWEETS.childByAutoId() // generates random id
            .updateChildValues(values, withCompletionBlock: completion)
    }
}
