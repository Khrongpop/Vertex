
//
//  MainChatCell.swift
//  Vertex
//
//  Created by Khrongpop Phonngam on 12/31/2560 BE.
//  Copyright © 2560 Khrongpop Phonngam. All rights reserved.
//

import UIKit

class MainChatCell: UITableViewCell {

    @IBOutlet weak var lastChat: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var toImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateCell(chat: Chat) {
       
        UserService.instance.getUserInformations(WithUID: chat.toID) { (user) in
            self.downloadImgURL(imgaeURL: (user?.URLimage)!)
            self.name.text = user?.fullname
            
        }
        self.lastChat.text = chat.textChat
    }
    
    func downloadImgURL(imgaeURL: URL) {
        let task = URLSession.shared.dataTask(with: imgaeURL, completionHandler: {
            (data,response,error) in
            print(data)
            print(error)
            guard let data = data ,error == nil else { return }
            DispatchQueue.main.async {
                self.toImg.image = UIImage(data: data)
            }
        })
        
        task.resume()
    }
    
    
   
    
}

