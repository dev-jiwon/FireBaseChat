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

class SignupViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
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
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imagePickerEvent)))
    }
    
    @IBAction func imagePickerEvent() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpEvent() {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, err) in
            let uid = user!.user.uid
            
            let image = UIImageJPEGRepresentation(self.imageView.image!, 0.1)
            
            let storageRef = Storage.storage().reference().child("userImages").child(uid)
            storageRef.putData(image!, metadata: nil, completion: { (data, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                storageRef.downloadURL(completion: { (url, error) in
                    if let _ = error{
                        return
                    }
                    if url != nil{
                        let imageUrl = url?.absoluteString
                        let values = ["userName":self.nameTextField.text!, "profileImageUrl":imageUrl]
                        Database.database().reference().child("users").child(uid).setValue(values, withCompletionBlock: { (error, ref) in
                            if error == nil {
                                self.cancelEvent()
                            }
                        })
//                        Database.database().reference().child("users").child(uid).setValue(["userName":self.nameTextField.text!, "profileImageUrl":imageUrl])
                    }
                })
            })
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelEvent() {
        self.dismiss(animated: true, completion: nil)
    }
}
