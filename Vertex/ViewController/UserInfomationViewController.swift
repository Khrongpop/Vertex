//
//  UserInfomationViewController.swift
//  Vertex
//
//  Created by Khrongpop Phonngam on 12/31/2560 BE.
//  Copyright © 2560 Khrongpop Phonngam. All rights reserved.
//

import UIKit
import Firebase

class UserInfomationViewController: UIViewController {

    @IBAction func unwindToUserProfile(segue: UIStoryboardSegue){}
    @IBOutlet weak var navbaritem: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var tellLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var namepostLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    fileprivate var posts = [Post]()
    
    private var uid: String = ""
    
    private var follow: Bool = false
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkFolow()
        updateProfile()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
         tabBarController?.tabBar.isHidden = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func checkFolow(){
        let myid = Auth.auth().currentUser?.uid
        
        UserService.instance.getStatusFollow(withFollowID: uid) { (status) in
            self.follow = status
            print(status)
            if(self.follow == true) {
                self.followButton.setTitle("following", for: .normal)
            } else {
                self.followButton.setTitle("follow", for: .normal)
            }
            
            if myid == self.uid {
                self.followButton.isEnabled = false
                self.followButton.setTitle(nil, for: .normal)
                self.followButton.isHidden = true
                self.chatButton.isEnabled = false
                self.chatButton.setTitle(nil, for: .normal)
                self.chatButton.isHidden = true
            }
        }
        
        
        
    }
    
    func updateView(shopid: String ){
        self.uid = shopid
    }
    func updateProfile() {
        
        
        
        guard uid == uid else { return }
        
        UserService.instance.getUserInformations(WithUID: uid) { (userProfile) in
            self.nameLabel.text = userProfile?.fullname
            self.navbaritem.title = userProfile?.fullname
            self.emailLabel.text = userProfile?.email
            self.tellLabel.text = userProfile?.Tell
            self.downloadImgURL(imgaeURL: (userProfile?.URLimage)!)
            self.namepostLabel.text = "\(userProfile!.fullname)'s Posts"
        }
        
        
        
        let ref = Database.database().reference().child("PostInformation").child("AllPost")
        
        ref.observe(.value, with: { (snapshot) in
            self.posts.removeAll()
            
            for child in snapshot.children {
                let childSnapshot = child as! DataSnapshot
                let value = childSnapshot.value as? [String : Any]
                let shopid = value?["uid"] as? String ?? ""
                
                if self.uid == shopid {
                    let post = Post(snapshot: childSnapshot)
                    self.posts.insert(post, at: 0)
                    
                }
            }
            
            self.tableView.reloadData()
            self.tableView.rowHeight = 250;
            self.postLabel.text = "\(self.posts.count) posts"
        })
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
    
    
    
   
    
    @IBAction func didPressFollow(_ sender: Any) {
        follow = !follow
        
        if(follow == true) {
            followButton.setTitle("following", for: .normal)
            AuthService.instance.addFollow(followID: uid)
        } else {
            followButton.setTitle("follow", for: .normal)
            AuthService.instance.removeFollow(followID: uid)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatnow" {
            let vc = segue.destination as! ChatViewController
            vc.initchat(toID: uid )
            
        }
        
        if segue.identifier == "ProductDetail" {
            let vc = segue.destination as! ProductDetailViewController
            let post = sender as! Post
            vc.initdetail(post: post)
        }
    }
    
    @IBAction func Chatnow(_ sender: Any) {
        performSegue(withIdentifier: "chatnow", sender: nil)
    }

}

extension UserInfomationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if posts.count == 0 {
            return 1
        } else {
            return posts.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if posts.count == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "NullmyPostCell") as? NullmyPostCell {
                return cell
            } else {
                return myPostCell()
            }
        } else {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "myPostCell") as? myPostCell { //
                let post = posts[indexPath.row]
                
                cell.updateView(post: post)
                
                return cell
            } else {
                
                return myPostCell() // สร้างใหม่ เป็นตัวเปล่าๆ
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if posts.count > 0 {
            let cell = posts[indexPath.row]
            performSegue(withIdentifier: "ProductDetail", sender: cell)
        }
        
    }
    
    
}
