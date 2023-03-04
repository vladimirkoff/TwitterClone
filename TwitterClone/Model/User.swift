//
//  User.swift
//  TwitterClone
//
//  Created by Vladimir Kovalev on 02.03.2023.
//

import Foundation
import FirebaseAuth

struct User {
    let fullName: String
    let email: String
    let profileImageUrl: String
    let uid: String
    let userName: String
    
    var isCurrentuser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    
    init(uid: String, dictionary: [String: AnyObject]) {
        self.uid = uid
        
        self.fullName = dictionary["fullName"] as! String
        self.email = dictionary["email"] as! String
        self.profileImageUrl = dictionary["profileImageUrl"] as! String
        self.userName = dictionary["username"] as! String
    }
}
