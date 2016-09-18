//
//  Template.swift
//  AlertTheHerd
//
//  Created by Michael Delez on 8/19/16.
//  Copyright © 2016 Michael Delez. All rights reserved.
//

import UIKit

class Templates: NSObject{
    var templateName: AnyObject
    var templateMessage: AnyObject
    
    init(templateName: AnyObject, templateMessage: AnyObject) {
        self.templateName = templateName
        self.templateMessage = templateMessage
        super.init()
    }
}
