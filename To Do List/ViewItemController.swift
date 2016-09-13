//
//  viewItem.swift
//  To Do List
//
//  Created by qburst on 01/09/16.
//  Copyright © 2016 qburst. All rights reserved.
//

import UIKit
import CoreData
protocol deleteDataDelegate{
    func deleteItem(atIndex: Int)
}
class ViewItemController: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    var index: Int!
    var viewTitle:String!
    var viewDesc:String!
    var viewDate:String!
    
    var list=[NSManagedObject]()
    var dele: deleteDataDelegate? = nil
    @IBOutlet weak var viewItemTitle: UITextField!
    @IBOutlet weak var viewItemDate: UITextField!
    @IBOutlet weak var viewItemDesc: UITextView!
    
    
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        viewItemTitle.delegate=self
        viewItemDate.delegate=self
        viewItemDesc.delegate=self
        
        self.title = viewTitle
        viewItemTitle.text = viewTitle
        viewItemDesc.text = viewDesc
        viewItemDate.text = viewDate
        
    }
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return false
    }
    
    
    
    //Clicked on Delete
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

    
}
