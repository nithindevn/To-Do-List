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
    fileprivate  var managedObjectContext: NSManagedObjectContext
    enum CoreDataError: Error {
        case retrievalError
        case insertError
        case deleteError
        case updateError
    }
    static let sharedInstance=DataController()
    
    override init() {
        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = Bundle.main.url(forResource: "To_Do_List", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = psc
        DispatchQueue.global().async {
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let docURL = urls[urls.endIndex-1]
            /* The directory the application uses to store the Core Data store file.
             This code uses a file named "DataModel.sqlite" in the application's documents directory.
             */
            let storeURL = docURL.appendingPathComponent("To_Do_List.sqlite")
            do {
                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }
    }
    
    //Populate Table at Launch
    func reloadTableData() throws -> [List]{
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName:"List")
        //let fetchRequest = NSFetchRequest(entityName: "List")
        let results =   try? self.managedObjectContext.fetch(fetchRequest)
        guard  results != nil  else{
            throw CoreDataError.retrievalError
            
        
        }
        return results as! [List]
    }
    //Insert into CoreData
    func insertData(_ addToList:Item) throws -> List{
        let entity =  NSEntityDescription.entity(forEntityName: "List",in:self.managedObjectContext)
        
        let object = NSManagedObject(entity: entity!,insertInto: self.managedObjectContext) as! List
        
        
        
        //object.setValue(addToList.title, forKey: "title")
        //object.setValue(addToList.desc, forKey: "desc")
        //object.setValue(addToList.date, forKey: "date")
        
        object.title = addToList.title
        object.desc = addToList.desc
        object.date = addToList.date
        
        let result=try? self.managedObjectContext.save()
        
        

        guard result != nil else{
            throw CoreDataError.insertError
        }
        return object
        
    }
    
    //Delete item
    func deleteData(_ list:[List], index: Int) throws {
        self.managedObjectContext.delete(list[index] as NSManagedObject)
        let result=try? self.managedObjectContext.save()
        guard result != nil else{
            throw CoreDataError.deleteError
        }
    }
    
    //Update Item
    func updateData(_ list:List) throws  {

        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName:"List")
        //let fetchRequest = NSFetchRequest(entityName: "List")
        fetchRequest.fetchLimit = 1
        
        let title = list.title as String!
        fetchRequest.predicate = NSPredicate(format: "title == %@",title!)
        var objects: List
        
        do {
            objects = try self.managedObjectContext.fetch(fetchRequest)[0] as! List
            
            objects.title=list.title
            objects.desc=list.desc
            objects.date=list.date
            
            let result=try? self.managedObjectContext.save()
            guard result != nil else{
                throw CoreDataError.updateError
            }
        }
      
    }
}
    
    
