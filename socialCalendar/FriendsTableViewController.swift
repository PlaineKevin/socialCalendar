//
//  FriendsTableViewController.swift
//  socialCalendar
//
//  Created by Kevin Nguyen on 12/2/14.
//  Copyright (c) 2014 AIT. All rights reserved.
//

import UIKit

class FriendsTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {

    let friendManager = FriendManager.sharedFriendManager
    
    var filteredFriends : [Friend]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == searchDisplayController!.searchResultsTableView
        {
            if filteredTrips == nil {
                return 0
            }
            else {
                return filteredTrips!.count
            }
            
        } else {
            return friendManager.friends.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as FriendTableViewCell
        
        var friend: Friend
        
        if tableView == searchDisplayController!.searchResultsTableView {
            
            friend = filteredFriends![indexPath.row]
        }
        else {
            friend = friendManager.friends[indexPath.row]
        }
        
        cell.usernameLabel?.text = friend.username
        cell.userImage?.image = friend.image

        return cell
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            // Delete the row from the data source
            
            friendManager.friends.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        }
    }
    
    
    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        
        let friendToMove = friendManager.friends[fromIndexPath.row]
        friendManager.friends.removeAtIndex(fromIndexPath.row)
        friendManager.friends.insert(tripToMove, atIndex: toIndexPath.row)
    }
    
    
    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "friendDetailSegue" {
            
            let destinationViewController = segue.destinationViewController as FriendDetailsTableViewController
            
            if searchDisplayController!.active {
                
                if let selectedRow = searchDisplayController!.searchResultsTableView.indexPathForSelectedRow()?.row {
                    
                    destinationViewController.friend = filteredFriends?[selectedRow]
                }
                
            } else {
                
                let friend = friendManager.friends[tableView.indexPathForSelectedRow()!.row]
                destinationViewController.friend = friend
            }
        }
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        
        filteredFriends = friendManager.filteredRemindersForSearchText(searchString)
        
        return true
    }

}
