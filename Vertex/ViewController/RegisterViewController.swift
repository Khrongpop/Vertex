//
//  RegisterViewController.swift
//  Vertex
//
//  Created by Khrongpop Phonngam on 12/31/2560 BE.
//  Copyright © 2560 Khrongpop Phonngam. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate , UITextFieldDelegate{

    @IBAction func unwindTolRegis (segue: UIStoryboardSegue) {}
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var fullnameText: UITextField!
    @IBOutlet weak var TellTextField: UITextField!
    
    @IBOutlet weak var SubmitButton: UIButton!
    @IBOutlet weak var ProfileButton: UIButton!
    
    @IBOutlet var ProfileImg: UIImageView! // UIImagePickerController -> actionsheet , UIAlertController
    private let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyborads()
        picker.delegate = self // ต้องรู้ว่าเวลาเลือกรูปแล้วต้องส่งกลับมาคลาสไหน
        
        self.ProfileImg.layer.borderWidth = 1
        fullnameText.delegate = self
        TellTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func clear() {
        self.ProfileImg.image = nil
        self.ProfileButton.setTitle("+", for: .normal)
        self.emailTextField.text = nil
        self.passwordTextField.text = nil
        self.TellTextField.text = nil
    }
    @IBAction func editProfile(_ sender: Any) {
        
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) { //หลังจากเลือกรูปเสร็จ
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage   {  // original เพราะไม่ได้ aloowsEdittins  ถ้าEditได้ต้องเป็น UIImagePickerControllerEditedImage
            self.ProfileImg.image = selectedImage
            self.ProfileButton.setTitle(nil, for: .normal)
            self.ProfileImg.layer.borderWidth = 0
        }
        dismiss(animated: true, completion: nil)
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
    @IBAction func didPressedSubmit(_ sender: Any) {
        
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let fullName = fullnameText.text,
            let tell = TellTextField.text,
            let profileImage = ProfileImg.image
            else {return}
        
        if Validator.isValid(email: email),
            Validator.isValid(password: password),
            Validator.TellisValid(Tell: tell) {
            
            print("User created.")
            
            AuthService.instance.signUp(withEmail: email, password: password,tell: tell, fullname: fullName, profileImage: profileImage, completion: { (user, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            print(error?.localizedDescription)
                        } else {
                            print(user?.email)
                            AuthService.instance.isLoggedIn = true
                            
                        }
                    })
                }
                
                self.performSegue(withIdentifier: "unwindToTabbar", sender: nil)
                
            })
        }
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToFeeds" {
        //    let vc = segue.destination as! InterestsViewController
        //    vc.updateProfile()
            // let vcprofile = ProfileViewController()
            //  vcprofile.updateProfile()
        }
        self.clear()
    }
    
    
    @IBAction func backTologin(_ sender: Any) {
        performSegue(withIdentifier: "unwindToLogin", sender: nil)
    }
    
   
    
    

}



