//
//  ViewController.swift
//  To Do List
//
//  Created by qburst on 30/08/16.
//  Copyright © 2016 qburst. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, dataEnteredDelegate, deleteDataDelegate {

    @IBOutlet weak var table: UITableView!
    var toDoItems = [ToDoItem]()
    var addItem = AddItem()
    var globalRow:Int!
    var globalData: ToDoItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
        table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
       
        if toDoItems.count > 0 {
            return
        }
        
       
       
    }
    override func viewWillAppear(animated: Bool) {
        //super.viewDidAppear(animated)
        //table.reloadData()
    }
    //AddItem delegate methods
    func userEnteredInfo(infotitle: NSString, infoDesc: NSString, infoDate: NSString) {
        toDoItems.append(ToDoItem(text: infotitle as String, desc: infoDesc as String, date: infoDate as String))
        
        table.reloadData()
        
        
        
    }
    
    //ViewItemControllerDelegatemethod
    func deleteItem(atIndex: Int ){
        toDoItems.removeAtIndex(atIndex)
        table.reloadData()
    }
    
    //UITableviewDelegate methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    func tableView(tableView: UITableView,
                   cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell",
                                                               forIndexPath: indexPath)
        let item = toDoItems[indexPath.row]
        cell.textLabel?.text = item.text
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
        globalData = toDoItems[row]
        
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
            destination.data = globalData
            destination.index = globalRow
            
        }
    }
    
    
   
        

    
}

