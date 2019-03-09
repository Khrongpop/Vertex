//
//  UserService.swift
//  Vertex
//
//  Created by Khrongpop Phonngam on 12/31/2560 BE.
//  Copyright © 2560 Khrongpop Phonngam. All rights reserved.
//

import Foundation

import Firebase

struct UserProfile {
    var fullname: String
    var email: String
    var Tell: String
    var URLimage: URL
}
class UserService {
    static let instance = UserService()
    
    func getUserInformations(WithUID uid: String, completion: @escaping ( UserProfile? ) -> Void) {
        
        let db = Database.database().reference()
        
        db.child("UserInformation").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            
            if snapshot.exists() {
                let value = snapshot.value as? [String : Any]
                let fullname = value?["full_name"] as? String ?? ""
                let email = value?["email"] as? String ?? ""
                let Tell = value?["Tell"] as? String ?? ""
                let strimage = value?["profile_image_url"] as? String ?? ""
                let URLimage = URL(string: strimage)
                
                
                completion(UserProfile.init(fullname: fullname, email: email, Tell: Tell ,URLimage: URLimage!))
            } else {
                completion(nil)
                
            }
        }
        
        
    }
    
    func getStatusFollow(withFollowID followid: String,  completion: @escaping ( Bool ) -> Void) {
        
        let uid = Auth.auth().currentUser?.uid
        let child = uid!+followid
        let ref = Database.database().reference().child("FollowInformation").child(uid!).child(child).observeSingleEvent(of: .value) { (snapshot) in
            
            print(snapshot)
            
            if snapshot.exists() {
                let value = snapshot.value as? [String : Any]
                
                let status = value?["follow"] as? String ?? ""
                print(status)
                if status == "true" {
                    completion(true)
                } else {
                    completion(false)
                }
                
            } else {
                completion(false)
                
            }
        }
        
        
    }
    
}
