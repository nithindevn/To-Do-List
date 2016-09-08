//
//  viewItem.swift
//  To Do List
//
//  Created by qburst on 01/09/16.
//  Copyright © 2016 qburst. All rights reserved.
//

import UIKit
protocol deleteDataDelegate{
    func deleteItem(atIndex: Int)
}
class ViewItemController: UIViewController {
    var index: Int!
    var data: ToDoItem!
    var dele: deleteDataDelegate? = nil
    @IBOutlet weak var viewItemTitle: UITextField!
    @IBOutlet weak var viewItemDate: UITextField!
    @IBOutlet weak var viewItemDesc: UITextView!
    
    @IBAction func deleteClicked(sender: AnyObject) {
        let myAlert = UIAlertController(title: "Are you sure?", message: "This will permanently delete the item", preferredStyle: UIAlertControllerStyle.Alert)
        let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive)
        {(action) in
            
            if self.dele != nil {
                self.dele!.deleteItem(self.index)
                self.navigationController?.popViewControllerAnimated(true)
                
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        
        
        myAlert.addAction(deleteAction)
        myAlert.addAction(cancelAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
        
        
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = data.text
        viewItemTitle.text = data.text
        viewItemDesc.text = data.desc
        viewItemDate.text = data.date
        
    }
    
}
