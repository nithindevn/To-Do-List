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
    var viewController=ViewController()
    var updatedList: List!
    var activeField: UITextField?
    var activeView:UITextView?
    var updateList=Item()
    var list=[List]()
    var dele: deleteDataDelegate? = nil
    let context=DataController.sharedInstance
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var descField: UITextView!
    @IBOutlet weak var viewToScroll: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
        titleField.delegate=self
        dateField.delegate=self
        descField.delegate=self
        self.title = updatedList.title
        titleField.text = updatedList.title
        descField.text = updatedList.desc
        dateField.text = updatedList.date
        titleField.userInteractionEnabled=false
        dateField.userInteractionEnabled=false
        descField.userInteractionEnabled=false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewItemController.keyboardDidShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewItemController.keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewItemController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        cancelButton.hidden=true
        saveButton.hidden=true
    }
    

    func keyboardDidShow(notification: NSNotification) {
        
        if (self.activeField != nil || self.activeView != nil) {
            let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize!.height, right: 0.0)
            
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        let contentInsets = UIEdgeInsetsZero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField==self.dateField{
            return false
        }
        else{
            return true
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.activeField = nil
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.activeField = textField
        if textField==dateField{
            let datePickerView = UIDatePicker()
            datePickerView.datePickerMode = UIDatePickerMode.Date
            textField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(ViewItemController.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        }
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        self.activeView = textView
        return true
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        self.activeView=nil
    }
    
    //Clicked on Cancel
    @IBAction func cancelClicked(sender:UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //Clicked on Save
    @IBAction func saveClicked(sender: UIButton) {
        
        
        let currentDate=NSDate()
        let dateFormatter=NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        if dateFormatter.dateFromString(dateField.text!)!.timeIntervalSinceReferenceDate < currentDate.timeIntervalSinceReferenceDate {
            let myAlert=UIAlertController(title: "Invalid date", message: "Pick a valid date", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction=UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated: true, completion: nil)
        }
            
        else if checkIfInvalid() {
            let myAlert=UIAlertController(title: "Duplicate title", message: "An item with the same title already exist", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction=UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated: true, completion: nil)

        }
            
        else{
            do{
                try context.updateData(updatedList)
                updatedList.title=titleField.text
                updatedList.desc=descField.text
                updatedList.date=dateField.text
                
            } catch DataController.CoreDataError.UpdateError {
                print("Update Error")
            }catch{
                print("Other Update Errors")
            }
            self.navigationController?.popViewControllerAnimated(true)
            }
        
    }
    //Clicked on Edit
    @IBAction func editClicked(sender: UIButton) {
        titleField.userInteractionEnabled=true
        descField.userInteractionEnabled=true
        dateField.userInteractionEnabled=true
        deleteButton.hidden=true
        editButton.hidden=true
        cancelButton.hidden=false
        saveButton.hidden=false
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
    
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateField.text = dateFormatter.stringFromDate(sender.date)
        
    }
    
    func checkIfInvalid() ->Bool{
        var result:Bool=false
        print(list)
        if  list != [] {
            for item in list{
                if index==list.indexOf(item){
                    continue
                }
                else if titleField.text! == item.title{
                    result=true
                }
            }
        }

        
        return result
    }
}
