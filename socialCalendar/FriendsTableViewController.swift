//
//  FriendsTableViewController.swift
//  socialCalendar
//
//  Created by Kevin Nguyen on 12/2/14.
//  Copyright (c) 2014 AIT. All rights reserved.
//

import UIKit
import CoreData

class FriendsTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {

    let friendManager = FriendManager.sharedFriendManager
    
    var filteredFriends : [Friend]?
    var sortedFriends = [Friend]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // self-sizing table view cells
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchFriends();
        
        // might need this here but not if we reload data somewhere else
        tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == searchDisplayController!.searchResultsTableView
        {
            if filteredFriends == nil {
                return 0
            }
            else {
                return filteredFriends!.count
            }
            
        } else {
            print(sortedFriends.count)
            return sortedFriends.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as FriendTableViewCell
        
        var friend: Friend
        
        if tableView == searchDisplayController!.searchResultsTableView {
            
            friend = filteredFriends![indexPath.row] as Friend
        }
        else {
            let temp = sortedFriends.first!
            friend = sortedFriends[indexPath.row] as Friend
        }
        
        cell.usernameLabel.text = friend.userName
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
            let managedObjectContext = AppDelegate.sharedAppDelegate.managedObjectContext!
            managedObjectContext.deleteObject(sortedFriends[indexPath.row])
            sortedFriends.removeAtIndex(indexPath.row)
            AppDelegate.sharedAppDelegate.saveContext()
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        
        let friendToMove = sortedFriends[fromIndexPath.row]
        sortedFriends.removeAtIndex(fromIndexPath.row)
        sortedFriends.insert(friendToMove, atIndex: toIndexPath.row)
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
                let friend = sortedFriends[tableView.indexPathForSelectedRow()!.row]
                destinationViewController.friend = friend
            }
        }
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        
        filteredFriends = friendManager.filteredRemindersForSearchText(searchString)
        
        return true
    }
    
    //Mark: - Core Data
    
    func fetchFriends() {
        let managedObjectContext = AppDelegate.sharedAppDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "Friend")
        
        let sortDescriptor = NSSortDescriptor(key: "userName", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResults = managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as [Friend]
        
        sortedFriends = fetchedResults
    }

}
