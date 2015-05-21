//
//  friendviewcontroller.swift
//  shoppinglist
//
//  Created by Wu Chen on 5/15/15.
//  Copyright (c) 2015 Wu Chen. All rights reserved.
//

import UIKit
import Parse

class friendviewcontroller: UITableViewController {
    
    // firends is the model of this tableview, stores all the friend's name in an Array of String
    
    var friends: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
        updatefriendlist()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        updatefriendlist()
    }
    
    /*
        updatefriendlist updates the friendlist by pulling all the newest friend relationship from PFUser's friends relationship
    
    
    
    */
    func updatefriendlist() {
        if let user = PFUser.currentUser() {
            friends.removeAll(keepCapacity: true)
            if let friendship = user["friendship"] as? PFObject {
               let friendlist = friendship.relationForKey("members")
                if let friendsquery = friendlist.query() {
                    friendsquery.selectKeys(friendlistviewcontrollerconst.friendquerykeys)
                    friendsquery.findObjectsInBackgroundWithBlock({ (list, frienderror) -> Void in
                        if frienderror == nil && list != nil {
                            if let existfriends = list as? [PFUser] {
                                for existfriend in existfriends {
                                     self.friends.append(existfriend.username!)
                                }
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    self.tableView.reloadData()
                                })
                            }
                        }
                    })
                }
            } /*else {
               let friendship = PFObject(className: "friendship")
               friendship["owner"] = user.username
               friendship.saveInBackgroundWithBlock({ (success, error) -> Void in
                   if success && error == nil {
                       user["friendship"] = friendship
                       user.saveInBackground()
                   }
               })
            }
            */
            
        } else {
            
            // handles situation when user is not logged in
            
        }
        
    }
    
    /*
       
func updatefriendlist() {
if let user = PFUser.currentUser() {
friends.removeAll(keepCapacity: true)
let friendlist = user.relationForKey(friendlistviewcontrollerconst.keyforfriendsrelationship)
if let friendsquery = friendlist.query() {
friendsquery.selectKeys(friendlistviewcontrollerconst.friendquerykeys)
friendsquery.findObjectsInBackgroundWithBlock({ ( list, error) -> Void in
if error == nil {
if let existfriendlist = list as? [PFUser] {
for existfriend in existfriendlist {
self.friends.append(existfriend.username!)
}
dispatch_async(dispatch_get_main_queue(), { () -> Void in
self.tableView.reloadData()
})
}
} else {
// if fetch friendlist fails
}
})
}
} else {

// handles situation when user is not logged in

}

}

*/

    func loadUI(){
        self.navigationItem.title = friendlistviewcontrollerconst.viewcontrollertitle
    }

    //friendlistviewcontrollerconst store all the constant used in this viewcontroller

    private struct friendlistviewcontrollerconst {
        static let friendcellidentifier:String = "friendcell"
        static let keyforfriendsrelationship:String = "friends"
        static let viewcontrollertitle:String = "Friends"
        static let friendquerykeys:[String] = ["username"]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(friendlistviewcontrollerconst.friendcellidentifier) as! UITableViewCell
        cell.textLabel?.text = friends[indexPath.row]
        return cell
        
        
    }

}
