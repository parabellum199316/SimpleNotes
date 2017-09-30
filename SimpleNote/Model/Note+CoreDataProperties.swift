//
//  Note+CoreDataProperties.swift
//  SimpleNote
//
//  Created by ParaBellum on 9/30/17.
//  Copyright © 2017 ParaBellum. All rights reserved.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName:"Note")
    }

    @NSManaged public var dateAdded: Date
    @NSManaged public var noteContent: String?
    @NSManaged public var noteTitle: String

}
