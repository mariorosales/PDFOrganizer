//
//  Document+CoreDataProperties.swift
//  PDFOrganizer
//
//  Created by iMario on 6/3/16.
//  Copyright © 2016 Mario. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Document {

    @NSManaged var fileName: String?
    @NSManaged var pages: NSNumber?
    @NSManaged var dateAdded: NSDate?

}
