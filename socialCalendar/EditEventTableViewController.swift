//
//  EditEventTableViewController.swift
//  socialCalendar
//
//  Created by Miles Crabill on 12/13/14.
//  Copyright (c) 2014 AIT. All rights reserved.
//

import UIKit

class EditEventTableViewController: UITableViewController {

    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDate: UIDatePicker!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventEditors: UITextView!


    var event: Event!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let initialEvent = self.event {
            eventName.text = initialEvent.name
            eventDate.date = initialEvent.date
        }

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Done, target: self, action: "saveButtonTap")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func saveButtonTap() {
        if event == nil {
            createEventInParse(eventName.text, eventDate.date, eventDetails, eventEditors, eventEditors, image)
        } else {
//            CoreData 
//            event.name = eventName.text
//            event.date = eventDate.date
//            event.image = eventImage
//            .image
//            AppDelegate.sharedAppDelegate.saveContext()

            updateEventInParse(usernameTextField.text, realName: realNameTextField.text, image: imageView.image)
        }

        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Parse

    func createEventInParse(name: String, date: NSDate, details: NSString, editors: [String]?, viewers: [String]?, image: UIImage?) {
        var event: Event
        event.name = name
        event.date = date
        event.details = details

        if editors != nil {
            event.editors = editors!
            event.editors.append(PFUser.currentUser().username)
        }

    }

    func updateEventInParse(username: String, realName: String?, image: UIImage?) {
        var query = PFQuery(className: "Event")
        ////            query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock({
            (objects: [AnyObject]!, error: NSError!) -> Void in

            for object in objects {
                if object["username"] as String == username {
                    query.getObjectInBackgroundWithId(object.objectId, block: {
                        (user: PFObject!, error: NSError!) -> Void in
                        user["realName"] = realName
                        user.saveInBackgroundWithBlock(nil)
                    })
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
