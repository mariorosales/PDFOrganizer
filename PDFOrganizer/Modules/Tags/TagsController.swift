//
//  TagsController.swift
//  PDFOrganizer
//
//  Created by iMario on 10/3/16.
//  Copyright © 2016 Mario. All rights reserved.
//

import Foundation

class TagsController {
    
    internal var vController :TagsViewController
    
    var tags : NSArray?
    
    init(vC : TagsViewController?){
        
        if let _ = vC{
            
            self.vController = vC!
            
        } else {
            
            self.vController = TagsViewController()
        }
        self.loadTags { () -> Void in }
    }
    
    func createTagWithTitle(title: String, completion: (Void) -> Void){
        
        if let tag = StoreCoordinator.sInstance.createObjectOfType("Tag") as! Tag?{
            tag.tagName = title
            StoreCoordinator.sInstance.saveContext()
            
            self.loadTags({ () -> Void in
                completion()
            })
        }
    }
    
    func loadTags(completion: (Void) -> Void){
    
        if let allTags = StoreCoordinator.sInstance.getAllOfType("Tag"){
            self.tags = allTags as! [Tag]
        } else {
            self.tags = [Tag]()
        }
    }
    
    func getAllTags()-> NSArray{
        
        if let _ = self.tags{
            if (self.tags!.count > 0){
                return self.tags!
            } else {
                self.loadTags({() -> Void in
                    return self.tags!
                })
            }
        } else {
            return NSArray()
        }
    }
}
