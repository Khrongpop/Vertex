//
//  BorderTableView.swift
//  Vertex
//
//  Created by Khrongpop Phonngam on 1/1/2561 BE.
//  Copyright © 2561 Khrongpop Phonngam. All rights reserved.
//

import UIKit

class BorderTableView: UIView {
    
    override func awakeFromNib() {
       // self.layer.borderColor = UIColor( red: 0.5, green: 0.5, blue:0, alpha: 1.0 ) as! CGColor
       self.layer.borderColor = UIColor.init(red: 210/255.0, green: 210/255.0, blue: 210/255.0, alpha: 1.0).cgColor
        self.layer.borderWidth = 3
    }

}
