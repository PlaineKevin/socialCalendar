//
//  EventsTableViewController.swift
//  socialCalendar
//
//  Created by Miles Crabill on 12/12/14.
//  Copyright (c) 2014 AIT. All rights reserved.
//

import UIKit

class EventsTableViewController: UITableViewController {

    var eventsData = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        var addAllEvents: PFQuery = PFQuery(className: "Event")
        addAllEvents.findObjectsInBackgroundWithBlock({
            (objects: [AnyObject]!, error: NSError!) -> Void in
            self.eventsData = objects as [PFObject]
            self.tableView.reloadData()
        })
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.eventsData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as EventTableViewCell

        // Configure the cell...
        let event: PFObject = self.eventsData[indexPath.row] as PFObject
        
        
        //        var friend: Friend
        //
        //        if tableView == searchDisplayController!.searchResultsTableView {
        //
        //            friend = filteredFriends![indexPath.row] as Friend
        //        }
        //        else {
        //            let temp = sortedFriends.first!
        //            friend = sortedFriends[indexPath.row] as Friend
        //        }
        //
        cell.name.text = event.objectForKey("name") as String
        cell.participants.text = event.objectForKey("editors") as String
        var dateDate = event.objectForKey("date") as NSDate
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        var strDate = dateFormatter.stringFromDate(dateDate)
        cell.date.text = strDate

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            if editingStyle == .Delete {
                //            CoreData
                //            let managedObjectContext = AppDelegate.sharedAppDelegate.managedObjectContext!
                //            managedObjectContext.deleteObject(sortedFriends[indexPath.row])
                //            sortedFriends.removeAtIndex(indexPath.row)
                //            AppDelegate.sharedAppDelegate.saveContext()
                
                //            friendsData.removeAtIndex(indexPath.row)
                
                
                eventsData[indexPath.row].deleteInBackgroundWithBlock({
                    (bools: Bool, error: NSError!) -> Void in
                    
                    if error != nil {
                        println("error")
                    }
                    
                    //                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    self.loadData()
                    
                })
                
            }
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        let eventsToMove: PFObject = eventsData[fromIndexPath.row] as PFObject
        eventsData.removeAtIndex(fromIndexPath.row)
        eventsData.insert(eventsToMove, atIndex: toIndexPath.row)

    }


    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }



    // MARK: - Navigation

//     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "eventDetailSegue" {
            
            let destinationViewController = segue.destinationViewController as EventDetailsTableViewController
            
            if searchDisplayController!.active {
                
                if let selectedRow = searchDisplayController!.searchResultsTableView.indexPathForSelectedRow()?.row {
                    
                    //                    destinationViewController.friend = filteredFriends?[selectedRow]
                }
                
            } else {
                //                let friend = sortedFriends[tableView.indexPathForSelectedRow()!.row]
                let event = eventsData[tableView.indexPathForSelectedRow()!.row]
                
                destinationViewController.event = event
            }
        }
    }

}
