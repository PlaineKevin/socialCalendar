//
//  FriendManager.swift
//  socialCalendar
//
//  Created by Kevin Nguyen on 12/2/14.
//  Copyright (c) 2014 AIT. All rights reserved.
//

import Foundation
import UIKit

private let friendManagerInstance = FriendManager()

class FriendManager {
    var friends = [Friend]()
    
    class var sharedFriendManager: FriendManager {
        return friendManagerInstance
    }
    
    init(){}
    
    func filteredRemindersForSearchText(searchText: String) -> [Friend] {
        
        let filteredReminders = friends.filter { (friend: Friend) -> Bool in
            let stringMatch = friend.userName.rangeOfString(searchText, options: .CaseInsensitiveSearch)
            
            return stringMatch != nil
        }
        
        return filteredReminders
        
    }
}
