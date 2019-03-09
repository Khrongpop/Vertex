//
//  ProductDetailViewController.swift
//  Vertex
//
//  Created by Khrongpop Phonngam on 12/31/2560 BE.
//  Copyright © 2560 Khrongpop Phonngam. All rights reserved.
//

import UIKit
import Firebase
class ProductDetailViewController: UIViewController {
    
    @IBAction func unwindToProductDetail(segue: UIStoryboardSegue){}
    
    fileprivate var comments = [Comment]()
    
    @IBOutlet weak var navbarItem: UINavigationItem!
    @IBOutlet weak var priceProductLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var detailProductLabel: UILabel!
    @IBOutlet weak var profileShopImage: UIImageView!
    @IBOutlet weak var nameuserLabel: UILabel!
    @IBOutlet weak var emailuserLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
     @IBOutlet weak var mobileLabel: UILabel!
    
    private var nameProduct: String = ""
    private var priceProduct: String = ""
    private var detailProduct: String = ""
    private var Shopid: String = ""
    private var URLproductImage: String = ""
    private var section: String = ""
    private var ref = DatabaseReference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        updateCells()
        tableView.dataSource = self
        tableView.delegate = self
         tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initdetail(post: Post) {
        nameProduct = post.nameProduct
        priceProduct = post.price
        detailProduct = post.description
        URLproductImage =  post.profile_image_url
        Shopid = post.uid
        section = post.section
        ref = post.ref
        
    }
    
    func updateView() {
        
        let userID = Auth.auth().currentUser?.uid
        
      
        
        UserService.instance.getUserInformations(WithUID: Shopid) { (userprofile) in
            self.nameuserLabel.text = userprofile?.fullname
            self.emailuserLabel.text = userprofile?.email
            self.ShopdownloadImgURL(imgaeURL: (userprofile?.URLimage)!)
            self.mobileLabel.text = userprofile?.Tell
        }
        
        self.nameLabel.text = nameProduct
        self.navbarItem.title = nameProduct
        self.priceProductLabel.text = priceProduct
        self.detailProductLabel.text = detailProduct
        let url = URL(string: URLproductImage)!
        self.ProductdownloadImgURL(imgaeURL: url)
        
    }
    
   
    
    func ShopdownloadImgURL(imgaeURL: URL) {
        let task = URLSession.shared.dataTask(with: imgaeURL, completionHandler: {
            (data,response,error) in
            
            guard let data = data ,error == nil else { return }
            DispatchQueue.main.async {
                self.profileShopImage.image = UIImage(data: data)
            }
        })
        
        task.resume()
    }
    
    func ProductdownloadImgURL(imgaeURL: URL) {
        let task = URLSession.shared.dataTask(with: imgaeURL, completionHandler: {
            (data,response,error) in
            
            guard let data = data ,error == nil else { return }
            DispatchQueue.main.async {
                self.productImage.image = UIImage(data: data)
            }
        })
        
        task.resume()
    }
    
    
    func updateCells() {
        let ref = Database.database().reference().child("CommentInformation").child(section)
        let pid = Shopid+nameProduct+section+priceProduct
        
        ref.observe(.value, with: { (snapshot) in
            self.comments.removeAll()
            
            for child in snapshot.children {
                let childSnapshot = child as! DataSnapshot
                let value = childSnapshot.value as? [String : Any]
                let post_id = value?["post_id"] as? String ?? ""
                
                if pid == post_id {
                    
                    let post = Comment(snapshot: childSnapshot)
                    self.comments.insert(post, at: 0)
                    
                }
                
                
            }
            self.tableView.reloadData()
            self.tableView.rowHeight = 110
           // print(self.comments.count)
            
        })
        
    }
    
    @IBAction func DidPressUser(_ sender: Any) {
        performSegue(withIdentifier: "infomationUser", sender: Shopid)
    }
    
    @IBAction func DidPressComment(_ sender: Any) {
        performSegue(withIdentifier: "comment", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
     
        
        if segue.identifier == "infomationUser" {
            let vc = segue.destination as! UserInfomationViewController
            vc.updateView(shopid: Shopid)
        }
        
        if segue.identifier == "infomationUserComment" {
            let post = sender as! Comment
            let vc = segue.destination as! UserInfomationViewController
            vc.updateView(shopid: post.uid)
        }
        
        if segue.identifier == "comment" {
            let  vc = segue.destination as! CommentViewController
            let post = Post(description: detailProduct, nameProduct: nameProduct, price: priceProduct, profile_img: URLproductImage, uid: Shopid, section: section, ref: ref) as! Post
            
            vc.ini(post: post)
            
        }
    }
    

}

extension ProductDetailViewController: UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if comments.count == 0 {
           return 1
        } else {
            return comments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       if comments.count == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "NoCommentCell") as? NoCommentCell {
                return cell
            } else {
                return CommentCell()
        }
        } else {
        
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as? CommentCell { //
                let comment = comments[indexPath.row]
                
                cell.updateView(comments: comment)
                
                return cell
            } else {
                return CommentCell() // สร้างใหม่ เป็นตัวเปล่าๆ
           }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if comments.count > 0 {
             let post = comments[indexPath.row]
            performSegue(withIdentifier: "infomationUserComment", sender: post)
        }
    }
    
}
