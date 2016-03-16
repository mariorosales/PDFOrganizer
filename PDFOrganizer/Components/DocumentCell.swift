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
    
    
    @IBOutlet weak var thumbnailImageView : UIImageView?
    @IBOutlet weak var scrollView : UIScrollView?
    @IBOutlet weak var tagsView : UIView?
    @IBOutlet weak var containerView : UIView?
    
    var document : Document?
    var page : Int?
    
    var posX : CGFloat?
    var posY : CGFloat?
    
    var gesture : UILongPressGestureRecognizer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.scrollView!.delegate = self
        self.scrollView!.minimumZoomScale = 1
        self.scrollView!.maximumZoomScale = 6
        
        self.addGesture()

    }
    
    func addGesture(){
        self.gesture = UILongPressGestureRecognizer(target: self, action: "longPressAction:")
        self.addGestureRecognizer(self.gesture!)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return self.containerView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
   
        if let _ = self.tagsView{
            self.tagsView!.setNeedsLayout()
            self.tagsView!.updateConstraintsIfNeeded()
        }
   
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        
        if let _ = self.document{
            
        DocumentController.sInstance.updatePageQualityWithDocument(self.document!, page: self.page! , imageView: self.thumbnailImageView, completionUpdate: { (thumbnail) -> Void in
            if let _ = self.thumbnailImageView, _ = thumbnail{
                self.thumbnailImageView!.image = thumbnail!
            }})
        }
    }
    
    func longPressAction(gesture : UILongPressGestureRecognizer){
        
        if let _ = self.thumbnailImageView {

            self.posX = gesture.locationInView(self).x
            self.posY = gesture.locationInView(self).y
            
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
    
    func showNewTags(tags:NSArray?){
        if let _ = tags, _ = self.posX, _ = self.posY {
            for tag in tags!{
                if let _ = tag as? Tag{
                    let button = UIButton()
                    button.setTitle((tag as! Tag).tagName, forState: UIControlState.Normal)
                    button.frame = CGRectMake(self.posX!, self.posY!, 100, 20)
                    button.backgroundColor = UIColor.redColor()
                    self.tagsView!.addSubview(button)
                }
            }
        }
    }
}
