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
    func deleteItem(_ atIndex: Int)
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
        self.edgesForExtendedLayout = UIRectEdge()
        titleField.delegate=self
        dateField.delegate=self
        descField.delegate=self
        self.title = updatedList.title
        titleField.text = updatedList.title
        descField.text = updatedList.desc
        dateField.text = updatedList.date
        titleField.isUserInteractionEnabled=false
        dateField.isUserInteractionEnabled=false
        descField.isUserInteractionEnabled=false
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewItemController.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewItemController.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewItemController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        cancelButton.isHidden=true
        saveButton.isHidden=true
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
            datePickerView.addTarget(self, action: #selector(ViewItemController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.activeView = textView
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.activeView=nil
    }
    
    //Clicked on Cancel
    @IBAction func cancelClicked(_ sender:UIButton) {
        _=self.navigationController?.popViewController(animated: true)
    }
    
    //Clicked on Save
    @IBAction func saveClicked(_ sender: UIButton) {
        
        
        let currentDate=Date()
        let dateFormatter=DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        if dateFormatter.date(from: dateField.text!)!.timeIntervalSinceReferenceDate < currentDate.timeIntervalSinceReferenceDate {
            let myAlert=UIAlertController(title: "Invalid date", message: "Pick a valid date", preferredStyle: UIAlertControllerStyle.alert)
            let okAction=UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)
        }
            
        else if checkIfInvalid() {
            let myAlert=UIAlertController(title: "Duplicate title", message: "An item with the same title already exist", preferredStyle: UIAlertControllerStyle.alert)
            let okAction=UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            myAlert.addAction(okAction)
            self.present(myAlert, animated: true, completion: nil)

        }
            
        else{
            do{
                try context.updateData(updatedList)
                updatedList.title=titleField.text
                updatedList.desc=descField.text
                updatedList.date=dateField.text
                
            } catch DataController.CoreDataError.updateError {
                print("Update Error")
            }catch{
                print("Other Update Errors")
            }
            _=self.navigationController?.popViewController(animated: true)
            }
        
    }
    //Clicked on Edit
    @IBAction func editClicked(_ sender: UIButton) {
        titleField.isUserInteractionEnabled=true
        descField.isUserInteractionEnabled=true
        dateField.isUserInteractionEnabled=true
        deleteButton.isHidden=true
        editButton.isHidden=true
        cancelButton.isHidden=false
        saveButton.isHidden=false
    }
    //Clicked on Delete
    @IBAction func deleteClicked(_ sender: AnyObject) {
        let myAlert = UIAlertController(title: "Are you sure?", message: "This will permanently delete the item", preferredStyle: UIAlertControllerStyle.alert)
        let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive)
        {(action) in
            
            if self.dele != nil {
                self.dele!.deleteItem(self.index)
                _=self.navigationController?.popViewController(animated: true)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        myAlert.addAction(deleteAction)
        myAlert.addAction(cancelAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    func datePickerValueChanged(_ sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateField.text = dateFormatter.string(from: sender.date)
        
    }
    
    func checkIfInvalid() ->Bool{
        var result:Bool=false
        if  list != [] {
            for item in list{
                if index==list.index(of: item){
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
