//
//  ViewController.swift
//  PDFOrganizer
//
//  Created by iMario on 5/3/16.
//  Copyright © 2016 Mario. All rights reserved.
//

import UIKit

class CatalogueViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, MenuViewControllerDelegate, DocumentViewControllerDelegate {
    
    var catalogueController : CatalogueController = CatalogueController(vC: nil)
    
    var documentViewController : DocumentViewController?
    
    @IBOutlet weak var collectionView : UICollectionView?
    @IBOutlet weak var menuConstraint : NSLayoutConstraint?
    @IBOutlet weak var documentConstraint : NSLayoutConstraint?
    @IBOutlet weak var documentContainer : UIView?

    override func viewDidLoad() {
        
        self.catalogueController = CatalogueController(vC: self)
        super.viewDidLoad()
        
        if let _ = self.documentConstraint {
        
            self.documentConstraint!.constant = self.view.frame.size.height
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "LoadMenu"){
            if let menuVC = segue.destinationViewController as? MenuViewController{
                menuVC.delegate = self
            }

        } else if(segue.identifier == "LoadDocument"){
            if let docVC = segue.destinationViewController as? DocumentViewController{
                self.documentViewController = docVC
            }
        }
        
    }
    
    //MARK: - MenuViewControllerDelegate
    
    func MenuDidShow(menu: MenuViewController) {
        
        if let _ = self.menuConstraint{
        
            self.menuConstraint!.constant = 0
        }
        
    }
    
    func MenuDidHide(menu: MenuViewController) {
        
        if let _ = self.menuConstraint{
            if let _ = menu.titleLabel {
                self.menuConstraint!.constant = -menu.titleLabel!.frame.size.width
            }
        }
    }
    
    //MARK: - DocumentViewControllerDelegate
    
    func dismissDocument() {
        
        if let _ = self.documentConstraint {
            UIView.animateWithDuration(0.3) { () -> Void in
                self.documentConstraint!.constant = self.view.frame.size.height
            }
        }
        
    }

    //MARK: - UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
       return self.catalogueController.documents!.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("documentCell", forIndexPath: indexPath) as! DocumentCell        
        
        let doc = self.catalogueController.documents![indexPath.row] as Document

        DocumentController.sInstance.getDocumentPageThumbnailWithFileName(doc.fileName, page: 1, width: cell.frame.size.width, completion: { (thumbnail) -> Void in
            
            cell.thumbnailImageView!.image = thumbnail
            
        });
        
        return cell
    }
    
    //MARK : - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if let _ = self.documentViewController{
            
            let doc = self.catalogueController.documents![indexPath.row] as Document

            self.documentViewController!.loadDocument(doc)
            self.documentViewController!.delegate = self
            
            UIView.animateWithDuration(0.3) { () -> Void in
                self.documentConstraint!.constant = 20
            }
        }
        
        

    }
}

