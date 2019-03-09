//
//  CommentCell.swift
//  Vertex
//
//  Created by Khrongpop Phonngam on 12/31/2560 BE.
//  Copyright © 2560 Khrongpop Phonngam. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    func updateView(comments: Comment) {
       
        self.commentLabel.text = comments.comment
        
        UserService.instance.getUserInformations(WithUID: comments.uid) { (user) in
            self.emailLabel.text = user?.email
            self.name.text = user?.fullname
            self.downloadImgURL(imgaeURL: (user?.URLimage)!)
            
        }
    }
    
    func downloadImgURL(imgaeURL: URL) {
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
class NoCommentCell: UITableViewCell {

}
