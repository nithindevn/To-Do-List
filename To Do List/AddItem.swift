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

class AddItem: UIViewController,UITextFieldDelegate,UITextViewDelegate{
    weak var activeField: UITextField?
    weak var activeView:UITextView?
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descField: UITextView!
    @IBOutlet weak var dateField: UITextField!
    var delegate:dataEnteredDelegate?=nil
    
    @IBOutlet weak var viewToScroll: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
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
        if let activeField = self.activeField, keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            //NSLog(String(self.viewToScroll.frame.size.height))
            print("Before: \(scrollView.contentSize)")
            self.scrollView.contentInset = contentInsets
            print("After: \(scrollView.contentSize)")
            NSLog(String(self.viewToScroll.frame.size.height))
            self.scrollView.scrollIndicatorInsets = contentInsets
            var aRect = self.viewToScroll.frame
            NSLog(String(self.viewToScroll.frame.size.height))
            //aRect.size.height -= keyboardSize.size.height
            NSLog(String(aRect.size.height))
        }
        /*
        if let activeView = self.activeView, keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            let aRect = self.viewToScroll.frame
            //aRect.size.height -= keyboardSize.size.height
            if (!CGRectContainsPoint(aRect, activeView.frame.origin)) {
                self.scrollView.scrollRectToVisible(activeView.frame, animated: true)
            }
        }
        */
        
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
     func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.activeField = nil
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.activeField = textField
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        self.activeView=nil
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        self.activeView=textView
    }
    
    
    
    
    
    //Clicked on Save
    @IBAction func clickedOnSave(sender: AnyObject) {
        if titleField.text == "" {
            let myAlert = UIAlertController(title: "Warning", message: "Title can't be empty", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){(ACTION) in}
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated: true, completion: nil)
            
        }

        else {
        
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