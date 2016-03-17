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
    
    let tagsOffset = CGFloat(21)
    
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
    
    override func prepareForReuse(){
        super.prepareForReuse()
        if let _ = self.tagsView{
            for view in self.tagsView!.subviews{
                view.removeFromSuperview()
            }
        }
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
        
        if let _ = self.document, _ = view{
            
        DocumentController.sInstance.updatePageQualityWithDocument(self.document!, page: self.page! , view: view!, completionUpdate: { (thumbnail) -> Void in
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
        
        var offset = CGFloat(0)
        
        if let _ = tags, _ = self.posX, _ = self.posY {
            for tag in tags!{
                if let _ = tag as? Tag{
                    let button = UIButton()
                    button.setTitle((tag as! Tag).tagName, forState: UIControlState.Normal)
                    button.frame = CGRectMake(self.posX!, self.posY! + offset, 100, self.tagsOffset-1)
                    button.backgroundColor = UIColor.redColor()
                    self.tagsView!.addSubview(button)
                    offset += self.tagsOffset
                }
            }
        }
    }
}
