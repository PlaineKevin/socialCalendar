//
//  EditFriendsTableViewController.swift
//  socialCalendar
//
//  Created by Kevin Nguyen on 12/2/14.
//  Copyright (c) 2014 AIT. All rights reserved.
//

import UIKit
import MessageUI
import CoreData

class EditFriendsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var friendList = FriendManager.sharedFriendManager.friends
    
    var friend: PFObject!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var realNameTextField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    

    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as UITableViewHeaderFooterView
//        headerView.textLabel.
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let initialFriend = self.friend {
//            imageView.image = initialFriend.image
            usernameTextField.text = initialFriend["username"] as String
            realNameTextField.text = initialFriend["realName"] as String?
        }
    }

    @IBAction func cancelButtonTap(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
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
        
        imageView.image = info[UIImagePickerControllerOriginalImage]? as? UIImage
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Core Data
    
    @IBAction func saveButtonTap(sender: AnyObject) {
        if friend == nil {
            
//            createFriendWithContent(usernameTextField.text, realName: realNameTextField.text, image: imageView.image)
            createFriendInParse(usernameTextField.text, realName: realNameTextField.text, image: imageView.image)

//            FriendManager.sharedFriendManager.friends.append(friend)
        }
        else {
//            friend.userName = usernameTextField.text
//            friend.realName = realNameTextField.text
//            friend.image = imageView.image
//            AppDelegate.sharedAppDelegate.saveContext()
            
            updateFriendInParse(usernameTextField.text, realName: realNameTextField.text, image: imageView.image)
            
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func createFriendWithContent(username: String, realName: String?, image: UIImage?) {
        let managedObjectContext = AppDelegate.sharedAppDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Friend", inManagedObjectContext: managedObjectContext)
        
        var newFriend = Friend(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        
        newFriend.setValue(username, forKey: "userName")
        newFriend.realName = realName
        newFriend.image = image
        
        friendList.append(newFriend)
        
        AppDelegate.sharedAppDelegate.saveContext()
    }
    
    // MARK: - Parse

    
        func createFriendInParse(username: String, realName: String?, image: UIImage?) {
            var addedFriend = PFObject(className: "Friend")
            addedFriend["username"] = username
            addedFriend["realName"] = realName
            if image != nil {
                let imageData = UIImagePNGRepresentation(image)
                let imageFile: PFFile = PFFile(data: imageData)
                addedFriend["image"] = imageFile
            } else {
                var defaultImage = UIImage(named: "unknownPerson")
                let defaultData = UIImagePNGRepresentation(defaultImage)
                let defaultFile: PFFile = PFFile(data: defaultData)
                addedFriend["image"] = defaultFile
                
            }
            
    
            addedFriend.saveInBackgroundWithBlock(nil)
    
        }
    
        func updateFriendInParse(username: String, realName: String?, image: UIImage?) {
            var query = PFQuery(className: "Friend")
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


    

}
