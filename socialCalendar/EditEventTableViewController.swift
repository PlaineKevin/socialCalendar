//
//  EditEventTableViewController.swift
//  socialCalendar
//
//  Created by Kevin Nguyen on 12/13/14.
//  Copyright (c) 2014 AIT. All rights reserved.
//

import UIKit

class EditEventTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDate: UIDatePicker!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventEditors: UITextView!
    @IBOutlet weak var eventDetails: UITextView!

    @IBOutlet weak var eventNameTextField: UITextField!
    
    var event: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let initialEvent = self.event {
            eventName.text = initialEvent["name"] as String
            eventDate.date = initialEvent["date"] as NSDate
            eventEditors.text = initialEvent["details"] as String
            eventDetails.text = initialEvent["editors"] as String
            eventNameTextField.text = initialEvent["name"] as String
            
            if eventImage.image != nil {
                let imageObject = initialEvent["image"] as PFFile
                imageObject.getDataInBackgroundWithBlock({
                    (imageData: NSData!, error: NSError!) -> Void in
                    if error == nil {
                        let image = UIImage(data: imageData)
                        self.eventImage.image = image
                    }
                    
                })
            }
        }
        
        eventDate.addTarget(self, action: "datePickerChanged:",forControlEvents: UIControlEvents.ValueChanged)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    @IBAction func cancelButton(sender: AnyObject) {
        println("canceled")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveEvent(sender: AnyObject) {
        if event == nil {
            //    createFriendWithContent(usernameTextField.text, realName: realNameTextField.text, image: imageView.image)
            createEventInParse(eventNameTextField.text, date: eventDate.date, details: eventDetails.text, editors: eventEditors.text, viewers: eventEditors.text, image: eventImage.image)
            
            //            FriendManager.sharedFriendManager.friends.append(friend)
        }
        else {
            //            friend.userName = usernameTextField.text
            //            friend.realName = realNameTextField.text
            //            friend.image = imageView.image
            //            AppDelegate.sharedAppDelegate.saveContext()
            
            updateEventInParse(eventNameTextField.text, date: eventDate.date, details: eventDetails.text, editors: eventEditors.text, viewers: eventEditors.text, image: eventImage.image)
        }
    }
    
    @IBAction func imageTap(sender: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.SavedPhotosAlbum) {
            
            var imagePicker = UIImagePickerController()
            imagePicker.sourceType = .SavedPhotosAlbum
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func handleImageTap(sender: UITapGestureRecognizer) {
        
        if UIImagePickerController.isSourceTypeAvailable(.SavedPhotosAlbum) {
            
            var imagePicker = UIImagePickerController()
            imagePicker.sourceType = .SavedPhotosAlbum
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        eventImage.image = info[UIImagePickerControllerOriginalImage]? as? UIImage
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func datePickerChanged(datePicker:UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        var strDate = dateFormatter.stringFromDate(datePicker.date)
        eventDate.date = datePicker.date
        
    }

    func saveButtonTap() {
        if event == nil {
            createEventInParse(eventNameTextField.text, date: eventDate.date, details: eventDetails.text, editors: eventEditors.text, viewers: eventEditors.text, image: eventImage.image)
        } else {
//            CoreData 
//            event.name = eventName.text
//            event.date = eventDate.date
//            event.image = eventImage
//            .image
//            AppDelegate.sharedAppDelegate.saveContext()

            updateEventInParse(eventName.text!, date: eventDate.date, details: eventDetails.text, editors: eventEditors.text, viewers: eventEditors.text, image: eventImage.image)
        }

    }

    // MARK: - Parse

    func createEventInParse(name: String, date: NSDate, details: String, editors: String?, viewers: String?, image: UIImage?) {
        var addedEvent = PFObject(className: "Event")
        addedEvent["name"] = name
        addedEvent["date"] = date
        addedEvent["details"] = details
        addedEvent["editors"] = editors
        addedEvent["viewers"] = viewers
        addedEvent["user"] = PFUser.currentUser() as PFUser
        if image != nil {
            let imageData = UIImagePNGRepresentation(image)
            let imageFile: PFFile = PFFile(data: imageData)
            addedEvent["image"] = imageFile
        } else {
            var defaultImage = UIImage(named: "eventQuestion")
            let defaultData = UIImagePNGRepresentation(defaultImage)
            let defaultFile: PFFile = PFFile(data: defaultData)
            addedEvent["image"] = defaultFile
            
        }
        
        addedEvent.saveInBackgroundWithBlock {
            success, error in
            if success && error == nil {
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                var errorPopup = UIAlertController(title: "Saving friend failed.", message: error.localizedDescription, preferredStyle: .Alert)
                var okayAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
                errorPopup.addAction(okayAction)
                self.presentViewController(errorPopup, animated: true, completion: nil)
            }
        }

    }

    func updateEventInParse(name: String, date: NSDate, details: String, editors: String?, viewers: String?, image: UIImage?) {
        var query = PFQuery(className: "Event")
        ////            query.fromLocalDatastore()
        // query.fromLocalDatastore()
//        query.findObjectsInBackgroundWithBlock({
//            (objects: [AnyObject]!, error: NSError!) in
            query.findObjectsInBackgroundWithBlock({
                (objects: [AnyObject]!, error: NSError!) in
                if error != nil {
                    print(error)
                } else {
                    for object in objects {
                        var username = object["name"] as String
    //                    println("\(printing)")
    //                    println("name: \(name)")
                        if username == name {
                            query.getObjectInBackgroundWithId(object.objectId, block: {
                                (updated: PFObject!, error: NSError!) -> Void in
                                updated["date"] = date
                                updated["details"] = details
                                updated["editors"] = editors
                                updated["viewers"] = viewers
                                let imageData = UIImagePNGRepresentation(image)
                                let imageFile: PFFile = PFFile(data: imageData)
                                updated["image"] = imageFile
                                
                                updated.saveInBackgroundWithBlock {
                                    success, error in
                                    if success && error == nil {
                                        self.dismissViewControllerAnimated(true, completion: nil)
                                    } else {
                                        var errorPopup = UIAlertController(title: "Updating event failed.", message: error.localizedDescription, preferredStyle: .Alert)
                                        var okayAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
                                        errorPopup.addAction(okayAction)
                                        self.presentViewController(errorPopup, animated: true, completion: nil)
                                    }
                                }
                            })
                        }
                    }
                }
            })
            dismissViewControllerAnimated(true, completion: nil)
//        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        return 0
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
