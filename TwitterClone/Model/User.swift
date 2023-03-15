//
//  User.swift
//  TwitterClone
//
//  Created by Vladimir Kovalev on 02.03.2023.
//

import Foundation
import FirebaseAuth

struct User {
    var fullName: String
    var email: String
    var profileImageUrl: String
    let uid: String
    var userName: String
    var isFollowed = false
    var stats: UserStats?
    var bio: String?
    
    var isCurrentuser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    
    init(uid: String, dictionary: [String: AnyObject]) {
        self.uid = uid
        
        self.fullName = dictionary["fullName"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.userName = dictionary["username"] as? String ?? ""
        self.bio = dictionary["bio"] as? String ?? nil
    }
}

struct UserStats {
    var followers: Int
    var following: Int
}
