//
//  myPostCell.swift
//  Vertex
//
//  Created by Khrongpop Phonngam on 12/31/2560 BE.
//  Copyright © 2560 Khrongpop Phonngam. All rights reserved.
//

import UIKit

import  Firebase

class myPostCell: UITableViewCell {
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
   
    
    func updateView(post: Post){
        productNameLabel.text = post.nameProduct
        priceLabel.text = post.price
        let url = URL(string: post.profile_image_url)
        downloadImgURL(imgaeURL: url!)
        
      
        
       
    }
    
    func downloadImgURL(imgaeURL: URL) {
        let task = URLSession.shared.dataTask(with: imgaeURL, completionHandler: {
            (data,response,error) in
            
            guard let data = data ,error == nil else { return }
            DispatchQueue.main.async {
                self.productImage.image = UIImage(data: data)
            }
        })
        
        task.resume()
    }
    
  
    
    
}
class NullmyPostCell: UITableViewCell {
    
}
