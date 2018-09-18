//
//  LoginViewController.swift
//  FireBaseChat
//
//  Created by Na jiwon on 2018. 9. 18..
//  Copyright © 2018년 Na jiwon. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    let remoteConfig = RemoteConfig.remoteConfig()
    var color: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let statusBar = UIView()
        self.view.addSubview(statusBar)
        statusBar.snp.makeConstraints { (m) in
            m.right.top.left.equalTo(self.view)
            m.height.equalTo(50)
        }
        
        color = remoteConfig["splash_background"].stringValue
        statusBar.backgroundColor = UIColor(hex: color)
        loginButton.backgroundColor = UIColor(hex: color)
        signUpButton.backgroundColor = UIColor(hex: color)
        
        signUpButton.addTarget(self, action: #selector(presentSignup), for: .touchUpInside)
    }
    
    @IBAction func presentSignup() {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        self.present(view, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
