//  Mikey's Branch commit 2
//  FirstViewController.swift
//  AlertTheHerd
//
//  Created by Michael Delez on 8/18/16.
//  Copyright © 2016 Michael Delez. All rights reserved.
//

//What still needs to be added:
//Select contact and pass data to next view
//Don't allow empty fields
//Check if phone number is 10 digits and put it in this format: (xxx) xxx-xxxx

import UIKit
import CoreData

class ContactsTableViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var contactsTableView: UITableView! //created from storyboard, makes each cell selectable
    
    //Create mutable array for contacts
    var people = [NSManagedObject]() //NSManagedObject represents a single object stored in Core Data—you must use it to create, edit, save and delete from your Core Data persistent store
    
    @IBAction func createContact(sender: AnyObject) { //created from storyboard, pops up "Add Contact" window when you click the "Add" button on the top left
        
        //set up alert message and style as a pop up alert
        let alert = UIAlertController(title: "Add Contact", message: "", preferredStyle: .Alert)
        
        //creates a "save" button
        let saveAction = UIAlertAction(title: "Save", style: .Default, handler: { (action:UIAlertAction) -> Void in
            
            //grab the input from each field
            let nameTextField = alert.textFields![0] as UITextField
            let numberTextField = alert.textFields![1] as UITextField
            
            //send the input to validateContact()
            let name = nameTextField.text!
            let number = numberTextField.text!
            if self.validateContact(name, number: number){
                //if info is validated, send to saveContact()
                self.saveContact(name, number: number)
            }
            else{
                //if info is incorrect, pop up the alert again
                //let alert = UIAlertController(title: "Add Contact", message: "Incorrect Informantion Provided", preferredStyle: .Alert)
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            //reload the list so new addition shows up
            self.contactsTableView.reloadData()
        })
        
        //creates a "cancel" button. Alert is dismissed if clicked
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        //this allows you to make an input field within the alert
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
            
            //grey placeholder text
            textField.placeholder = "Full Name"
            //turn off autocorrect
            textField.autocorrectionType = .No
        
        }
        
        //we need two fields so we must make two of these
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
            
            //THIS WILL CAUSE A WARNING MESSAGE IN THE DEBUG CONSOLE. Just ignore it :)
            textField.keyboardType = UIKeyboardType.NumberPad
            //grey placeholder text
            textField.placeholder = "Phone Number"
            
        }

        //incorporate the buttons you created into the alert message
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        //present the alert to the user
        presentViewController(alert, animated: true, completion: nil)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.title = "Contacts"
    }
    
    //checks if information entered is valid
    func validateContact(name: String, number: String) -> Bool{
        //checks for empty name
        if name == ""{
            print("No name entered")
            return false
        }
        
        //checks if phone number is 10 digits long
        let number_regex = "\\d{10}"
        let numberTest = NSPredicate(format: "SELF MATCHES %@", number_regex)
        let result = numberTest.evaluateWithObject(number)
        if result == true{
            print("This is a valid number")
            return true
        }
        else{
            print("This is not a valid number")
            return false
        }
    }
    
    func saveContact(name: String, number: String){
        
        //get shared instance of app delegate and the Managed Object Context
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //select the correct Entity from the data model
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: managedContext)
        
        let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        //set values that were given as input to the function
        person.setValue(name, forKey: "name")
        person.setValue(number, forKey: "phoneNumber")
        
        //print most recently saved person to the debug console
        print("\(person)")
        
        //try to save the context and append the new contact to the array
        do{
            try managedContext.save()
            people.append(person)
        }
        //catch if error and grab the error number and info
        catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func updateContact(index: Int, newName: String, newNumber: String){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.saveContext()
    }
    
    
    // Simply checks how many people are in the array so it knows how many rows to make
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    //This function grabs the correct info from the Person object
    //THIS DOES NOT DISPLAY THE INFO
    //That is handled by viewWillAppear
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        let person = people[indexPath.row]
        cell!.textLabel?.text = person.valueForKey("name") as? String //main text of label (name)
        cell!.detailTextLabel?.text = person.valueForKey("phoneNumber") as? String //subtitle text of label (phone number)
        return cell!
    }
    
    //This function handles the multiple editing styles lists can have
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{ //check if editing style is "Delete"
            
            //get shared instance of app delegate and the Managed Object Context
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            
            //delete the object and save the context
            managedContext.deleteObject(people[indexPath.row])
            appDelegate.saveContext()
            
            //remove object from people array so it doesn't appear in the list anymore
            people.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let alert = UIAlertController(title: "Update", message: "Update stuff", preferredStyle: .Alert)
        
        let updateAction = UIAlertAction(title: "Update", style: .Default){(_) in
            let nameTextField = alert.textFields![0]
            let numberTextField = alert.textFields![1]
            self.updateContact(indexPath.row, newName: nameTextField.text!, newNumber: numberTextField.text!)
            tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler(nil)
        alert.addTextFieldWithConfigurationHandler(nil)
        
        alert.addAction(updateAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //This function retrieves the data from the Person object in order to display it in the list
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //get shared instance of app delegate and the Managed Object Context
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //create fetch request
        let fetchRequest = NSFetchRequest(entityName: "Person")
        
        //try to fetch results
        do{
            let results = try managedContext.executeFetchRequest(fetchRequest)
            people = results as! [NSManagedObject]
        }
        
        //catch if error and grab the error number and info
        catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

}

