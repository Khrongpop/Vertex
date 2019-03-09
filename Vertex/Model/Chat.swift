//
//  Chat.swift
//  Vertex
//
//  Created by Khrongpop Phonngam on 12/31/2560 BE.
//  Copyright © 2560 Khrongpop Phonngam. All rights reserved.
//

import Foundation
import Firebase

class Chat
{
    var formID: String = ""
    var toID: String = ""
    var textChat: String = ""
    let ref: DatabaseReference!
    
    
    
    init(snapshot: DataSnapshot)
    {
        ref = snapshot.ref
        if let value = snapshot.value as? [String : Any] {
            formID = value["formID"] as! String
            toID = value["toID"] as! String
            textChat = value["textChat"] as! String
        }
    }
    
    init(formID: String ,toID: String ,textChat: String ,ref: DatabaseReference) {
        self.formID = formID
        self.toID = toID
        self.textChat = textChat
        self.ref = ref
    }
    
    
    
    
    
}
