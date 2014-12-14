//
//  Event.swift
//  socialCalendar
//
//  Created by Miles Crabill on 12/13/14.
//  Copyright (c) 2014 AIT. All rights reserved.
//

import Foundation

class Event {
    var name: String!
}

//class Event : PFObject, PFSubclassing {
//    @NSManaged var name: String!
//    @NSManaged var date: NSDate!
//    @NSManaged var details: String!
//    @NSManaged var editors: [String]!
//    @NSManaged var viewers: [String]!
//
//    var displayName: String {
//        get {
//            return objectForKey("displayName") as String
//        }
//        set {
//            setObject(newValue, forKey: "displayName")
//        }
//    }
//
//    override class func load() {
//        registerSubclass()
//    }
//
//    class func parseClassName() -> String! {
//        return "Event"
//    }
//}