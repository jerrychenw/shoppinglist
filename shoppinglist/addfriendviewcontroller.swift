//
//  addfriendviewcontroller.swift
//  shoppinglist
//
//  Created by Wu Chen on 5/17/15.
//  Copyright (c) 2015 Wu Chen. All rights reserved.
//

import UIKit
import Parse

class addfriendviewcontroller: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var friendsearch: UISearchBar! {
        didSet {
            friendsearch.placeholder = addfriendvcconst.searchbarplaceholder
            friendsearch.delegate = self
        }
    }
    
    var matchlist:[String] = [String]()
    
    var searchcount = 0
    
    var friendcheck:[String:Bool] = [String:Bool]()
    
    var searchstring:String? {
        set{
            friendsearch?.text = newValue
            updateSearchlist()
        }
        get{
            return friendsearch?.text
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let friendvc = presentingViewController as? friendviewcontroller {
            for friend in friendvc.friends {
                friendcheck[friend] = true
            }
        }
    }
    
    private struct addfriendvcconst {
        static let searchbarplaceholder:String = "enter username"
        static let addfriendcellidentifier:String = "searchfriendcell"
        static let showuseridentifier:String = "showuser"
    }
    
    private struct newsearch {
        var searchsequence = 0
        var searchresult = [String]()
    }

    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchstring = searchText
    }

    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        updateSearchlist()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchstring = ""
    }
    

    
    func updateSearchlist() {
        if searchstring != "" {
           matchlist.removeAll(keepCapacity: true)
           var usersearch = PFUser.query()
           usersearch!.whereKey("username", containsString: searchstring)
           usersearch!.findObjectsInBackgroundWithBlock({ (usersfound, error) -> Void in
               if error == nil {
                  var newsearchresult = newsearch(searchsequence: self.searchcount, searchresult: [String]())
                  self.searchcount++
                  for user in usersfound as! [PFUser] {
                      newsearchresult.searchresult.append(user.username!)
                  }
                  if newsearchresult.searchsequence >= (self.searchcount-1){
                      self.matchlist = newsearchresult.searchresult
                      self.searchcount = 0
                  }
                  dispatch_async(dispatch_get_main_queue(), { () -> Void in
                      self.tableView.reloadData()
                  })
               } else {
                   println(error)
               }
           })
        } else {
            matchlist.removeAll(keepCapacity: true)
            tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return matchlist.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(addfriendvcconst.addfriendcellidentifier) as! UITableViewCell
        cell.textLabel?.text = matchlist[indexPath.row]
        return cell
    
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        performSegueWithIdentifier(addfriendvcconst.showuseridentifier, sender: indexPath)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case addfriendvcconst.showuseridentifier:
                if let dvc = segue.destinationViewController as? userpageviewcontroller {
                    let indexpath = sender as! NSIndexPath
                    dvc.name = matchlist[indexpath.row]
                }
            default:break
                
            }
        }
    }
    
    
}
