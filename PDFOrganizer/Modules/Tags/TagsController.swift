//
//  TagsController.swift
//  PDFOrganizer
//
//  Created by iMario on 10/3/16.
//  Copyright © 2016 Mario. All rights reserved.
//

import Foundation

protocol TagsControllerProtocol{

    var tags : NSArray? {set get}
    var selectedTags : NSMutableArray? {set get}
    init(tagsDidLoad : ((TagsControllerProtocol) -> Void)?)
    func createTagWithTitle(title: String, completion: (Void) -> Void)
    func createUserDocumentTagsWith(tags: NSMutableArray, documentPage: DocumentCell, completion : (Void) -> Void)
}

class TagsController : TagsControllerProtocol {
    
    var tags : NSArray? {
        didSet{
            if let _ = self.tagsDidLoad{
                self.tagsDidLoad!(self)
            }
        }
    }
    var selectedTags : NSMutableArray?
    var tagsDidLoad : ((TagsControllerProtocol) -> Void)?
    
    required init(tagsDidLoad : ((TagsControllerProtocol) -> Void)?){
        self.tagsDidLoad = tagsDidLoad
        self.selectedTags = NSMutableArray()
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
                if let _ = documentPage.posX, _ = documentPage.posY, _ = documentPage.page{
                    uDocTag.document = documentPage.document
                    uDocTag.tag = tag as? Tag
                    uDocTag.positionX = documentPage.posX!
                    uDocTag.positionY = documentPage.posY!
                    uDocTag.page = documentPage.page!
                }
            }
        }
        StoreCoordinator.sInstance.saveContext()
        documentPage.showNewTags(tags)
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
