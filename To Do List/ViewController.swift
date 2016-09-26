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
            
        } catch DataController.CoreDataError.retrievalError {
            print("Retrieval Error")
        }catch{
            print("Other Retrieval Errors")
        }
        table.dataSource = self
        table.delegate = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.table.reloadData()
    }
 
    //AddItem delegate methods
    func userEnteredInfo(_ addToList:Item) {
        do{
            let object = try context.insertData(addToList)
            list.append(object)
            table.reloadData()
        }catch DataController.CoreDataError.insertError{
            print("Insertion Error")
        }catch{
            print("Other Insertion Errors")
        }
    }
    
    //ViewItemControllerDelegatemethods
    func deleteItem(_ atIndex: Int ){
        do {
            try context.deleteData(list, index:atIndex)
            list.remove(at: atIndex)
        }catch DataController.CoreDataError.deleteError{
            print("Deletion Error ")
        }catch{
            print("Other Deletion Errors")
        }
        table.reloadData()
    }
    

    
    //UITableviewDelegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                               for: indexPath)
        
        let item = self.list[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = item.title
        cell.backgroundColor = UIColor.orange
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = (indexPath as NSIndexPath).row
        globalRow = row
        self.performSegue(withIdentifier: "viewitem", sender: nil);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Segue to AddItem
        if segue.identifier == "showAddItem" {
            let destination:AddItem = segue.destination as! AddItem
            destination.delegate = self
            destination.list=list
        }
        
        //Segue to viewItem
        if  segue.identifier == "viewitem" {
            let destination: ViewItemController = segue.destination as! ViewItemController
            destination.dele=self
            //destination.data = globalObject
            destination.index = globalRow
            destination.updatedList=list[globalRow]
            destination.list=list
            
        }
    }
    
}

