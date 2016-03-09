//
//  DocumentController.swift
//  PDFOrganizer
//
//  Created by iMario on 6/3/16.
//  Copyright © 2016 Mario. All rights reserved.
//

import Foundation
import UIKit
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
    
    func ScanNewDocuments(completion:(Void) -> Void){
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
            
            let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
            let enumerator = NSFileManager.defaultManager().enumeratorAtPath(documentsPath)
            
            var filenames = [String]()
            
            let allDatabaseDocs = StoreCoordinator.sInstance.getAllOfType("Document")
                        
            for doc in allDatabaseDocs! {
                filenames.append((doc as! Document).fileName!.lowercaseString)
            }
            
            if let _ = enumerator {
                while let element = enumerator!.nextObject() as? String {
                    let elm = element.lowercaseString.componentsSeparatedByString("/").last!
                    if (elm.hasSuffix("pdf")) {
                        if (!filenames.contains(elm)){
                            // Store in Core Data
                            if let doc = StoreCoordinator.sInstance.createObjectOfType("Document") as! Document?{
                                
                                let absolutePath = documentsPath.stringByAppendingString("/" + element)

                                doc.dateAdded = NSDate()
                                doc.fileName = element
                                doc.pages = NSNumber(int: self.getDocumentNumberOfPages(NSURL(fileURLWithPath: absolutePath)))
                            }
                        }
                    }
                }
                StoreCoordinator.sInstance.saveContext()
            }

            dispatch_async(dispatch_get_main_queue(),{
                completion()
            })
        })
    }
    
    func getDocumentNumberOfPagesWithFileName(fileName: String) -> Int32 {
        
        let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let absolutePath = documents.stringByAppendingString("/" + fileName)
        return self.getDocumentNumberOfPages(NSURL(fileURLWithPath: absolutePath))
    }
    
    func getDocumentNumberOfPages(pdfURL: NSURL) -> Int32 {
        
        var pdfDoc: CGPDFDocumentRef!
        pdfDoc = CGPDFDocumentCreateWithURL(pdfURL)
        let numberOfPages = CGPDFDocumentGetNumberOfPages(pdfDoc)
        return Int32(numberOfPages)
    }
    
    func updatePageQualityWithDocument(documentObj: Document, page: Int, imageView: UIImageView?, completionUpdate: (thumbnail : UIImage) -> Void) {
        
        if let _ = imageView {
            self.getDocumentPageThumbnailWithFileName(documentObj.fileName!, page: page, width: imageView!.frame.size.width, completion: { (thumbnail) -> Void in
                completionUpdate(thumbnail: thumbnail)
            })
        }
    }
    
    func getDocumentPageThumbnailWithFileName(fileName: String?, page : Int ,width: CGFloat , completion:(thumbnail : UIImage) -> Void ){
        
        if let _ = fileName {
            
            let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
            
            let absolutePath = documents.stringByAppendingString("/" + fileName!)
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
                if let pdfDoc = CGPDFDocumentCreateWithURL(NSURL(fileURLWithPath: absolutePath)){
                    if  let myPageRef = CGPDFDocumentGetPage(pdfDoc, page){
                        
                        var pageRect = CGPDFPageGetBoxRect(myPageRef, CGPDFBox.MediaBox)
                        let pdfScale = width/pageRect.size.width;
                        
                        pageRect.size = CGSizeMake(pageRect.size.width*pdfScale, pageRect.size.height*pdfScale);
                        pageRect.origin = CGPointZero;
                        
                        UIGraphicsBeginImageContext(pageRect.size);
                        
                        let context = UIGraphicsGetCurrentContext();
                        
                        // White BG
                        CGContextSetRGBFillColor(context, 1.0,1.0,1.0,1.0);
                        CGContextFillRect(context,pageRect);
                        
                        CGContextSaveGState(context);
                        
                        // ***********
                        // Next 3 lines makes the rotations so that the page look in the right direction
                        // ***********
                        CGContextTranslateCTM(context, 0.0, pageRect.size.height);
                        CGContextScaleCTM(context, 1.0, -1.0);
                        CGContextConcatCTM(context, CGPDFPageGetDrawingTransform(myPageRef, CGPDFBox.MediaBox, pageRect, 0, true));
                        
                        CGContextDrawPDFPage(context, myPageRef);
                        CGContextRestoreGState(context);
                        
                        let thm = UIGraphicsGetImageFromCurrentImageContext();
                        
                        UIGraphicsEndImageContext();
                        
                        dispatch_async(dispatch_get_main_queue(),{
                            
                            completion(thumbnail: thm)
                            
                        })
                        
                        
                    }
                }
            })
        
        }
        
  
    }
    
}