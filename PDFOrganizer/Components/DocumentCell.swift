//
//  DocumentCell.swift
//  PDFOrganizer
//
//  Created by iMario on 6/3/16.
//  Copyright © 2016 Mario. All rights reserved.
//

import UIKit


class DocumentCell: UICollectionViewCell, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    
    @IBOutlet  weak var thumbnailImageView : UIImageView?
    @IBOutlet weak var scrollView : UIScrollView?
    
    var document : Document?
    var page : Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.scrollView!.delegate = self
        self.scrollView!.minimumZoomScale = 1
        self.scrollView!.maximumZoomScale = 3
        
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return self.thumbnailImageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        
   
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        
        if let _ = self.document{
            
            DocumentController.sInstance.updatePageQualityWithDocument(self.document!, page: self.page! , imageView: self.thumbnailImageView, completionUpdate: { (thumbnail) -> Void in
                if let _ = self.thumbnailImageView{
                    self.thumbnailImageView!.image = thumbnail
                }
            })
        }
    }
}
