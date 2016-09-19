//
//  DataController.swift
//  To Do List
//
//  Created by qburst on 12/09/16.
//  Copyright © 2016 qburst. All rights reserved.
//

import UIKit
import CoreData
class DataController: NSObject {
    private var managedObjectContext: NSManagedObjectContext
    
    enum CoreDataError: ErrorType {
        case RetrievalError
        case InsertError
        case DeleteError
    }
    
    override init() {
        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = NSBundle.mainBundle().URLForResource("To_Do_List", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOfURL: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = psc
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
            let docURL = urls[urls.endIndex-1]
            /* The directory the application uses to store the Core Data store file.
             This code uses a file named "DataModel.sqlite" in the application's documents directory.
             */
            let storeURL = docURL.URLByAppendingPathComponent("To_Do_List.sqlite")
            do {
                try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }
    }
    
    //Populate Table at Launch
    func reloadTableData() throws -> [List]{
        
        let fetchRequest = NSFetchRequest(entityName: "List")
        let results =   try? self.managedObjectContext.executeFetchRequest(fetchRequest)
        guard  results != nil  else{
            throw CoreDataError.RetrievalError
            
        
        }
        return results as! [List]
            
        
        }
    //Insert into CoreData
    func insertData(addToList:Item) throws -> List{
        let entity =  NSEntityDescription.entityForName("List",inManagedObjectContext:self.managedObjectContext)
        
        let object = NSManagedObject(entity: entity!,insertIntoManagedObjectContext: self.managedObjectContext)
        
        object.setValue(addToList.title, forKey: "title")
        object.setValue(addToList.desc, forKey: "desc")
        object.setValue(addToList.date, forKey: "date")
        
        let result=try? self.managedObjectContext.save()
        guard result != nil else{
            throw CoreDataError.InsertError
        }
        return object as! List
        
    }
    
    func deleteData(list:[List], index: Int) throws {
        self.managedObjectContext.deleteObject(list[index] as NSManagedObject)
        let result=try? self.managedObjectContext.save()
        guard result != nil else{
            throw CoreDataError.DeleteError
        }
    }
}
    
    
