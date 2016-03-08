//
//  DocumentCell.swift
//  PDFOrganizer
//
//  Created by iMario on 6/3/16.
//  Copyright © 2016 Mario. All rights reserved.
//

import UIKit

public enum CellEventNotification : String {

    case LongPress
}


class DocumentCell: UICollectionViewCell, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    
    @IBOutlet  weak var thumbnailImageView : UIImageView?
    @IBOutlet weak var scrollView : UIScrollView?
    
    var indexPath : NSIndexPath?
    
    var relativeX : CGFloat?
    var relativeY : CGFloat?
    
    var posX : CGFloat?
    var posY : CGFloat?
    
    var gesture : UILongPressGestureRecognizer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.scrollView!.delegate = self
        self.scrollView!.minimumZoomScale = 1
        self.scrollView!.maximumZoomScale = 3
        
        self.addGesture()

    }
    
    func addGesture(){
        self.gesture = UILongPressGestureRecognizer(target: self, action: "longPressAction:")
        self.addGestureRecognizer(self.gesture!)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return self.thumbnailImageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        
   
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        
        DocumentController.sInstance.updatePageQualityWithImageView(self.thumbnailImageView, completion: { (thumbnail) -> Void in
            if let _ = self.thumbnailImageView{
                self.thumbnailImageView!.image = thumbnail
            }
            
        })
    }
    
    func longPressAction(gesture : UILongPressGestureRecognizer){
        
        if let _ = self.thumbnailImageView {
            
            let width = self.thumbnailImageView!.frame.size.width
            let height = self.thumbnailImageView!.frame.size.height
            self.posX = gesture.locationInView(self).x
            self.posY = gesture.locationInView(self).y
            
            self.relativeX = (self.posX!/width) * self.scrollView!.zoomScale
            self.relativeY = (self.posY!/height) * self.scrollView!.zoomScale
            
            for recognizer in self.gestureRecognizers! {
                self.removeGestureRecognizer(recognizer as UIGestureRecognizer)
            }
            
            NSObject.cancelPreviousPerformRequestsWithTarget(self)
            self.performSelector("postNotificationWithPosition:", withObject: self, afterDelay: 0.3)
        }
    }
    
    func postNotificationWithPosition(cell :DocumentCell){
        NSNotificationCenter.defaultCenter().postNotificationName(CellEventNotification.LongPress.rawValue, object: cell)
    }
}
