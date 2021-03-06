//
//  SettingsViewController.swift
//  Giraffe
//
//  Created by Maslov Sergey on 15.10.16.
//  Copyright © 2016 ROKO. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FBSDKCoreKit

class SettingsViewController: BaseRevealViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        loginButton.center = view.center
        loginButton.delegate = self
        view.addSubview(loginButton)
        
        
        if let _ = AccessToken.current {
            if let userName = UserDefaults.standard.object(forKey: kFacebookUserNameKey) as? String {
               self.userName.text = userName
            }
            //updateUserInfo()
        }
        
        self.view.backgroundColor = UIColor.giraffeDarkColor
    }
    
    func updateUserInfo() {
        let pictureRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, gender, first_name"])
        pictureRequest?.start(completionHandler: {
            _, result, error in
            if error == nil {
                print("\(result)")
                if let params = result as? [String:String] {
                    if let userName = params["first_name"] {
                        self.userName.text = userName
                        print("User Name is: \(userName)")
                        UserDefaults.standard.set(userName, forKey: kFacebookUserNameKey)
                    }
                    if let userId = params["id"] {
                        print("User id is: \(userId)")
                        UserDefaults.standard.set(userId, forKey: kFacebookUserIdKey)
                        
                    }
                }
            } else {
                print("\(error)")
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension SettingsViewController: LoginButtonDelegate {
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        updateUserInfo()
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        userName.text = "Hello"
    }
}
