//
//  AddItem.swift
//  To Do List
//
//  Created by qburst on 30/08/16.
//  Copyright © 2016 qburst. All rights reserved.
//

import UIKit

protocol dataEnteredDelegate{

    func userEnteredInfo(infotitle: NSString, infoDesc: NSString, infoDate: NSString)
}

class AddItem: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descField: UITextView!
    @IBOutlet weak var dateField: UITextField!
    var delegate:dataEnteredDelegate?=nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    
    
    //Clicked on Save
    @IBAction func clickedOnSave(sender: AnyObject) {
        var itemTitle, itemDesc, itemDate : String
        itemTitle = titleField.text!
        itemDesc = descField.text!
        itemDate = dateField.text!
        if (delegate != nil){
        
            delegate!.userEnteredInfo(itemTitle, infoDesc: itemDesc, infoDate: itemDate)
            //let nav = self.navigationController!;
            //let controller = nav.viewControllers[0] as! ViewController;
            //controller.toDoItems.append(ToDoItem(text: itemTitle as String))
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        
    }
    
    
    //Clicked on Cancel
    @IBAction func clickedOnCancel(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
        @IBAction func editingText(sender: UITextField) {
            
            let datePickerView:UIDatePicker = UIDatePicker()
            
            datePickerView.datePickerMode = UIDatePickerMode.Date
            
            sender.inputView = datePickerView
            
            datePickerView.addTarget(self, action: #selector(AddItem.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
    }

    
    func datePickerValueChanged(sender:UIDatePicker) {
    
    let dateFormatter = NSDateFormatter()
    
    dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
    
    dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
    
    dateField.text = dateFormatter.stringFromDate(sender.date)
    
    }



}