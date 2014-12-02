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
    
    init(username: String, realName: String?) {
        self.username = username
        if let real = realName {
            self.realName = real
        }
    }
}