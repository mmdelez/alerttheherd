//
//  TemplatesTableViewController.swift
//  AlertTheHerd
//
//  Created by Michael Delez on 8/19/16.
//  Copyright © 2016 Michael Delez. All rights reserved.
//

import UIKit
import Coredata

class TemplatesTableViewController: UIViewController, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.title = "Templates"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
