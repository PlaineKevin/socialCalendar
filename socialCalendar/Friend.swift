//
//  Friend.swift
//  socialCalendar
//
//  Created by Kevin Nguyen on 12/2/14.
//  Copyright (c) 2014 AIT. All rights reserved.
//

import Foundation
import UIKit

class Friend {
    var username: String = ""
    var realName: String?
    var image: UIImage?
    
    init(username: String, realName: String? = nil, image: UIImage? = nil) {
        self.username = username
        self.realName = realName
        self.image = image
    }
    
    convenience init(dictionary: NSDictionary){
        
        var username = dictionary["username"] as? String
        var realName = dictionary["description"] as? String
        
        assert(username != nil , "the dictionary must have a username")
        
        var imageData = dictionary["image-data"] as? NSData
        var image: UIImage?
        if imageData != nil{
            image = UIImage(data: imageData!)
        }
        
        self.init(username: username!, realName: realName, image: image)
    }
    
//    func toPropertyListObject() -> NSDictionary {
//        
//        var dictionary: NSMutableDictionary = [
//            "username":username,
//            "realName":realName
//        ]
//        
//        if image != nil {
//            // turn an image into a jpeg then the scale for the quality is 0-1
//            dictionary["image-data"] = UIImageJPEGRepresentation(image, 0.7)
//        }
//        return dictionary
//    }
}