//
//  Comment.swift
//  Vertex
//
//  Created by Khrongpop Phonngam on 12/31/2560 BE.
//  Copyright © 2560 Khrongpop Phonngam. All rights reserved.
//

import Foundation
import Firebase

class Comment
{
    var comment: String = ""
    var post_id: String = ""
    var uid: String = ""
    let ref: DatabaseReference!
    
    
    
    init(snapshot: DataSnapshot)
    {
        ref = snapshot.ref
        if let value = snapshot.value as? [String : Any] {
            comment = value["comment"] as! String
            post_id = value["post_id"] as! String
            uid = value["uid"] as! String
            
        }
    }
    
    init(comment: String ,post_id: String ,uid: String ,ref: DatabaseReference) {
        self.comment = comment
        self.uid = uid
        self.post_id = post_id
        self.ref = ref
    }
    
    
}

