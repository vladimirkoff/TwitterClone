//
//  EditProfileViewModel.swift
//  TwitterClone
//
//  Created by Vladimir Kovalev on 14.03.2023.
//

import Foundation

enum EditProfileOptions: Int, CaseIterable {
    case fullname
    case username
    case bio
    
    var description: String {
        switch self {
        case .fullname:
            return "Fullname"
        case .username:
            return "Username"
        case .bio:
            return "Bio"
        }
    }
}

struct EditProfileViewModel {
    
    private let user: User
    let option: EditProfileOptions
    
    var titleText: String {
        return option.description
    }
    
    var optionValue: String?  {
        switch option {
            
        case .fullname:
            return user.fullName
        case .username:
            return user.userName
        case .bio:
            return user.bio
        }
    }
    
    var shouldHideTextField: Bool {
        return option == .bio
    }
    var shouldHideTextView: Bool {
        return option != .bio
    }
    
    init(user: User, option: EditProfileOptions) {
        self.user = user
        self.option = option
    }
}
