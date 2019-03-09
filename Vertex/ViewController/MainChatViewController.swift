//
//  MainChatViewController.swift
//  Vertex
//
//  Created by Khrongpop Phonngam on 12/31/2560 BE.
//  Copyright © 2560 Khrongpop Phonngam. All rights reserved.
//

import UIKit
import Firebase

class MainChatViewController: UIViewController {

    
    @IBAction func unwindToMainChat(segue: UIStoryboardSegue) {}
    @IBOutlet weak var tableView: UITableView!
    fileprivate var chats = [Chat]()
    fileprivate var toID = [String]()
    
    private var HaveChat: Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
         tabBarController?.tabBar.isHidden = false
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        self.updateView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func updateView() {
        
        let formID: String = (Auth.auth().currentUser?.uid)!
        let ref = Database.database().reference().child("ChatUserInformation")
        self.chats.removeAll()
        self.toID.removeAll()
        ref.observe(.value, with: { (snapshot) in
            
            for child in snapshot.children {
                let childSnapshot = child as! DataSnapshot
                let value = childSnapshot.value as? [String : Any]
                
                
                let snapformID = value?["formID"] as? String ?? ""
                let snapToID = value?["toID"] as? String ?? ""
                
                if formID == snapformID  {
                    
                    let chat = Chat(snapshot: childSnapshot)
                    self.chats.insert(chat, at: 0)
                   // self.toID.append(snapToID)
                    
                    
                } else if formID == snapToID {
                    
                   // let chat = Chat(snapshot: childSnapshot)
                   // self.chats.insert(chat, at: 0)
                    //self.toID.append(snapToID)
                }
                
            }
            
            self.tableView.reloadData()
            self.tableView.rowHeight = 82;
            
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatnow" {
            let vc = segue.destination as! ChatViewController
            let chats = sender as! Chat
            let toID = chats.toID
            vc.initchat(toID: toID)
        }
    }
    
    
}

extension MainChatViewController: UITableViewDelegate, UITableViewDataSource   {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MainChatCell") as? MainChatCell {
            
            let chat = chats[indexPath.row]
            
            cell.updateCell(chat: chat)
            
            
            return cell
            
        } else {
            return ChatCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = chats[indexPath.row]
        performSegue(withIdentifier: "chatnow", sender: cell)
    }
    
    
    
}

