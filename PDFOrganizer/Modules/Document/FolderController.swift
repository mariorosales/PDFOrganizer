//
//  FolderController.swift
//  PDFOrganizer
//
//  Created by iMario on 6/3/16.
//  Copyright © 2016 Mario. All rights reserved.
//

import Foundation
import CoreGraphics


class FolderController {
    
    static let sInstance = FolderController()
    
    func AddNewDocumentWithUrl(url : NSURL) -> Bool {
    
        let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        if let _ = url.pathComponents{
            if let fileName = url.pathComponents!.last {
                
                let absolutePath = documents.stringByAppendingString("/" + fileName)

                if let encrypteddata = NSData(contentsOfURL: url) {
                    if encrypteddata.writeToFile(absolutePath, atomically: true){
                        
                        // Store in Core Data
                        if let doc = StoreCoordinator.sInstance.createObjectOfType("Document") as! Document?{
                            
                            doc.dateAdded = NSDate()
                            doc.fileName = fileName
                            doc.pages = NSNumber(int: self.getDocumentNumberOfPages(NSURL(fileURLWithPath: absolutePath)))
                            StoreCoordinator.sInstance.saveContext()
                        }
                        
                        return true
                        
                    } else {
                        return false
                    }
                }
            }
        }
        return false
    }
    
    func getDocumentNumberOfPages(pdfURL: NSURL) -> Int32 {
        
        var pdfDoc: CGPDFDocumentRef!
        var numberOfPages: Int
        pdfDoc = CGPDFDocumentCreateWithURL(pdfURL)
        numberOfPages = CGPDFDocumentGetNumberOfPages(pdfDoc)
        return Int32(numberOfPages)
    }
    
}