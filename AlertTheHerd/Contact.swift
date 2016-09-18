//
//  PhoneNumber.swift
//  AlertTheHerd
//
//  Created by Michael Delez on 8/19/16.
//  Copyright © 2016 Michael Delez. All rights reserved.
//

import UIKit

class Contact: NSObject {
    var name: AnyObject
    var phoneNumber: AnyObject
    
    init(name: AnyObject, phoneNumber: AnyObject) {
        self.name = name
        self.phoneNumber = phoneNumber
        super.init()
    }
}
