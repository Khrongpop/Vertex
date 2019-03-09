//
//  CategoryCell.swift
//  Vertex
//
//  Created by Khrongpop Phonngam on 12/31/2560 BE.
//  Copyright © 2560 Khrongpop Phonngam. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var featuredImageView: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var backgroundColorView: UIView!
  
    
    func updateUI(category: Category)
    {
        
        featuredImageView.image = UIImage(named: category.featuredImage)!
        TitleLabel.text = category.title
        backgroundColorView.backgroundColor = UIColor(red: 63/255.0, green: 71/255.0, blue: 80/255.0, alpha: 0.5)
        super.layoutSubviews()
        
        self.layer.cornerRadius = 3.0
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 5, height: 10)
        
        self.clipsToBounds = false
        
        
    }
    
}
