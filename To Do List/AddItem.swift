//
//  AddItem.swift
//  To Do List
//
//  Created by qburst on 30/08/16.
//  Copyright © 2016 qburst. All rights reserved.
//

import UIKit

protocol dataEnteredDelegate{

    func userEnteredInfo(addToList:Item)
}

class AddItem: UIViewController,UITextFieldDelegate,UITextViewDelegate{
    var activeField: UITextField?
    var activeView:UITextView?
    @IBOutlet weak var titleField: UITextView!
    @IBOutlet weak var descField: UITextView!
    @IBOutlet weak var dateField: UITextField!
    var delegate:dataEnteredDelegate?=nil
    var addToList=Item()
    @IBOutlet weak var viewToScroll: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    var list=[List]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
        titleField.delegate=self
        descField.delegate=self
        dateField.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddItem.keyboardDidShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddItem.keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddItem.dismissKeyboard))
        view.addGestureRecognizer(tap)
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

    //UITextFieldDelegate method-->calls whenever the current text changes
    //To disable the textField
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
            datePickerView.addTarget(self, action: #selector(AddItem.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        }
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        self.activeView = textView
        return true
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        self.activeView=nil
    }
    
    //Clicked on Save
    @IBAction func clickedOnSave(sender: AnyObject) {
        let currentDate=NSDate()
        let dateFormatter=NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        if titleField.text == "" {
            let myAlert = UIAlertController(title: "Warning", message: "Title can't be empty", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
            {(action) in
                self.view.endEditing(true)
            }
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated: true, completion: nil)
            
        }
                else if dateField.text == "" {
            let myAlert = UIAlertController(title: "Warning", message: "Date can't be empty", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
            {(action) in
                self.view.endEditing(true)
            }
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated: true, completion: nil)
        }
            
        else if dateFormatter.dateFromString(dateField.text!)!.timeIntervalSinceReferenceDate < currentDate.timeIntervalSinceReferenceDate {
            let myAlert=UIAlertController(title: "Invalid date", message: "Pick a valid date", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction=UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated: true, completion: nil)
        }
        else if checkIfInvalid(){
            let myAlert=UIAlertController(title: "Duplicate title", message: "An item with the same title already exist", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction=UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated: true, completion: nil)
        }

        else {
            addToList.title = titleField.text!
            addToList.desc = descField.text!
            addToList.date = dateField.text!
            if (delegate != nil){
                delegate!.userEnteredInfo(addToList)
                self.navigationController?.popViewControllerAnimated(true)
        
            }
        }
    }
    
    //Clicked on Cancel
    @IBAction func clickedOnCancel(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateField.text = dateFormatter.stringFromDate(sender.date)
    
    }
    
    func checkIfInvalid() ->Bool{
        var result:Bool=false
        print(list)
        if list != []{
            for item in list{
                if titleField.text! == item.title! {
                    result=true
                }
            }
        }

        
        return result
    }
}