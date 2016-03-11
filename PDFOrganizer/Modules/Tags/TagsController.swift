//
//  TagsController.swift
//  PDFOrganizer
//
//  Created by iMario on 10/3/16.
//  Copyright © 2016 Mario. All rights reserved.
//

import Foundation

class TagsController {
    
    var tags : NSArray?
    
    init(){
        self.loadTags()
    }
    
    func createTagWithTitle(title: String, completion: (Void) -> Void){
        
        if let tag = StoreCoordinator.sInstance.createObjectOfType("Tag") as! Tag?{
            tag.tagName = title
            StoreCoordinator.sInstance.saveContext()
            self.loadTags()
            completion()
        }
    }
    
    func createUserDocumentTagsWith(tags: NSMutableArray, documentPage: DocumentCell, completion : (Void) -> Void){
        
        for tag in tags{
            if let _ = tag as? Tag , uDocTag = StoreCoordinator.sInstance.createObjectOfType("UserDocumentTag") as! UserDocumentTag?{
                if let _ = documentPage.relativeY, _ = documentPage.relativeY, _ = documentPage.page{
                    uDocTag.document = documentPage.document
                    uDocTag.tag = tag as? Tag
                    uDocTag.positionX = documentPage.relativeX!
                    uDocTag.positionY = documentPage.relativeY!
                    uDocTag.page = documentPage.page!
                }
            }
        }
        StoreCoordinator.sInstance.saveContext()
        completion()
    }
    
    func loadTags(){
    
        if let allTags = StoreCoordinator.sInstance.getAllOfType("Tag"){
            self.tags = allTags as! [Tag]
        } else {
            self.tags = [Tag]()
        }
    }
    
}
