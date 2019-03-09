//
//  ChatCell.swift
//  Vertex
//
//  Created by Khrongpop Phonngam on 12/31/2560 BE.
//  Copyright © 2560 Khrongpop Phonngam. All rights reserved.
//

import UIKit
import Firebase

class ChatCell: UITableViewCell {

    
    @IBOutlet weak var chatLabel: UILabel!
    @IBOutlet weak var formImg: UIImageView!
    @IBOutlet weak var toImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateCell(chat: Chat  ,ToID: String) {
        
        
        let formid = Auth.auth().currentUser?.uid
        chatLabel.text = chat.textChat
        
        if formid == chat.formID {
            if ToID == chat.toID {
                UserService.instance.getUserInformations(WithUID: formid!, completion: { (user) in
                    self.FormdownloadImgURL(imgaeURL: (user?.URLimage)!)
                    self.formImg.isHidden = false
                })
                chatLabel.textAlignment = NSTextAlignment.right
                toImg.isHidden = true
            }
        }
        else if formid == chat.toID  {
            if ToID == chat.formID {
                UserService.instance.getUserInformations(WithUID: ToID, completion: { (user) in
                    self.TodownloadImgURL(imgaeURL: (user?.URLimage)!)
                    self.toImg.isHidden = false
                })
                chatLabel.textAlignment = NSTextAlignment.left
                formImg.isHidden = true
            }
        }
        
    }
       
    
    func FormdownloadImgURL(imgaeURL: URL) {
        let task = URLSession.shared.dataTask(with: imgaeURL, completionHandler: {
            (data,response,error) in
            
            guard let data = data ,error == nil else { return }
            DispatchQueue.main.async {
                self.formImg.image = UIImage(data: data)
            }
        })
        
        task.resume()
    }
    
    
    func TodownloadImgURL(imgaeURL: URL) {
        let task = URLSession.shared.dataTask(with: imgaeURL, completionHandler: {
            (data,response,error) in
            
            guard let data = data ,error == nil else { return }
            DispatchQueue.main.async {
                self.toImg.image = UIImage(data: data)
            }
        })
        
        task.resume()
    }

}
