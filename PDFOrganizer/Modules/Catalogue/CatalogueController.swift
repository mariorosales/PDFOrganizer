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
                
        if (vC != nil) {
            
            if let _ = vC{
                self.vController = vC!
            }
        
            DocumentController.sInstance.ScanNewDocuments { () -> Void in
                
                self.updateCatalogue()
            }
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateCatalogue", name: DocumentImportEven.NewDocumentAdded.rawValue, object: nil)
            
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
        
        self.loadDocuments { () -> Void in
            
            dispatch_async(dispatch_get_main_queue(),{
                
                if let _ = self.vController , collectionV = self.vController!.collectionView {
                    collectionV.reloadData()
                }
            })
        }
    }
    
    func loadDocuments(complete : (Void) -> Void){
        
        if let docs = StoreCoordinator.sInstance.getAllOfType("Document"){
            self.documents = docs as? [Document]
        } else {
            self.documents = [Document]()
        }
        complete()
    }
    
}
