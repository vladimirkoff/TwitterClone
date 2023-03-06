//
//  ProfileHeaderViewModel.swift
//  TwitterClone
//
//  Created by Vladimir Kovalev on 03.03.2023.
//

import UIKit

enum ProfileCategoryOptions: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    var description: String {
        switch self {
        case .tweets: return "Tweets"
        case .replies: return "Tweets & Replies"
        case .likes: return "Likes"
        }
    }
}

struct ProfileHeaderViewModel {
    
    var followersString: NSAttributedString? {
        return attributedText(withValue: user.stats?.followers ?? 0, text: "Followers")
    }
    
    var followingString: NSAttributedString? {
        return attributedText(withValue: user.stats?.following ?? 0, text: "Following")
    }
    
    var actionButtonTitle: String {
        if user.isCurrentuser {
            return "Edit profile"
        }
        if !user.isFollowed && !user.isCurrentuser {
            return "Follow"
        }
        if user.isFollowed {
            return "Unfollow"
        } else {
            return ""
        }
    }
    
    private let user: User
    
    init(user: User) {
        self.user = user
    }
    
    fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: text, attributes: [.font : UIFont.boldSystemFont(ofSize: 14), .foregroundColor : UIColor.lightGray]))
        return attributedTitle
    }
    
}
