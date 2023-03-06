//
//  UploadTweetViewModel.swift
//  TwitterClone
//
//  Created by Vladimir Kovalev on 06.03.2023.
//

import UIKit

enum UploadTweetConfiguration {  // since we use the same view controller for different targets, is is proper to add enum to distinguish the targets
    case tweet
    case reply(Tweet)
}

struct UploadTweetViewModel {
    let actiomButtonTitle: String
    let placeholderText: String
    var shouldShowReply: Bool
    var replyText: String?
    
    init(config: UploadTweetConfiguration) {
        switch config {
        case .tweet:
            actiomButtonTitle = "Tweet"
            placeholderText = "What's happening"
            shouldShowReply = false
        case .reply(let tweet):
            actiomButtonTitle = "Reply"
            placeholderText = "Tweet your reply"
            shouldShowReply = true
            replyText = "Replying to @\(tweet.user.userName)"
        }
    }
}

