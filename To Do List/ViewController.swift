//
//  ViewController.swift
//  To Do List
//
//  Created by qburst on 30/08/16.
//  Copyright © 2016 qburst. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, dataEnteredDelegate, deleteDataDelegate {

    let managedContext = DataController().managedObjectContext
    @IBOutlet weak var table: UITableView!
    var globalRow:Int!
    var globalObject: NSManagedObject!
    var list=[NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
       
       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        reloadData()
    }
    
    
    //AddItem delegate methods
    func userEnteredInfo(infotitle: NSString, infoDesc: NSString, infoDate: NSString) {
        
        let entity =  NSEntityDescription.entityForName("List",inManagedObjectContext:managedContext)
        
        let object = NSManagedObject(entity: entity!,insertIntoManagedObjectContext: managedContext)
    
        object.setValue(infotitle as String, forKey: "title")
        object.setValue(infoDesc as String, forKey: "desc")
        object.setValue(infoDate as String, forKey: "date")
        
        do {
            try managedContext.save()
            list.append(object)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        table.reloadData()
        
        
        }
    
   
    
    //ViewItemControllerDelegatemethod
    func deleteItem(atIndex: Int ){

        managedContext.deleteObject(list[atIndex] as NSManagedObject)
        
        do {
            try managedContext.save()
            list.removeAtIndex(atIndex)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }

        
        
        table.reloadData()
    }
    
    
    //UITableviewDelegate methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(tableView: UITableView,
                   cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell",
                                                               forIndexPath: indexPath)
        let item = list[indexPath.row]
        cell.textLabel?.text = item.valueForKey("title") as? String
        cell.backgroundColor = UIColor.orangeColor()
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
                   forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let row = indexPath.row
        globalRow = row
        self.performSegueWithIdentifier("viewitem", sender: nil);
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //Segue to AddItem
        if segue.identifier == "showAddItem" {
            let destination:AddItem = segue.destinationViewController as! AddItem
            destination.delegate = self
            
        }
        
        
        //Segue to viewItem
        if  segue.identifier == "viewitem" {
            
            let destination: ViewItemController = segue.destinationViewController as! ViewItemController
            destination.dele=self
            //destination.data = globalObject
            destination.index = globalRow
            destination.viewTitle=String(list[globalRow].valueForKey("title")!)
            destination.viewDesc=String(list[globalRow].valueForKey("desc")!)
            destination.viewDate=String(list[globalRow].valueForKey("date")!)
            
        }
    }
    
    
    
    func reloadData(){

        let fetchRequest = NSFetchRequest(entityName: "List")
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            list = results as! [NSManagedObject]
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

    
    
    
    }
   
        

    
}

