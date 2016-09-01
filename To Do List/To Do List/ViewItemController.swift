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
    var viewTitle: String!
    var viewDesc:String!
    var viewDate:String!
    var index: Int!
    var dele: deleteDataDelegate? = nil
    @IBOutlet weak var viewItemTitle: UITextField!
    @IBOutlet weak var viewItemDate: UITextField!
    @IBOutlet weak var viewItemDesc: UITextView!
    
    @IBAction func deleteClicked(sender: AnyObject) {
        if dele != nil {
            dele!.deleteItem(index)
            self.navigationController?.popViewControllerAnimated(true)
            
        }
        
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewItemTitle.text = viewTitle
        viewItemDesc.text = viewDesc
        viewItemDate.text = viewDate
        
    }
    
}
