//
//  Validator.swift
//  Vertex
//
//  Created by Khrongpop Phonngam on 12/31/2560 BE.
//  Copyright © 2560 Khrongpop Phonngam. All rights reserved.
//

import Foundation

class Validator {
    
    class func isValid(email: String) -> Bool{
        // sfdf.s@gmail.com
        //        let emailRegEx = "[A-Z0-9a-z._-%+]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        // หน้า @ เป็น A_Z 0-9 a-z ._%+ หลัง @ เป็น ชื่อโดเมน  , หลัง . ต้องเป็น 2 ตัวอักษรขึ้นไป เป็นเฉพาะตัวหนังสือ
        //สร้างมาเป็นตัวแปร str ก่อน
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with:email)
    }
    
    class func isValid(password: String) -> Bool{
        return password.characters.count >= 6
    }
    
    class func TellisValid(Tell: String) -> Bool {
        return Tell.characters.count >= 10
    }
    
    class func isValid(checkEmty: String) -> Bool {
        return checkEmty.count >= 1
    }
    
    
}

