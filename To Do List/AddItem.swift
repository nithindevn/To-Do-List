//
//  AddItem.swift
//  To Do List
//
//  Created by qburst on 30/08/16.
//  Copyright © 2016 qburst. All rights reserved.
//

import UIKit

protocol dataEnteredDelegate{

    func userEnteredInfo(_ addToList:Item)
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
        self.edgesForExtendedLayout = UIRectEdge()
        titleField.delegate=self
        descField.delegate=self
        dateField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(AddItem.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddItem.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddItem.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func keyboardDidShow(_ notification: Notification) {
        
        if (self.activeField != nil || self.activeView != nil) {
            let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize!.height, right: 0.0)
            
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        }
    }
    
    func keyboardWillBeHidden(_ notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    //UITextFieldDelegate method-->calls whenever the current text changes
    //To disable the textField
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField==self.dateField{
            return false
        }
        else{
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeField = nil
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeField = textField
        if textField==dateField{
            let datePickerView = UIDatePicker()
            datePickerView.datePickerMode = UIDatePickerMode.date
            textField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(AddItem.datePickerValueChanged), for: UIControlEvents.valueChanged)
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.activeView = textView
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.activeView=nil
    }
    
    //Clicked on Save
    @IBAction func clickedOnSave(_ sender: AnyObject) {
        let currentDate=Date()
        let dateFormatter=DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        if titleField.text == "" {
            let myAlert = UIAlertController(title: "Warning", message: "Title can't be empty", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
            {(action) in
                self.view.endEditing(true)
            }
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)
            
        }
                else if dateField.text == "" {
            let myAlert = UIAlertController(title: "Warning", message: "Date can't be empty", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
            {(action) in
                self.view.endEditing(true)
            }
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)
        }
            
        else if dateFormatter.date(from: dateField.text!)!.timeIntervalSinceReferenceDate < currentDate.timeIntervalSinceReferenceDate {
            let myAlert=UIAlertController(title: "Invalid date", message: "Pick a valid date", preferredStyle: UIAlertControllerStyle.alert)
            let okAction=UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)
        }
        else if checkIfInvalid(){
            let myAlert=UIAlertController(title: "Duplicate title", message: "An item with the same title already exist", preferredStyle: UIAlertControllerStyle.alert)
            let okAction=UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)
        }

        else {
            addToList.title = titleField.text!
            addToList.desc = descField.text!
            addToList.date = dateField.text!
            if (delegate != nil){
                delegate!.userEnteredInfo(addToList)
                _=self.navigationController?.popViewController(animated: true)
        
            }
        }
    }
    
    //Clicked on Cancel
    @IBAction func clickedOnCancel(_ sender: AnyObject) {
        
        _=self.navigationController?.popViewController(animated:true)
    }
    
    func datePickerValueChanged(_ sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateField.text = dateFormatter.string(from: sender.date)
    
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
