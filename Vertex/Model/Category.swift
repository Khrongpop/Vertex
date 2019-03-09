//
//  Category.swift
//  Vertex
//
//  Created by Khrongpop Phonngam on 12/31/2560 BE.
//  Copyright © 2560 Khrongpop Phonngam. All rights reserved.
//

import UIKit
struct Category {
    
    private (set) public var title: String
    private (set) public var featuredImage: String
    private (set) public var colorR: CGFloat
    private (set) public var colorG: CGFloat
    private (set) public var colorB: CGFloat
    
    
    init(title: String, featuredImage: String, colorR: CGFloat, colorG: CGFloat, colorB: CGFloat)
    {
        self.title = title
        self.featuredImage = featuredImage
        self.colorR = colorR
        self.colorG = colorG
        self.colorB = colorB
    }
}
