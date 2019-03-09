//
//  PostViewController.swift
//  Vertex
//
//  Created by Khrongpop Phonngam on 12/31/2560 BE.
//  Copyright © 2560 Khrongpop Phonngam. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate , UIImagePickerControllerDelegate, UINavigationControllerDelegate , UITextViewDelegate , UITextFieldDelegate {
    
    @IBOutlet weak var pickerTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var editPicture: UIButton!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var picker = UIPickerView()
    let pickItem = ["CLOTHING","SHOES","ACCESSORIES","ELECTRONIC","ETC"]
    var valueOfpicker: String!
    
    @IBOutlet var ProfileImg: UIImageView!
    private let pickerImg = UIImagePickerController()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ProfileImg.layer.borderWidth = 1
        pickerTextField.inputView = picker
        picker.delegate = self
        picker.dataSource = self
        pickerImg.delegate = self
        self.hideKeyborads()
        super.viewDidLoad()
        self.clearData()
        nameTextField.delegate = self
        pickerTextField.delegate = self
        descriptionTextView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    

   
    func clearData() {
        nameTextField.text = nil
        priceTextField.text = nil
        descriptionTextView.text = nil
        pickerTextField.text = nil
        editPicture.setTitle("+", for: .normal)
        ProfileImg.image = nil
        self.ProfileImg.layer.borderWidth = 1
        self.ProfileImg.layer.borderColor = UIColor.init(red: 210/255.0, green: 210/255.0, blue: 210/255.0, alpha: 1.0).cgColor
        self.descriptionTextView.layer.borderColor = UIColor.init(red: 210/255.0, green: 210/255.0, blue: 210/255.0, alpha: 1.0).cgColor
        self.descriptionTextView.layer.borderWidth = 1
        self.descriptionTextView.layer.cornerRadius = 5
        self.descriptionTextView.layer.masksToBounds = false
        descriptionTextView.text = "Description ..."
        descriptionTextView.textColor = UIColor.lightGray
        
    }
    
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextView.text.isEmpty {
            descriptionTextView.text = "Description ..."
            descriptionTextView.textColor = UIColor.lightGray
        }
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextView.textColor == UIColor.lightGray {
            descriptionTextView.text = nil
            descriptionTextView.textColor = UIColor.black
        }
    }
    
    
    
    
    
    
    
    
    
    @IBAction func UploadPost(_ sender: Any) {
        
        guard let productname = nameTextField.text ,
            let price = priceTextField.text ,
            let description = descriptionTextView.text ,
            let section = pickerTextField.text ,
            let itemImage = ProfileImg.image
            else {
                return
        }
        
        if Validator.isValid(checkEmty: productname)
            , Validator.isValid(checkEmty: price)
            , Validator.isValid(checkEmty: description)
            , Validator.isValid(checkEmty: section) {
            AuthService.instance.savePostInformation(withNameProduct: productname, price: price, description: description, ItemImage: itemImage, Section: section, completion: { (error) in
                if let error = error {
                    print(error)
                } else {
                    print("save post infomation done")
                    
                    
                    let  alert = UIAlertController(title: "Upload Done!", message: nil, preferredStyle: .alert)
                    let done = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.dismiss(animated: true, completion: nil)
                        self.clearData()
                    })
                    alert.addAction(done)
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
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
    
  
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) { //หลังจากเลือกรูปเสร็จ
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage   {  // original เพราะไม่ได้ aloowsEdittins  ถ้าEditได้ต้องเป็น UIImagePickerControllerEditedImage
            print(selectedImage)
            ProfileImg.image = selectedImage
            self.ProfileImg.layer.borderWidth = 0
        }
        editPicture.setTitle(nil, for: .normal)
        dismiss(animated: true, completion: nil)
    }
    
    private func openPhotoLibrary() {
        pickerImg.allowsEditing = false
        pickerImg.sourceType = .photoLibrary //แหล่งข้อมูล
        pickerImg.mediaTypes =  UIImagePickerController.availableMediaTypes(for: .photoLibrary)! // media อะไรบ้างที่รองรับ  รองรับทั้งหมดที่photolibraryรองรับได้
        self.present(pickerImg, animated: true, completion: nil)
    }
    
    private func openCamera() {
        pickerImg.allowsEditing = false
        pickerImg.sourceType = .camera //แหล่งข้อมูล
        pickerImg.mediaTypes =  UIImagePickerController.availableMediaTypes(for: .camera)! // media อะไรบ้างที่รองรับ  รองรับทั้งหมดที่photolibraryรองรับได้
        self.present(pickerImg, animated: true, completion: nil)
    }
    
   
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickItem.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickItem[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerTextField.text = (pickItem[row])
    }
    

}
