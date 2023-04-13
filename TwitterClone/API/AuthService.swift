//
//  AuthService.swift
//  TwitterClone
//
//  Created by Vladimir Kovalev on 02.03.2023.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

struct AuthParameters {
    let email: String
    let password: String
    let userName: String
    let fullName: String
    let profileImage: UIImage
}

struct AuthService {
    
    static let shared = AuthService() 
    
    func registeruser(parameters: AuthParameters, completion: @escaping(Error?, DatabaseReference) -> Void ) {
        
        guard let imageData = parameters.profileImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = UUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(filename)
        
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            storageRef.downloadURL { url, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let imageURL = url?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: parameters.email, password: parameters.password) { result, error in
                    if let error = error {
                        print("Error - \(error.localizedDescription)")
                    } else {
                        
                        guard let uid = result?.user.uid else {return}
                        
                        let values = ["email": parameters.email, "username": parameters.userName, "fullName": parameters.fullName, "profileImageUrl": imageURL]
                        REF_USERS.child(uid).updateChildValues(values) { error, ref in  // writing info into Realtime DB
                            
                            if let error = error {
                                print(error.localizedDescription)
                                return
                            }
                        }
                    }
                }
            }
            print("SUCCESS")
        }
    }
    
    func logUserIn(withEmail email: String, withPassword password: String, completion: @escaping(Error?, DatabaseReference) -> Void ) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print("SUCCESS")
        }
    }
}
