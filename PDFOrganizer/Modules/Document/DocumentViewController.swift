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

class DocumentViewController: UIViewController, UICollectionViewDataSource, UIPopoverPresentationControllerDelegate {
    
    var document : Document?
    var delegate : DocumentViewControllerDelegate?
    var selectedDocumentCell : DocumentCell?
    
    @IBOutlet weak var collectionView : UICollectionView?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "longPressInPage:", name: CellEventNotification.LongPress.rawValue, object: nil)
        
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
        
        if let _ = self.document, _ = self.document!.pages{
            return Int(self.document!.pages!)
        }
        
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("documentPage", forIndexPath: indexPath) as! DocumentCell
        
        if let _ = self.document, _ = self.document!.fileName{
            
            cell.document = self.document!
            var page : Int
            page = indexPath.row + Int(1)
            cell.page = page
            
            DocumentController.sInstance.getDocumentPageThumbnailWithFileName(self.document!.fileName!, page: (indexPath.row+1), width: cell.frame.size.width, height: cell.frame.size.height, completion: { (thumbnail) -> Void in
                
                collectionView.addGestureRecognizer(cell.scrollView!.pinchGestureRecognizer!)
                collectionView.addGestureRecognizer(cell.scrollView!.panGestureRecognizer)
                
                cell.thumbnailImageView!.image = thumbnail
            });
        }
        return cell
    }
    
     func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath){
       
        if let docCell = cell as? DocumentCell {
            
            docCell.scrollView!.setZoomScale(1, animated: true)
            collectionView.removeGestureRecognizer(docCell.scrollView!.pinchGestureRecognizer!)
            collectionView.removeGestureRecognizer(docCell.scrollView!.panGestureRecognizer)
        }
        
    }
    
    //MARK: - Notification Method
    
    func longPressInPage(notification: NSNotification){
        
        if let documentPage = notification.object as? DocumentCell {
            
            self.selectedDocumentCell = documentPage
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let tagsVC = storyboard.instantiateViewControllerWithIdentifier("TagsViewController") as? TagsViewController{
                
                tagsVC.modalPresentationStyle = UIModalPresentationStyle.Popover
                tagsVC.preferredContentSize = CGSizeMake(300, 400)
                tagsVC.documentPage = documentPage
                
                presentViewController(tagsVC, animated: true, completion: nil)

                if let popoverPC = tagsVC.popoverPresentationController{
                    popoverPC.delegate = self
                    popoverPC.sourceView = documentPage.contentView
                    popoverPC.sourceRect = CGRectMake(documentPage.posX!,documentPage.posY!, 10, 10)
                }
            }
        }
    }
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        
        if let _ = self.selectedDocumentCell{
        
            self.selectedDocumentCell!.addGesture()
            self.selectedDocumentCell = nil
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.Portrait , UIInterfaceOrientationMask.PortraitUpsideDown]
    }

}