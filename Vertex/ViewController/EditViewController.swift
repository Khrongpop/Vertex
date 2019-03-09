//
//  EditViewController.swift
//  Vertex
//
//  Created by Khrongpop Phonngam on 12/31/2560 BE.
//  Copyright © 2560 Khrongpop Phonngam. All rights reserved.
//

import UIKit
import Firebase

class EditViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate  , UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var mobileTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    private let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyborads()
        nameTextfield.delegate = self
        mobileTextfield.delegate = self
        emailTextfield.delegate = self
        picker.delegate = self
        tabBarController?.tabBar.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateProfile() {
        
        let uid = Auth.auth().currentUser?.uid
        if let uid = uid {
            UserService.instance.getUserInformations(WithUID: uid) { (userprofile) in
                self.nameTextfield.text = userprofile?.fullname
                self.emailTextfield.text = userprofile?.email
                self.mobileTextfield.text = userprofile?.Tell
                self.downloadImgURL(imgaeURL: (userprofile?.URLimage)!)
            }
        } else {
            
        }
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
    
    @IBAction func editPhoto(_ sender: Any) {
        let  alert = UIAlertController(title: "Select your options", message: nil, preferredStyle: .actionSheet)
        
        // Create action button
        let photolibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.openPhotoLibrary()
        }
        let CameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.openCamera()
        }
        
        alert.addAction(photolibraryAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) { //ตรวจว่าดีไวซ์ มี camera หรือเปล่า
            alert.addAction(CameraAction)
        }
        
        // Cancel action button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func openPhotoLibrary() {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary //แหล่งข้อมูล
        picker.mediaTypes =  UIImagePickerController.availableMediaTypes(for: .photoLibrary)! // media อะไรบ้างที่รองรับ  รองรับทั้งหมดที่photolibraryรองรับได้
        self.present(picker, animated: true, completion: nil)
    }
    
    private func openCamera() {
        picker.allowsEditing = false
        picker.sourceType = .camera //แหล่งข้อมูล
        picker.mediaTypes =  UIImagePickerController.availableMediaTypes(for: .camera)! // media อะไรบ้างที่รองรับ  รองรับทั้งหมดที่photolibraryรองรับได้
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage   {  // original เพราะไม่ได้ aloowsEdittins  ถ้าEditได้ต้องเป็น UIImagePickerControllerEditedImage
            profileImage.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ConfirmEdit(_ sender: Any) {
        
        guard let name = nameTextfield.text
            , let email = emailTextfield.text
            , let mobile = mobileTextfield.text
            , let profileImage = profileImage.image
            else { print("again")
                return }
        
        if Validator.isValid(checkEmty: name)
            ,  Validator.isValid(checkEmty: email)
            ,  Validator.isValid(checkEmty: mobile) {
            
            print("User edit.")
            
            AuthService.instance.editprofile(withName: name, email: email, mobile: mobile, Image: profileImage, completion: { (user, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    
                    print("save profile infomation done")
                    
                    
                    let  alert = UIAlertController(title: "Edit Profile Done!", message: nil, preferredStyle: .alert)
                    let done = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        //self.dismiss(animated: true, completion: nil)
                        self.performSegue(withIdentifier: "unwindToProfile", sender: nil)
                    })
                    alert.addAction(done)
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToProfile" {
            let vc = segue.destination as! ProfileViewController
            vc.updateProfile()
        }
    }
    

}
