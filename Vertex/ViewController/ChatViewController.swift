//
//  ChatViewController.swift
//  Vertex
//
//  Created by Khrongpop Phonngam on 12/31/2560 BE.
//  Copyright © 2560 Khrongpop Phonngam. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var navitem: UINavigationItem!
    @IBOutlet weak var chatTextField: UITextField!
    @IBOutlet weak var ChatView: UIView!
    @IBOutlet weak var viewVC: UIView!
  
    fileprivate var chats = [Chat]()
    @IBOutlet weak var bottomcons: NSLayoutConstraint!
    private var toID: String = ""
    private let formID: String = ""
    private var DontReloadData: Bool = false
    
    override func viewDidAppear(_ animated: Bool) {
          tabBarController?.tabBar.isHidden = true
        tableView.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI));
      
        NSLayoutConstraint.accessibilityAssistiveTechnologyFocusedIdentifiers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyborads()
        self.chatTextField.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.delegate = self
        tableView.dataSource = self
        updateView()
        
        chatTextField.delegate = self
        self.DontReloadData = false
         tabBarController?.tabBar.isHidden = true
       
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    func initchat(toID: String){
        self.toID = toID
        
    }
    func handlingKeybord(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            //let keyboradFrame = userInfo[UIKeyboardFrameEndUserInfoKey].
        }
    }
    
  
    func textFieldDidBeginEditing(_ textField: UITextField) {
       // movetextField(view: ChatView, moveDistance: 200, up: true)
       // print("keyboradIsActive")
        //boottomchatview
        DispatchQueue.main.async {
            self.self.bottomcons.constant = 225
            self.viewVC.layoutIfNeeded()
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            self.self.bottomcons.constant = 0
            self.viewVC.layoutIfNeeded()
        }
    }
    
    func updateConstraints() {
        // You should handle UI updates on the main queue, whenever possible
        DispatchQueue.main.async {
            self.self.bottomcons.constant = 10
            self.viewVC.layoutIfNeeded()
        }
    }
    
    
    func movetextField (view: UIView, moveDistance: Int ,up: Bool) {
        let moveDuration = 0.3
        let moveMent: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
     //   self.view.frame = CGRectOffset(self.view.frame, 0, moveMent)
        UIView.commitAnimations()
    }
    
    @IBAction func didPreeSend(_ sender: Any) {
        
        let formID: String = (Auth.auth().currentUser?.uid)!
        if let textChat = chatTextField.text {
            AuthService.instance.saveChat(formID: formID, toID: toID, textChat: chatTextField.text!)
            
            chatTextField.text = nil
            DontReloadData = true
        }
    }
    
    func updateView() {
        let formID: String = (Auth.auth().currentUser?.uid)!
        UserService.instance.getUserInformations(WithUID: toID) { (user) in
            self.navitem.title = user?.fullname
        }
        
        let ref = Database.database().reference().child("ChatInformation")
        ref.observe(.value, with: { (snapshot) in
            self.chats.removeAll()
            for child in snapshot.children {
                let childSnapshot = child as! DataSnapshot
                let value = childSnapshot.value as? [String : Any]
                
                
                let snapformID = value?["formID"] as? String ?? ""
                let snapToID = value?["toID"] as? String ?? ""
                print(snapformID)
                print(formID)
                
                print("=======")
                
                print(snapToID)
                print(self.toID)
                
                if self.toID == snapToID {
                    if formID == snapformID {
                        
                        let chat = Chat(snapshot: childSnapshot)
                        self.chats.insert(chat, at: 0)
                    }
                }
                if self.toID == snapformID {
                    if formID == snapToID {
                        
                        let chat = Chat(snapshot: childSnapshot)
                        self.chats.insert(chat, at: 0)
                    }
                }
            }
            //   if(self.DontReloadData == false)
            //     {
            self.tableView.reloadData()
            self.tableView.rowHeight = 70;
            //    }
        })
    }

    

}
extension ChatViewController: UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as? ChatCell {
            
            let chat = chats[indexPath.row]
            
            //  cell.updateCell(chat: chat)
            cell.updateCell(chat: chat, ToID: toID)
            cell.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI));
            
            return cell
            
        } else {
            return ChatCell()
        }
    }
    
   
    
}
