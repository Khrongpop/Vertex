//
//  LoginViewController.swift
//  Vertex
//
//  Created by Khrongpop Phonngam on 12/31/2560 BE.
//  Copyright © 2560 Khrongpop Phonngam. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController ,UITextFieldDelegate {

    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var SignupButton: UIButton!
    
    @IBAction func unwindTologin (segue: UIStoryboardSegue) {}
    
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyborads()
        EmailTextField.delegate = self
        PasswordTextField.delegate = self
        //EmailTextField.text
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LoginPress(_ sender: Any) {
        if let email = EmailTextField.text, let password = PasswordTextField.text, password.count >= 6 {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error != nil {
                    print(error?.localizedDescription)
                } else {
                    print(user?.email)
                    AuthService.instance.isLoggedIn = true
                    // self.dismiss(animated: true, completion: nil) //ปิดหน้านั้น
                    self.performSegue(withIdentifier: "unwindToTabbar", sender: user?.uid)
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToFeeds"
        {
            // let vc = segue.destination as! InterestsViewController
            //vc.updateProfile()
        }
    }
    
    @IBAction func SignUpPress(_ sender: Any) {
        print("kkk")
        performSegue(withIdentifier: "unwindToRegister", sender: nil)
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}

extension UIViewController
{
    func hideKeyborads()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    
}
