//
//  UserService.swift
//  TwitterClone
//
//  Created by Vladimir Kovalev on 02.03.2023.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

typealias DatabaseCompletion = (Error?, DatabaseReference) -> Void

struct UserService {
    
    static let shared = UserService()
    
    func fetchUser(uid: String, completion: @escaping(User) -> Void) {
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            
            let user = User(uid: uid, dictionary: dictionary)
            
            completion(user)
        }
    }
    
    func fetchUsers(completion: @escaping([User]) -> Void) {
        var users = [User]()
        REF_USERS.observe(.childAdded) { snapshot in
            let uid = snapshot.key
            
            guard let dictionary = snapshot.value as? [String : AnyObject] else { return }
            
            let user = User(uid: uid, dictionary: dictionary)
            users.append(user)
            completion(users)
        }
    }
    
    func followUser(uid: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).updateChildValues([uid: 1]) { error, ref in
            REF_USER_FOLLOWERS.child(uid).updateChildValues([currentUid : 1]) { error, ref in
                print("DEBUG: FOLLOWED")
                completion(error, ref)
            }
        }
    }
    
    func unfollowUser(uid: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        REF_USER_FOLLOWING.child(currentUid).child(uid).removeValue { error, ref in
            REF_USER_FOLLOWERS.child(uid).child(currentUid).removeValue { error, ref in
                completion(error, ref)
            }
        }
    }
    
    func checkIfFollowed(_ uid: String, completion: @escaping(Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).child(uid).observeSingleEvent(of: .value) { snapshot in
            print("DEBUG: \(snapshot.exists())")
            completion(snapshot.exists())  // if child exists - true, else - false
        }
    }
    
    func fetchUserStats(uid: String, completion: @escaping(UserStats) -> Void) {
        REF_USER_FOLLOWERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            let followers = snapshot.children.allObjects.count
            
            REF_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value) { snapshot in
                let following = snapshot.children.allObjects.count
                
                let stats = UserStats(followers: followers, following: following)
                completion(stats)
            }
        }
    }
    
    func fetchUserWithUsername(with username: String, completion: @escaping(User) -> Void) {
        REF_USER_USERNAMES.child(username).observeSingleEvent(of: .value) { snapshot in
            guard let uid = snapshot.value as? String else { return }
            self.fetchUser(uid: uid, completion: completion)
        }
    }
    
    func safeUserData(for user: User, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values = ["fullname": user.fullName, "username": user.userName, "bio": user.bio ?? ""]
        
        REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
    }
    
    func updateProfileImage(image: UIImage, completion: @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let fileName = UUID().uuidString
        let ref = STORAGE_PROFILE_IMAGES.child(fileName)
        
        ref.putData(imageData, metadata: nil) { metadata, err in
            ref.downloadURL { url, err in
                guard let profileImageUrl = url?.absoluteString else { return }
                let values = ["profileImageUrl" : profileImageUrl]
                
                REF_USERS.child(uid).updateChildValues(values) { err, ref in
                    completion(profileImageUrl)
                }
            }
        }
        
    }
}
