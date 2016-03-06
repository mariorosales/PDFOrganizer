//
//  ViewController.swift
//  PDFOrganizer
//
//  Created by iMario on 5/3/16.
//  Copyright © 2016 Mario. All rights reserved.
//

import UIKit

class CatalogueViewController: UIViewController, UICollectionViewDataSource {
    
    var catalogueController : CatalogueController = CatalogueController()
    var documents : [Document]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let docs = StoreCoordinator.sInstance.getAllOfType("Document"){
            
            self.documents = docs as? [Document]
            return docs.count
            
        } else {
            
            return 0
        }

        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("documentCell", forIndexPath: indexPath) as! DocumentCell
        cell.backgroundColor = UIColor.orangeColor()
        
        if let docs = self.documents{
            
            let doc = docs[indexPath.row] as Document
            
            if let _ = doc.fileName{
                
                
                let fileName = doc.fileName!.componentsSeparatedByString("/").last! as String
    
                DocumentController.sInstance.getDocumentPageThumbnailWithFileName(fileName, page: 1, width: cell.frame.size.width, completion: { (thumbnail) -> Void in
                    
                    cell.thumbnailImageView!.image = thumbnail
                    
                });
                
            }

        }
        
        return cell
        
    }

}

