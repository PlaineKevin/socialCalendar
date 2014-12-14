//
//  EventDetailsTableViewController.swift
//  socialCalendar
//
//  Created by Kevin Nguyen on 12/14/14.
//  Copyright (c) 2014 AIT. All rights reserved.
//

import UIKit

class EventDetailsTableViewController: UITableViewController {

    var event: PFObject!

    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var participants: UITextField!
    @IBOutlet weak var details: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let imageObject = event["image"] as PFFile
        imageObject.getDataInBackgroundWithBlock({
            (imageData: NSData!, error: NSError!) -> Void in
            if error == nil {
                let image = UIImage(data: imageData)
                self.imageView.image = image
            }
            
        })
        
        eventName.text = event["name"] as String
        participants.text = event["editors"] as String?
        details.text = event["details"] as String

    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "editEvent" {
            
            let navigationController = segue.destinationViewController as UINavigationController
            let editEventViewController = navigationController.topViewController as EditEventTableViewController
            
            editEventViewController.event = event

        }
    }

}
