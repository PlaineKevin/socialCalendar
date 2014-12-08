//
//  Friend.swift
//  socialCalendar
//
//  Created by Kevin Nguyen on 12/2/14.
//  Copyright (c) 2014 AIT. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Friend: NSManagedObject {
    
    @NSManaged var userName: String
    @NSManaged var realName: String?
    @NSManaged var image: UIImage?
    
}