//
//  TagsViewController.swift
//  PDFOrganizer
//
//  Created by iMario on 10/3/16.
//  Copyright © 2016 Mario. All rights reserved.
//

import UIKit

class TagsViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var controller : TagsController?
    var documentPage : DocumentCell?
    
    
    @IBOutlet weak var tableView : UITableView?
    @IBOutlet weak var textField : UITextField?
    @IBOutlet weak var addTagButton : UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.controller = TagsController()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - IBActions
    
    @IBAction func apllyTags(sender : AnyObject?){
        
        if let _ = self.controller, _ = self.documentPage, let _ = self.controller!.selectedTags{
            self.controller!.createUserDocumentTagsWith(self.controller!.selectedTags!, documentPage: self.documentPage!, completion: { () -> Void in

                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    self.documentPage!.addGesture()
                })
            })
        }
    }
    
    @IBAction func addTag(sender : AnyObject?){
    
        if let _ =  self.controller, _ = self.textField, _ = self.documentPage{
            self.controller!.createTagWithTitle(self.textField!.text!, completion: { () -> Void in
                if let _ = self.tableView{
                    self.tableView!.reloadData()
                }
            })
            self.textField!.resignFirstResponder()
        }
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath){
        
            if( cell.accessoryType == UITableViewCellAccessoryType.Checkmark){
                cell.accessoryType = UITableViewCellAccessoryType.None
                if let _ = self.controller,_ = self.controller!.tags, _ = self.controller!.selectedTags {
                    self.controller!.selectedTags!.removeObject(self.controller!.tags!.objectAtIndex(indexPath.row))
                }
                
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                if let _ = self.controller, _ = self.controller!.tags, _ = self.controller!.selectedTags{
                    self.controller!.selectedTags!.addObject(self.controller!.tags!.objectAtIndex(indexPath.row))
                }
            }
        }
    }
    
    //MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let _ = self.controller , _ = self.controller!.tags {
            return self.controller!.tags!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("TagCell")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "TagCell")
        }
        
        if let _ = self.controller, _ = self.controller!.tags, tag = self.controller!.tags![indexPath.row] as? Tag{
            cell!.textLabel!.text = tag.tagName!
        }
        return cell!
    }
}
