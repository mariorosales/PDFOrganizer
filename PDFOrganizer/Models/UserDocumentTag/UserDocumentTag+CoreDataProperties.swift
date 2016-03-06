//
//  UserDocumentTag+CoreDataProperties.swift
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

extension UserDocumentTag {

    @NSManaged var page: NSNumber?
    @NSManaged var positionX: NSNumber?
    @NSManaged var positionY: NSNumber?
    @NSManaged var document: Document?
    @NSManaged var tag: Tag?

}
