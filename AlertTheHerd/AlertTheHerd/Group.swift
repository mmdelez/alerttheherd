//
//  Group.swift
//  AlertTheHerd
//
//  Created by Michael Delez on 8/19/16.
//  Copyright © 2016 Michael Delez. All rights reserved.
//

import UIKit

class Group: NSObject {
    var groupName: AnyObject
    var groupMembers: [AnyObject]
    
    init(groupName: AnyObject, groupMembers: AnyObject) {
        self.groupName = groupName
        self.groupMembers = groupMembers as! [AnyObject]
        super.init()
    }
}
