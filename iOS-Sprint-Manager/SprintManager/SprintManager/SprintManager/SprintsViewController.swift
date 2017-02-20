//
//  SprintsViewController.swift
//  SprintManager
//
//  Created by Kutkoski, Joseph Anthony on 12/3/16.
//  Copyright © 2016 A290 Fall 2016 - jakutkos, sylyon. All rights reserved.
//

import UIKit
import CoreData
import EventKit

class SprintsViewController: UITableViewController {
    var appDelegate: AppDelegate? = nil
    var managedContext: NSManagedObjectContext? = nil
    var mySprintModel: SprintModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // ADD NAVIGATION BUTTONS
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add,
                                        target: self,
                                        action: #selector(addButtonPressed(_:)))
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        self.navigationItem.rightBarButtonItem = addButton
        
        // FETCH SPRINTS
        self.appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        self.mySprintModel = self.appDelegate?.mySprintModel
        self.mySprintModel!.fetchEntities("Sprint")
    }

    func addButtonPressed(sender: AnyObject) {
        displayAddAlert()
    }
    
    func displayAddAlert() {
        let alertController = UIAlertController(title: "Add Sprint",
                                                message: "Details will be entered into Calendar",
                                                preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive,
            handler: {
                (action: UIAlertAction) -> Void in
                // do nothing when Cancel is pressed
            }
        )
        
        let addAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default,
            handler: {
                (action: UIAlertAction) -> Void in
                let inputTitle = alertController.textFields![0].text
                let inputStartDate = alertController.textFields![1].text
                let inputEndDate = alertController.textFields![2].text
                let inputUserStories = alertController.textFields![3].text
                
                let startIsValid = self.dateIsValid(inputStartDate!)
                let endIsValid = self.dateIsValid(inputEndDate!)
                
                if (startIsValid && endIsValid) {
                    let eventStore = self.appDelegate?.myEventStore
                    self.mySprintModel!.addSprint(inputTitle!, startDate: inputStartDate!, endDate: inputEndDate!, userStories: inputUserStories!)
                
                    eventStore!.requestAccessToEntityType(EKEntityType.Event, completion: {
                        (granted, error) in
                    
                        if (granted) && (error == nil) {
                            let event : EKEvent = EKEvent(eventStore: eventStore!)
                            event.title = inputTitle!
                            event.notes = inputUserStories
                            let formatter = NSDateFormatter()
                            let fullStartDate = inputStartDate! + " 00:00:00 +0000"
                            let fullEndDate = inputEndDate! + " 00:00:00 +0000"
                            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                            event.startDate = formatter.dateFromString(fullStartDate)!
                            event.endDate = formatter.dateFromString(fullEndDate)!
                            event.calendar = (eventStore?.defaultCalendarForNewEvents)!
                        
                            do {
                                try eventStore!.saveEvent(event, span: EKSpan.ThisEvent)
                            } catch _ as NSError {
                                return
                            }
                        }
                    })
                } else {
                    let failAlert = UIAlertController(title: "Failed to add sprint.",
                                                      message: "Check formatting of start and end dates.",
                                                      preferredStyle: UIAlertControllerStyle.Alert)
                    let failCancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive,
                        handler: {
                            (action: UIAlertAction) -> Void in
                            // do nothing when Cancel is pressed
                        }
                    )
                    
                    failAlert.addAction(failCancelAction)
                    self.presentViewController(failAlert, animated: true, completion: nil)
                }
                
                self.tableView.reloadData()
            }
        )
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        alertController.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
            textField.placeholder = "Enter a title"
        }
        
        alertController.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
            textField.placeholder = "Start Date: yyyy-MM-dd"
        }
        
        alertController.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
            textField.placeholder = "End Date: yyyy-MM-dd"
        }
        
        alertController.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
            textField.placeholder = "Enter user stories"
        }
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func dateIsValid(dateStr: String) -> Bool {
        let fullDateStr = dateStr + " 00:00:00 +0000"
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        if (formatter.dateFromString(fullDateStr) != nil) {
            if (Int(NSString(string: dateStr).substringToIndex(4))! < 1950) {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }

    // TABLE VIEW FUNCTIONS ///////////////////////////////
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.mySprintModel?.sprints.count)!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SprintCell", forIndexPath: indexPath)
        let spr = self.mySprintModel?.sprints[indexPath.row]
        let sprTitle = spr?.valueForKey("title")
        let sprStartDate = spr?.valueForKey("startDate")
        let sprEndDate = spr?.valueForKey("endDate")
        let sprUserStories = spr?.valueForKey("userStories")
        
        let title = "\(sprTitle!) [\(sprStartDate!) to \(sprEndDate!)]"
        let detail = "\(sprUserStories!)"
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = detail
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func tableView(tableView: UITableView,
                            commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                            forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.mySprintModel!.deleteSprint(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    //////////////////////////////////////////////////
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

