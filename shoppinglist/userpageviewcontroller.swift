//
//  userpageviewcontroller.swift
//  shoppinglist
//
//  Created by Wu Chen on 5/18/15.
//  Copyright (c) 2015 Wu Chen. All rights reserved.
//

import UIKit
import Parse

class userpageviewcontroller: UIViewController {
    
    @IBOutlet weak var displayname: UILabel! {
        didSet {
            displayname.text = name
        }
    }
    
    @IBAction func sendrequest(sender: AnyObject) {
        
        sendfriendrequest()
        
    }
    
    var name:String? {
        didSet{
            displayname?.text = name
        }
    }
    
    func sendfriendrequest() {
        
        if let requestusername = name {
            if let mainuser = PFUser.currentUser() {
                let requesteduserquery = PFUser.query()
                requesteduserquery?.whereKey("username", equalTo: requestusername)
                requesteduserquery?.findObjectsInBackgroundWithBlock({(usersfind, error) -> Void in
                    if ( error == nil && usersfind != nil && usersfind!.count != 0 ) {
                        if let usersfound = usersfind as? [PFUser] {
                            for userfound in usersfound {
                                if let mainuserfriendship = mainuser["friendship"] as? PFObject {
                                    var mainfriendrelation = mainuserfriendship.relationForKey("members")
                                    mainfriendrelation.addObject(userfound)
                                    mainuserfriendship.saveInBackground()
                                    if let finduserfriendship = userfound["friendship"] as? PFObject {
                                        var findfriendrelation = finduserfriendship.relationForKey("members")
                                        findfriendrelation.addObject(mainuser)
                                        finduserfriendship.saveInBackground()
                                    }
                                }
                            }
                       } else {
                            println("conversion fail")
                       }
                    } else {
                        println("request failed")
                        println(error)
                    }
                })
                
            }
        }
    }


}
