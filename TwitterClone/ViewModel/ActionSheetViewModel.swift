//
//  ActionSheetViewModel.swift
//  TwitterClone
//
//  Created by Vladimir Kovalev on 07.03.2023.
//

import Foundation

struct ActionSheetViewModel {
    
    private let user: User
    
     var options: [ActionSheetOptions] {
        var results = [ActionSheetOptions]()
        
        if user.isCurrentuser {
            results.append(.delete)
        } else {
            let followOption: ActionSheetOptions = user.isFollowed ? .unfollow(user) : .follow(user)
            results.append(followOption)
        }
         results.append(.report)
        return results
    }
    
    init(user: User) {
        self.user = user
    }
    
}

enum ActionSheetOptions {
    case follow(User)
    case unfollow(User)
    case report
    case delete
    
    var description: String {
        switch self {
        case .follow(let user):
            return "Follow @\(user.userName)"
        case .unfollow(let user):
            return "Unfollow \(user.userName)"
        case .report:
            return "Report tweet"
        case .delete:
            return "Delete tweet"
        }
    }
}
