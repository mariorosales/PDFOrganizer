//
//  CatalogueController.swift
//  PDFOrganizer
//
//  Created by iMario on 6/3/16.
//  Copyright © 2016 Mario. All rights reserved.
//

import Foundation

class CatalogueController: NSObject {
    
    var documents : [Document]?
    internal var vController : CatalogueViewController?

    init(vC : CatalogueViewController?){
        
        super.init()
        
        self.loadDocuments()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"updateCatalogue", name: DocumentImportEven.NewDocumentAdded.rawValue, object: nil)
        
        if let _ = vC{
            self.vController = vC!
        }
    }
    
    func loadDocuments(){
        
        if let docs = StoreCoordinator.sInstance.getAllOfType("Document"){
            self.documents = docs as? [Document]
        } else {
            self.documents = [Document]()
        }
    }
    
    func getFileNameWithDocument(document: Document) -> String {
        
        if let filePath = document.fileName {
        
             return filePath.componentsSeparatedByString("/").last! as String
        } else {
            return ""
        }

    }
        
    func updateCatalogue(){
        
        self.loadDocuments()
        
        dispatch_async(dispatch_get_main_queue(),{

            if let _ = self.vController {
                if let collectionV = self.vController!.collectionView{
                    collectionV.reloadData()
                }
            }
        })
    }
}
