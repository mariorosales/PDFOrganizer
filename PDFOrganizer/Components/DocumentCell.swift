//
//  DocumentCell.swift
//  PDFOrganizer
//
//  Created by iMario on 6/3/16.
//  Copyright © 2016 Mario. All rights reserved.
//

import UIKit

public enum PageNotification : String{
    case BetterQuality
}

class DocumentCell: UICollectionViewCell, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    
    @IBOutlet  weak var thumbnailImageView : UIImageView?
    @IBOutlet weak var scrollView : UIScrollView?
    
    var indexPath : NSIndexPath?
    
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
        
        if let _ = self.indexPath{
            NSNotificationCenter.defaultCenter().postNotificationName(PageNotification.BetterQuality.rawValue, object: self.indexPath!)
        }
        
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
    }
}
