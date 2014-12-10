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
    
    var friend: Friend!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var realNameTextField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let initialFriend = self.friend {
            imageView.image = initialFriend.image
            usernameTextField.text = initialFriend.userName
            realNameTextField.text = initialFriend.realName
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
            
            createFriendWithContent(usernameTextField.text, realName: realNameTextField.text, image: imageView.image)
            
//            FriendManager.sharedFriendManager.friends.append(friend)
        }
        else {
            friend.userName = usernameTextField.text
            friend.realName = realNameTextField.text
            friend.image = imageView.image
            AppDelegate.sharedAppDelegate.saveContext()
            
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
    

    

}
