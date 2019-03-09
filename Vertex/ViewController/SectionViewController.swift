//
//  SectionViewController.swift
//  Vertex
//
//  Created by Khrongpop Phonngam on 12/31/2560 BE.
//  Copyright © 2560 Khrongpop Phonngam. All rights reserved.
//

import UIKit
import Firebase
class SectionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    fileprivate var posts = [Post]()
    @IBOutlet weak var navitem: UINavigationItem!
    private var nameType: String?
    
    override func viewDidAppear(_ animated: Bool) {
        updateViews(titleProduct: nameType!)
        print(self.tableView)
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
    
    func initProduct(category: Category) {
        nameType = category.title
        print(category.title)
        
    }
    
    
    func updateViews (titleProduct: String) {
        
       navitem.title = nameType
        
        let ref = Database.database().reference().child("PostInformation").child(titleProduct)
        ref.observe(.value, with: { (snapshot) in
            self.posts.removeAll()
            
            for child in snapshot.children {
                let childSnapshot = child as! DataSnapshot
                let post = Post(snapshot: childSnapshot)
                self.posts.insert(post, at: 0)
            }
            print(self.tableView)
            self.tableView.reloadData()
            self.tableView.rowHeight = 304;
        })
        
    }/*
    
    func updateProfile() {
        
        let userID = Auth.auth().currentUser?.uid
        
        if let userID = userID {
            UserService.instance.getUserInformations(WithUID: userID) { (userProfile) in
                
                if let userProfile = userProfile {
                    
                    self.downloadImgURL(imgaeURL: (userProfile.URLimage))
                }
            }
            
        }
        
        
    }
    
    func downloadImgURL(imgaeURL: URL) {
        let task = URLSession.shared.dataTask(with: imgaeURL, completionHandler: {
            (data,response,error) in
            
            guard let data = data ,error == nil else { return }
            DispatchQueue.main.async {
                //  self.profileImage.image = UIImage(data: data)
            }
        })
        
        task.resume()
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToDetailProduct" {
            let vc = segue.destination as! ProductDetailViewController
            print(sender)
            let post = sender as! Post
            vc.initdetail(post: post)
        }
    }


}
extension SectionViewController: UITableViewDataSource ,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return posts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as? ProductCell { //
            let post = posts[indexPath.row]
            
            cell.updateView(post: post)
            return cell
        } else {
            
            return ProductCell() // สร้างใหม่ เป็นตัวเปล่าๆ
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = posts[indexPath.row]
        
        performSegue(withIdentifier: "GoToDetailProduct", sender: cell)
    }
    
    
}
