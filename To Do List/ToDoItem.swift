//
//  ToDoItem.swift
//  To Do List
//
//  Created by qburst on 30/08/16.
//  Copyright © 2016 qburst. All rights reserved.
//

import UIKit

class ToDoItem: NSObject {

    var text: String
    var desc: String
    var date: String

    
    init(text: String, desc: String, date: String) {
        self.text = text
        self.desc = desc
        self.date = date
        
    }
    
    
}
