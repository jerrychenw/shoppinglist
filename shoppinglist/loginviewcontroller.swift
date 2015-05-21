//
//  loginviewcontroller.swift
//  shoppinglist
//
//  Created by Wu Chen on 5/16/15.
//  Copyright (c) 2015 Wu Chen. All rights reserved.
//

import UIKit
import Parse

class loginviewcontroller: UIViewController {
    
    
    @IBOutlet weak var usernametxt: UITextField!
    
    @IBOutlet weak var passwdtxt: UITextField!
    
    @IBAction func loginbutton(sender: AnyObject) {
        
        login()
        
    }
    
    @IBAction func signupbutton(sender: AnyObject) {
        
        signup()
    }
    
    var username:String? {
        set{
            usernametxt.text = newValue
        }
        get{
            return usernametxt?.text
        }
    }
    
    
    var password:String? {
        set{
            passwdtxt.text = newValue
        }
        get{
            return passwdtxt?.text
        }
        
    }
    
    
    private func login() {
        if username != nil && password != nil  {
            PFUser.logInWithUsernameInBackground(username!, password: password!) {
                (lguser: PFUser?, lgerror: NSError?) -> Void in
                if lguser != nil {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.performSegueWithIdentifier("login", sender: nil)
                    })
                } else {
                    println("login failed")
                }
            }
        }
    }
    
    private func signup() {
        if username != nil && password != nil {
            var newuser = PFUser()
            newuser.username = username
            newuser.password = password
            newuser.signUpInBackgroundWithBlock({ (success, signuperror) -> Void in
                if success && signuperror == nil {
                    var friendship = PFObject(className: "friendship")
                    friendship["owner"] = newuser.username
                    friendship.saveInBackground()
                    var groupship = PFObject(className: "groupship")
                    groupship["owner"] = newuser.username
                    groupship.saveInBackground()
                    newuser["friendship"] = friendship
                    newuser["groupship"] = groupship
                    newuser.saveInBackground()
                } else if signuperror != nil {
                    println(signuperror)
                }
            })
            
        
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    

}
