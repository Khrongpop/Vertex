//
//  Post.swift
//  Vertex
//
//  Created by Khrongpop Phonngam on 12/31/2560 BE.
//  Copyright © 2560 Khrongpop Phonngam. All rights reserved.
//

import Foundation
import Firebase
class Post
{
    var description: String = ""
    var nameProduct: String = ""
    var price: String = ""
    var profile_image_url: String = ""
    var uid: String = ""
    var section: String = ""
    let ref: DatabaseReference!
    
    
    
    init(snapshot: DataSnapshot)
    {
        ref = snapshot.ref
        if let value = snapshot.value as? [String : Any] {
            description = value["description"] as! String
            nameProduct = value["nameProduct"] as! String
            price = value["price"] as! String
            uid = value["uid"] as! String
            profile_image_url = value["profile_image_url"] as! String
            section = value["section"] as! String
            
            
        }
    }
    
    init(description: String ,nameProduct: String ,price: String ,profile_img: String ,uid: String ,section: String ,ref: DatabaseReference) {
        self.description = description
        self.nameProduct = nameProduct
        self.price = price
        self.profile_image_url = profile_img
        self.uid = uid
        self.section = section
        self.ref = ref
    }
    
    
}

/*
 
 */
