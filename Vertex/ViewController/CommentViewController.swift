//
//  CommentViewController.swift
//  Vertex
//
//  Created by Khrongpop Phonngam on 12/31/2560 BE.
//  Copyright © 2560 Khrongpop Phonngam. All rights reserved.
//

import UIKit
import Firebase

class CommentViewController: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate , UITextViewDelegate ,UITextFieldDelegate {

   
    
    @IBOutlet weak var navitem: UINavigationItem!
    
    @IBOutlet weak var TextView: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var itemImage: UIImageView!
    
    private var nameProduct: String = ""
    private var priceProduct: String = ""
    private var detailProduct: String = ""
    private var uid: String = ""
    private var URLproductImage: String = ""
    private var section: String = ""
    private var ref = DatabaseReference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyborads()
        updateView()
        TextView.delegate = self
        self.TextView.layer.borderWidth = 1
        self.TextView.layer.cornerRadius = 5
        self.TextView.layer.masksToBounds = false
        TextView.text = "Description ..."
        TextView.textColor = UIColor.lightGray
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didBack(_ sender: Any) {
        performSegue(withIdentifier: "unwindtoProductDetail", sender: nil)
    }
    
    @IBAction func didPressPost(_ sender: Any) {
        
        let comment = TextView.text
        let post = Post(description: description, nameProduct: nameProduct, price: priceProduct, profile_img: URLproductImage, uid: uid, section: section, ref: ref) as! Post
        
        
        if let comment = comment {
            
            
            AuthService.instance.addCommentToDatabase(comment: comment, post: post )
            
            let  alert = UIAlertController(title: "Comment Success!", message: nil, preferredStyle: .alert)
            let done = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                //self.dismiss(animated: true, completion: nil)
                self.clearData()
                self.performSegue(withIdentifier: "unwindtoProductDetail", sender: nil)
            })
            alert.addAction(done)
            self.present(alert, animated: true, completion: nil)
            
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if TextView.text.isEmpty {
            TextView.text = "your comment"
            TextView.textColor = UIColor.lightGray
        }
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if TextView.textColor == UIColor.lightGray {
            TextView.text = nil
            TextView.textColor = UIColor.black
        }
    }
    
    func ini(post: Post) {
        self.detailProduct = post.description
        self.nameProduct = post.nameProduct
        self.priceProduct = post.price
        self.URLproductImage = post.profile_image_url
        self.uid = post.uid
        self.section = post.section
        self.ref = post.ref
    }
    
    func updateView() {
        self.TextView.layer.borderColor = UIColor.init(red: 210/255.0, green: 210/255.0, blue: 210/255.0, alpha: 1.0).cgColor
        self.TextView.layer.borderWidth = 1
        self.TextView.layer.cornerRadius = 5
        self.navitem.title = nameProduct
        let url = URL(string: URLproductImage)
        self.downloadImgURL(imgaeURL: url!)
       
        let uid = Auth.auth().currentUser?.uid
        UserService.instance.getUserInformations(WithUID: uid!) { (user) in
            let u_img = user?.URLimage
            self.PdownloadImgURL(imgaeURL: u_img!)
        }
    }
    
    func clearData() {
        TextView.text = nil
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func downloadImgURL(imgaeURL: URL) {
        let task = URLSession.shared.dataTask(with: imgaeURL, completionHandler: {
            (data,response,error) in
            
            guard let data = data ,error == nil else { return }
            DispatchQueue.main.async {
                self.itemImage.image = UIImage(data: data)
            }
        })
        
        task.resume()
    }
    
    func PdownloadImgURL(imgaeURL: URL) {
        let task = URLSession.shared.dataTask(with: imgaeURL, completionHandler: {
            (data,response,error) in
            
            guard let data = data ,error == nil else { return }
            DispatchQueue.main.async {
          //      self.profileImage.image = UIImage(data: data)
            }
        })
        
        task.resume()
    }

}
