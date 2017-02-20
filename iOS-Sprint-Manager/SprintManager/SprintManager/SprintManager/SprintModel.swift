//
//  SprintModel.swift
//  SprintManager
//
//  Created by Kutkoski, Joseph Anthony on 12/3/16.
//  Copyright © 2016 A290 Fall 2016 - jakutkos, sylyon. All rights reserved.
//

import UIKit
import CoreData

class SprintModel: NSObject {
    
    var appDelegate: AppDelegate? = nil
    var managedContext: NSManagedObjectContext? = nil
    var sprints = [NSManagedObject]()
    
    override init() {
        self.appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        self.managedContext = self.appDelegate?.managedObjectContext

        let lFetchRequest = NSFetchRequest(entityName: "Sprint")
        do {
            let lArrayOfObjects = try self.managedContext!.executeFetchRequest(lFetchRequest)
            self.sprints = lArrayOfObjects as! [NSManagedObject]
        } catch let lError as NSError {
            NSLog("Core Data fetching error: \(lError), \(lError.userInfo)")
        }
    }
    
    func addSprint(title: String, startDate: String, endDate: String, userStories: String) {
        let lEntityDescription =  NSEntityDescription.entityForName("Sprint", inManagedObjectContext: self.managedContext!)
        let lSprint = NSManagedObject(entity: lEntityDescription!, insertIntoManagedObjectContext: self.managedContext)
        
        lSprint.setValue(title, forKey: "title")
        lSprint.setValue(startDate, forKey: "startDate")
        lSprint.setValue(endDate, forKey: "endDate")
        lSprint.setValue(userStories, forKey: "userStories")
        
        do {
            try self.managedContext!.save()
            self.sprints.append(lSprint)
        } catch let lError as NSError  {
            NSLog("Error saving to Core Data: \(lError), \(lError.userInfo)")
        }
        
    }
    
    func deleteSprint(location: Int) {
        managedContext?.deleteObject(self.sprints[location] as NSManagedObject)
        self.sprints.removeAtIndex(location)
    }
    
    func fetchEntities(pEntityName: String) {
        let lFetchRequest = NSFetchRequest(entityName: pEntityName)
        
        do {
            let lArrayOfObjects = try self.managedContext!.executeFetchRequest(lFetchRequest)
            self.sprints = lArrayOfObjects as! [NSManagedObject]
        } catch let lError as NSError {
            NSLog("Error fetching from Core Data: \(lError), \(lError.userInfo)")
        }
    }
    
    
}