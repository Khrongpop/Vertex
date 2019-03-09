//
//  imageService.swift
//  Vertex
//
//  Created by Khrongpop Phonngam on 12/31/2560 BE.
//  Copyright © 2560 Khrongpop Phonngam. All rights reserved.
//

import Foundation
import Firebase

class imageService {
    
    // StorageMetadata ไว้เพื่อบอกว่า รูปนี้ url อยู่ที่ไหน
    func upload(image: UIImage,uid: String ,completion: @escaping (StorageMetadata?,Error?) -> Void) {
        
        var data: Data! //ต้องแปลง uiimg ให้เป็น data
        if let jpeg = UIImageJPEGRepresentation(image, 0.1) { //ถ้ารูปเป็น jpeg ,1.0 = original img
            data = jpeg
            
        } else if let png = UIImagePNGRepresentation(image) {
            data = png
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"  //กำหนด type
        // Storage.storage().reference().child("Profiles").child("images")
        // data ต้องมีแน่นอน (Data!)
        Storage.storage().reference().child("Profiles/images").child(uid).putData(data, metadata: metadata) { (metadata, error) in
            
            completion(metadata,error)
        }   // Storage.storage().reference() จำเป็นต้องใช้
    }
    
   
    
    
    
}
