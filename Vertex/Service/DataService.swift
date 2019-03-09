//
//  DataService.swift
//  Vertex
//
//  Created by Khrongpop Phonngam on 12/31/2560 BE.
//  Copyright © 2560 Khrongpop Phonngam. All rights reserved.
//

import Foundation

class DataService {
    
    static let instance = DataService()
    
    private let categories = [
        
        Category(title: "CLOTHING", featuredImage: "f1", colorR: 63/255.0, colorG: 71/255.0, colorB: 80/255.0) ,
        Category(title: "SHOES", featuredImage: "f2", colorR: 63/255.0, colorG: 71/255.0, colorB: 80/255.0) ,
        Category(title: "ACCESSORIES", featuredImage: "f3", colorR: 63/255.0, colorG: 71/255.0, colorB: 80/255.0) ,
        Category(title: "ELECTRONIC", featuredImage: "f4", colorR: 63/255.0, colorG: 71/255.0, colorB: 80/255.0) ,
        Category(title: "ETC", featuredImage: "f5", colorR: 63/255.0, colorG: 71/255.0, colorB: 80/255.0)
    ]
    
    
    
    
    func getCategories() -> [Category] {
        return categories
    }
    
    func numberOfCategories() -> Int {
        return categories.count
    }
    
    func getCategory(atIndex: Int) -> Category { 
        return categories[atIndex]
    }
    
    
    
}
