//
//  List+CoreDataProperties.swift
//  To Do List
//
//  Created by qburst on 12/09/16.
//  Copyright © 2016 qburst. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension List {

    @NSManaged var title: String?
    @NSManaged var desc: String?
    @NSManaged var date: String?

}
