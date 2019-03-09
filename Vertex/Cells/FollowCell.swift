//
//  FollowCell.swift
//  Vertex
//
//  Created by Khrongpop Phonngam on 12/31/2560 BE.
//  Copyright © 2560 Khrongpop Phonngam. All rights reserved.
//

import UIKit

class FollowCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileIamge: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateCell(uid: String) {
        
        UserService.instance.getUserInformations(WithUID: uid) { (user) in
            self.nameLabel.text = user?.fullname
            self.emailLabel.text = user?.email
            print(user?.URLimage)
            self.downloadImgURL(imgaeURL: (user?.URLimage)!)
        }
    }
    
    
    
    func downloadImgURL(imgaeURL: URL) {
        let task = URLSession.shared.dataTask(with: imgaeURL, completionHandler: {
            (data,response,error) in
            print(data)
            print(error)
            guard let data = data ,error == nil else { return }
            DispatchQueue.main.async {
                self.profileIamge.image = UIImage(data: data)
            }
        })
        
        task.resume()
    }
    
    
   
}


