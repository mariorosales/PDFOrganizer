//
//  DocumentViewController.swift
//  PDFOrganizer
//
//  Created by iMario on 6/3/16.
//  Copyright © 2016 Mario. All rights reserved.
//

import UIKit

protocol DocumentViewControllerDelegate{
    
    func dismissDocument()
    
}

class DocumentViewController: UIViewController, UICollectionViewDataSource {
    
    var document : Document?
    var delegate : DocumentViewControllerDelegate?
    
    @IBOutlet weak var collectionView : UICollectionView?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    func loadDocument(doc: Document){
    
        self.document = doc
        if let _ = self.collectionView{
            self.collectionView!.reloadData()
            self.collectionView!.setContentOffset(CGPointZero, animated: false)
        }
        
    }
    
    //MARK: - IBActions
    
    @IBAction func closeDocumentAction(sender : AnyObject?){
        
        if let _ = self.delegate{
        
            self.delegate!.dismissDocument()
        }
    
    }
    
    //MARK: - UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let _ = self.document{
            if let _ = self.document!.fileName{
                return Int(DocumentController.sInstance.getDocumentNumberOfPagesWithFileName(self.document!.fileName!))
            }
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("documentPage", forIndexPath: indexPath) as! DocumentCell
        
        if let _ = self.document{
            if let _ = self.document!.fileName{
                DocumentController.sInstance.getDocumentPageThumbnailWithFileName(self.document!.fileName!, page: (indexPath.row+1), width: cell.frame.size.width, completion: { (thumbnail) -> Void in
                    
                    cell.thumbnailImageView!.image = thumbnail
                    
                });

            }
        }


        return cell
    }
    
    
    
}