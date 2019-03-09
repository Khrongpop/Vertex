//
//  AuthService.swift
//  Vertex
//
//  Created by Khrongpop Phonngam on 12/31/2560 BE.
//  Copyright © 2560 Khrongpop Phonngam. All rights reserved.
//

import  UIKit
import Firebase


class AuthService {
    static let instance = AuthService()
    
    let defaults = UserDefaults.standard        // standard คือ instance ของ UserDefaults
    
    var isLoggedIn : Bool {
        get {
            return  defaults.bool(forKey: USERDEFAULT_KEY_LOGGEDIN)
        }
        set {
            // ค่าใหม่ที่ถูกเซ็ตเข้ามา ->  newValue
            defaults.set(newValue,forKey: USERDEFAULT_KEY_LOGGEDIN)
        }
    }
    
    func signUp(withEmail email:String, password: String,tell: String ,fullname: String, profileImage: UIImage, completion: @escaping (User? , Error?) -> Void ) {
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                
                // print(user?.email)
                if let user = user {
                    
                    //self.saveUserInformationToDataBase(user: user)
                    
                    self.saveUserInformationToDataBase(user: user, fullName: fullname,tell: tell, completion: { (user, error) in
                        
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            print("Saved user informations.")
                            
                            self.upload(profileImage: profileImage, user: user!.uid, completion: { (metadata, error) in
                                completion(user,error)
                            })
                            
                        }
                        
                    })
                    
                }
                
            }
            
        })
        
    }
    
    func savePostInformation(withNameProduct name: String ,price: String ,description: String ,ItemImage: UIImage ,Section: String ,completion: @escaping (Error?) -> Void){
        
        
        print("Saving user post informations to database ...")
        let price = price + "฿"
        let uid = Auth.auth().currentUser?.uid
        let child = uid!+name+Section+price
        
        imageService().upload(image: ItemImage,uid: name, completion: { (metadata, error) in
            if let metadata = metadata {
                
                guard let downloadURL = metadata.downloadURL()?.absoluteString else { return }
                
                let values = ["nameProduct": name, "price": price, "description":description ,"uid":uid ,"section":Section ,"profile_image_url": downloadURL]
                
                
                Database.database().reference().child("PostInformation").child(Section).child(child).setValue(values)
                
                Database.database().reference().child("PostInformation").child("AllPost").child(child).setValue(values)
                
                print("Upload profile done!")
                
                completion(error)
                
            } else { print(" no photo ")}
        })
    }
    
    private func saveUserInformationToDataBase(user: User,fullName: String,tell: String ,completion: @escaping (User?,Error?) -> Void) {
        
        print("Saving user informations to database ...")
        let values = ["full_name": fullName, "email": user.email , "Tell":tell]
        
        Database.database().reference().child("UserInformation").child(user.uid).setValue(values)
        {
            (error,reference) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                print("save user Information sucses")
                
            }
            completion(user,error)
        }
    }
    
    
    
    
    private func upload(profileImage image: UIImage, user: String, completion: @escaping (StorageMetadata?,Error?) -> Void) {
        
        print("Uploading profile Images.")
        
        imageService().upload(image: image,uid: user, completion: { (metadata, error) in
            if let metadata = metadata {
                
                guard let downloadURL = metadata.downloadURL()?.absoluteString else { return }
                
                let values = ["profile_image_url": downloadURL]
                Database.database().reference().child("UserInformation").child(user).updateChildValues(values)
                print("Upload profile done!")
                
                completion(metadata,error)
                
            } else { print(" no photo ")}
        })
        
    }
    
    func editprofile(withName name: String, email: String, mobile: String, Image: UIImage, completion: @escaping (User?,Error?) -> Void) {
        
        print("edit user profile informations to database ...")
        
        let user = Auth.auth().currentUser
        Auth.auth().currentUser?.updateEmail(to: email, completion: { (error) in
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("done")
            }
        })
        
        
        
        
        let values = ["full_name": name, "email": email , "Tell":mobile]
        
        Database.database().reference().child("UserInformation").child((user?.uid)!).updateChildValues(values)
        {
            (error,reference) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                print("save user Information sucses")
                
            }
            //completion(user,error)
        }
        
        imageService().upload(image: Image,uid: (user?.uid)!, completion: { (metadata, error) in
            if let metadata = metadata {
                
                guard let downloadURL = metadata.downloadURL()?.absoluteString else { return }
                
                let values = ["profile_image_url": downloadURL]
                Database.database().reference().child("UserInformation").child((user?.uid)!).updateChildValues(values)
                print("Upload profile done!")
                
                completion(user,error)
                
            } else { print(" no photo ")}
        })
        
        
    }
    
    func addCommentToDatabase(comment: String ,post: Post  ){
        
        let uid = post.uid
        let name = post.nameProduct
        let description = post.description
        let price = post.price
        let section = post.section
        let child = uid+name+section+price
        let userid = Auth.auth().currentUser?.uid
        let values = ["comment": comment , "uid": userid ,"post_id":child]
        Database.database().reference().child("CommentInformation").child(section).childByAutoId().setValue(values)
        
        
        // completion( true )
    }
    
    func addFollow (followID: String ) {
        let uid = Auth.auth().currentUser?.uid
        let child = uid!+followID
        let follow: String = "true"
        
        let ref = Database.database().reference().child("FollowInformation").child(uid!).child(child)
        let values = ["followID": followID , "follow": follow , "uid":uid] as [String : Any]
        
        ref.setValue(values)
        
    }
    
    func removeFollow (followID: String) {
        let uid = Auth.auth().currentUser?.uid
        let child = uid!+followID
        let ref = Database.database().reference().child("FollowInformation").child(uid!).child(child)
        ref.removeValue()
    }
    
    func saveChat(formID: String, toID: String, textChat: String) {
        let ref = Database.database().reference().child("ChatInformation").childByAutoId()
        let values = ["formID": formID , "toID": toID , "textChat":textChat] as [String : Any]
        ref.setValue(values)
        
        let child1 = formID+toID
        let ref2 = Database.database().reference().child("ChatUserInformation").child(child1)
        let values2 = ["formID": formID , "toID": toID , "textChat":textChat] as [String : Any]
        ref2.setValue(values2)
        
        let child2 = toID+formID
        let ref3 = Database.database().reference().child("ChatUserInformation").child(child2)
        let values3 = ["formID": toID , "toID": formID , "textChat":textChat] as [String : Any]
        ref3.setValue(values3)
    }
    
}

// Auth.auth().signIn(withEmail: <#T##String#>, password: <#T##String#>, completion: <#T##AuthResultCallback?##AuthResultCallback?##(User?, Error?) -> Void#>)
// Auth.auth().signOut()
