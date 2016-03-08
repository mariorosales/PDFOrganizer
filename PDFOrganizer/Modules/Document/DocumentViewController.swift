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
       
        if let docCell = cell as? DocumentCell {
            collectionView.removeGestureRecognizer(docCell.scrollView!.pinchGestureRecognizer!)
            collectionView.removeGestureRecognizer(docCell.scrollView!.panGestureRecognizer)
        }
        
    }
    
    //MARK: - Notification Method
    
    func longPressInPage(notification: NSNotification){
        
        if let cell = notification.object as? DocumentCell {
            
            self.selectedDocumentCell = cell
            
            let tableViewController = UITableViewController()
            tableViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            tableViewController.preferredContentSize = CGSizeMake(400, 400)
            
            presentViewController(tableViewController, animated: true, completion: nil)
            
            if let popoverPC = tableViewController.popoverPresentationController{
                popoverPC.delegate = self
                popoverPC.sourceView = self.collectionView!
                popoverPC.sourceRect = CGRectMake(cell.posX!,cell.posY!, 10, 10)
            }
        
        }
    }
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        
        if let _ = self.selectedDocumentCell{
        
            self.selectedDocumentCell!.addGesture()
            self.selectedDocumentCell = nil
        }
    }

}