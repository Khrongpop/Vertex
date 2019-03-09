//
//  Follow.swift
//  Vertex
//
//  Created by Khrongpop Phonngam on 12/31/2560 BE.
//  Copyright © 2560 Khrongpop Phonngam. All rights reserved.
//

import Foundation

import Firebase

class Follow
{
    var followid: String = ""
    
    let ref: DatabaseReference!
    
    
    
    init(snapshot: DataSnapshot)
    {
        ref = snapshot.ref
        if let value = snapshot.value as? [String : Any] {
            followid = value["followID"] as! String
            
        }
    }
    
    init(followid: String ,ref: DatabaseReference) {
        self.followid = followid
        self.ref = ref
    }
    
    
}
