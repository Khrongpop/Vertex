//
//  ProfileViewController.swift
//  Vertex
//
//  Created by Khrongpop Phonngam on 12/31/2560 BE.
//  Copyright © 2560 Khrongpop Phonngam. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    @IBAction func  unwindToProfile(unwindSegue: UIStoryboardSegue) {}
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var tellLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var tabletView: UITableView!
     fileprivate var posts = [Post]()
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        updateProfile()
    }
    
    
    override func viewDidLoad() {
        updateProfile()
        super.viewDidLoad()
        tabletView.delegate = self
        tabletView.dataSource = self
        tabletView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func logoutPress(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            AuthService.instance.isLoggedIn = false
            let appDeletegate = UIApplication.shared.delegate as! AppDelegate
            appDeletegate.presentLoginIfNeccessary()
            //   performSegue(withIdentifier: "unwindTologin", sender: nil)
        } catch let signOutError as NSError {
            print("Error signing Out" , signOutError)
        }
    }
    
    
    func updateProfile() {
        
        let userID = Auth.auth().currentUser?.uid
        if let userID = userID {
            UserService.instance.getUserInformations(WithUID: userID) { (userProfile) in
                self.nameLabel.text = userProfile?.fullname
                self.emailLabel.text = userProfile?.email
                self.tellLabel.text = userProfile?.Tell
                self.downloadImgURL(imgaeURL: (userProfile?.URLimage)!)
            }
        }
        
      
        
        let ref = Database.database().reference().child("PostInformation").child("AllPost")
        
        ref.observe(.value, with: { (snapshot) in
            self.posts.removeAll()
            
            for child in snapshot.children {
                let childSnapshot = child as! DataSnapshot
                let value = childSnapshot.value as? [String : Any]
                let uid = value?["uid"] as? String ?? ""
                
                if userID == uid {
                    let post = Post(snapshot: childSnapshot)
                    self.posts.insert(post, at: 0)
                    
                }
            }
            
            self.tabletView.reloadData()
            self.tabletView.rowHeight = 250;
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
    
   
    @IBAction func editProfile(_ sender: Any) {
        performSegue(withIdentifier: "editProofile", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editProofile"
        {
            let vc = segue.destination as! EditViewController
            vc.updateProfile()
        }
        
        if segue.identifier == "GoToDetailProduct" {
           let vc = segue.destination as! ProductDetailViewController
            let post = sender as! Post
            vc.initdetail(post: post)
        }
    }
}

extension ProfileViewController: UITableViewDelegate ,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
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
            performSegue(withIdentifier: "GoToDetailProduct", sender: cell)
        }
    }
    
    
}
