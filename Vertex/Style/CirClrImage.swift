//
//  CirClrImage.swift
//  Vertex
//
//  Created by Khrongpop Phonngam on 12/31/2560 BE.
//  Copyright © 2560 Khrongpop Phonngam. All rights reserved.
//

import UIKit

class CirClrImage: UIImageView {

    override func awakeFromNib() {
        layer.cornerRadius = frame.size.width / 2
        clipsToBounds = true
    }

}
