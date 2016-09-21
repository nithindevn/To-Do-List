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
    let context=DataController.sharedInstance
    @IBOutlet weak var table: UITableView!
    var globalRow:Int!
    var globalObject: NSManagedObject!
    var list=[List]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do{
            try list=context.reloadTableData()
            
        } catch DataController.CoreDataError.RetrievalError {
            print("Retrieval Error")
        }catch{
            print("Other Retrieval Errors")
        }
        table.dataSource = self
        table.delegate = self
        table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

    }
 
    //AddItem delegate methods
    func userEnteredInfo(addToList:Item) {
        do{
            let object = try context.insertData(addToList)
            list.append(object)
            table.reloadData()
        }catch DataController.CoreDataError.InsertError{
            print("Insertion Error")
        }catch{
            print("Other Insertion Errors")
        }
    }
    
    //ViewItemControllerDelegatemethod
    func deleteItem(atIndex: Int ){
        do {
            try context.deleteData(list, index:atIndex)
            list.removeAtIndex(atIndex)
        }catch DataController.CoreDataError.DeleteError{
            print("Deletion Error ")
        }catch{
            print("Other Deletion Errors")
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
        
        let item = self.list[indexPath.row]
        cell.textLabel?.text = item.title
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
}

