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
            if let _ = self.document!.pages{
                return Int(self.document!.pages!)
            }
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("documentPage", forIndexPath: indexPath) as! DocumentCell
        
        if let _ = self.document{
            if let _ = self.document!.fileName{
                DocumentController.sInstance.getDocumentPageThumbnailWithFileName(self.document!.fileName!, page: (indexPath.row+1), width: cell.frame.size.width, completion: { (thumbnail) -> Void in
                    
                    collectionView.addGestureRecognizer(cell.scrollView!.pinchGestureRecognizer!)
                    collectionView.addGestureRecognizer(cell.scrollView!.panGestureRecognizer)
                    
                    cell.thumbnailImageView!.image = thumbnail
                    
                });

            }
        }


        return cell
    }
    
     func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath){
       
        let docCell = cell as! DocumentCell
        collectionView.removeGestureRecognizer(docCell.scrollView!.pinchGestureRecognizer!)
        collectionView.removeGestureRecognizer(docCell.scrollView!.panGestureRecognizer)
        
    }
    
    
}