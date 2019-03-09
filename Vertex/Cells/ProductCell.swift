//
//  ProductCell.swift
//  Vertex
//
//  Created by Khrongpop Phonngam on 12/31/2560 BE.
//  Copyright © 2560 Khrongpop Phonngam. All rights reserved.
//

import UIKit


class ProductCell: UITableViewCell {
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
   
    
    func updateView(post: Post){
        productNameLabel.text = post.nameProduct
        priceLabel.text = post.price
        let url = URL(string: post.profile_image_url)
        downloadImgURL(imgaeURL: url!)
        
        let user = UserService.instance.getUserInformations(WithUID: post.uid) { (user) in
            self.usernameLabel.text = user?.fullname
            self.emailLabel.text = user?.email
            self.mobileLabel.text = user?.Tell
            self.userdownloadImgURL(imgaeURL: (user?.URLimage)!)
        }
        
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
    
    func userdownloadImgURL(imgaeURL: URL) {
        let task = URLSession.shared.dataTask(with: imgaeURL, completionHandler: {
            (data,response,error) in
            
            guard let data = data ,error == nil else { return }
            DispatchQueue.main.async {
                self.profileImage.image = UIImage(data: data)
            }
        })
        
        task.resume()
    }
    
    
}

