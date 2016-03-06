//
//  DocumentController.swift
//  PDFOrganizer
//
//  Created by iMario on 6/3/16.
//  Copyright © 2016 Mario. All rights reserved.
//

import Foundation
import CoreGraphics

public enum DocumentImportEven : String {
    
    case NewDocumentAdded, UnableToAddDocument
}

class DocumentController {
    
    static let sInstance = DocumentController()
    
    func AddNewDocumentWithUrl(url : NSURL, completion: (result : Bool) -> Void)  {
    
        let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        if let _ = url.pathComponents{
            if let fileName = url.pathComponents!.last {
                
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
                    
                    let absolutePath = documents.stringByAppendingString("/" + fileName)
                    
                    if let encrypteddata = NSData(contentsOfURL: url) {
                        if encrypteddata.writeToFile(absolutePath, atomically: true){
                            
                            // Store in Core Data
                            if let doc = StoreCoordinator.sInstance.createObjectOfType("Document") as! Document?{
                                
                                doc.dateAdded = NSDate()
                                doc.fileName = fileName
                                doc.pages = NSNumber(int: self.getDocumentNumberOfPages(NSURL(fileURLWithPath: absolutePath)))
                                StoreCoordinator.sInstance.saveContext()
                                
                                completion(result: true)
                                return
                            }
                            completion(result: false)
                            return
                            
                        } else {
                            completion(result: false)
                            return
                        }
                    }
                })
            }
        }
    }
    
    func getDocumentNumberOfPages(pdfURL: NSURL) -> Int32 {
        
        var pdfDoc: CGPDFDocumentRef!
        pdfDoc = CGPDFDocumentCreateWithURL(pdfURL)
        let numberOfPages = CGPDFDocumentGetNumberOfPages(pdfDoc)
        return Int32(numberOfPages)
    }
    
}