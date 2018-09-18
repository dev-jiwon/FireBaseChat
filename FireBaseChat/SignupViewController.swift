//
//  SignupViewController.swift
//  FireBaseChat
//
//  Created by Na jiwon on 2018. 9. 18..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignupViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    let remoteConfig = RemoteConfig.remoteConfig()
    var color: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setViews()
        signUpButton.addTarget(self, action: #selector(signUpEvent), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelEvent), for: .touchUpInside)
    }
    
    func setViews() {
        let statusBar = UIView()
        self.view.addSubview(statusBar)
        statusBar.snp.makeConstraints { (m) in
            m.right.top.left.equalTo(self.view)
            m.height.equalTo(50)
        }
        
        color = remoteConfig["splash_background"].stringValue
        statusBar.backgroundColor = UIColor(hex: color)
        
        signUpButton.backgroundColor = UIColor(hex: color)
        cancelButton.backgroundColor = UIColor(hex: color)
    }
    
    @IBAction func signUpEvent() {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, err) in
            let uid = user!.user.uid
            
            Database.database().reference().child("user").child(uid).setValue(["name":self.nameTextField.text!])
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelEvent() {
        self.dismiss(animated: true, completion: nil)
    }
}
