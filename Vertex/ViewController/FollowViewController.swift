//
//  FollowViewController.swift
//  Vertex
//
//  Created by Khrongpop Phonngam on 12/31/2560 BE.
//  Copyright © 2560 Khrongpop Phonngam. All rights reserved.
//

import UIKit
import Firebase

class FollowViewController: UIViewController {

    @IBAction func unwindToFollow(segue: UIStoryboardSegue) {}
    @IBOutlet weak var tableView: UITableView!
    fileprivate var follows = [Follow]()
    
    override func viewDidAppear(_ animated: Bool) {       
        self.updateCell()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
       tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateCell() {
        
        
        let myid = Auth.auth().currentUser?.uid
        
        let ref = Database.database().reference().child("FollowInformation").child(myid!)
          self.follows.removeAll()
        
        ref.observe(.value, with: { (snapshot) in
            
            
            
            for child in snapshot.children {
                let childSnapshot = child as! DataSnapshot
                let value = childSnapshot.value as? [String : Any]
                let uid = value?["uid"] as? String ?? ""
                
                if myid == uid {
                    
                    let follows = Follow(snapshot: childSnapshot)
                    self.follows.insert(follows, at: 0)
                }
            }
            
            self.tableView.reloadData()
            self.tableView.rowHeight = 82;
        })
    }
   

}

extension FollowViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(follows.count)
        return follows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FollowCell" ) as? FollowCell {
            
            let follow = follows[indexPath.row]
            
            cell.updateCell(uid: follow.followid)
            
            
            return cell
            
        } else {
            return FollowCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = follows[indexPath.row]
        performSegue(withIdentifier: "GoToProfile", sender: cell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToProfile" {
            let vc = segue.destination as! UserInfomationViewController
            let follow = sender as! Follow
            vc.updateView(shopid: follow.followid)
        }
    }
    
}
