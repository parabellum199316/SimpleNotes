//
//  Note+CoreDataClass.swift
//  SimpleNote
//
//  Created by ParaBellum on 9/29/17.
//  Copyright © 2017 ParaBellum. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Note)
public class Note: NSManagedObject {
    convenience init(){
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "Note"), insertInto: CoreDataManager.instance.managedObjectContext)
    }
    convenience init(with title:String,content:String?,dateAdded:Date){
        self.init()
        self.noteTitle = title
        self.noteContent = content
        self.dateAdded = dateAdded
    }
}
