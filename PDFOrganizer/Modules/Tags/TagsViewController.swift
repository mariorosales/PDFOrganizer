//
//  TagsViewController.swift
//  PDFOrganizer
//
//  Created by iMario on 10/3/16.
//  Copyright © 2016 Mario. All rights reserved.
//

import UIKit

class TagsViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var tagsController : TagsController?
    var documentPage : DocumentCell?
    
    @IBOutlet weak var tableView : UITableView?
    @IBOutlet weak var textField : UITextField?
    @IBOutlet weak var addTagButton : UIButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tagsController = TagsController(vC: self)
        
    }
    
    //MARK: - IBActions
    
    
    @IBAction func addTag(sender : AnyObject?){
    
        if let _ =  self.tagsController, _ = self.textField, _ = self.documentPage{
            self.tagsController!.createTagWithTitle(self.textField!.text!, completion: { () -> Void in
                if let _ = self.tableView{
                    self.tableView!.reloadData()
                }
            })
        }
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath){
        
            if( cell.accessoryType == UITableViewCellAccessoryType.Checkmark){
                cell.accessoryType = UITableViewCellAccessoryType.None
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
        }
    }
    
    //MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let _ = self.tagsController{
            return self.tagsController!.getAllTags().count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("TagCell")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "TagCell")
        }
        
        if let _ = self.tagsController, _ = self.tagsController!.tags, tag = self.tagsController!.tags![indexPath.row] as? Tag{
            cell!.textLabel!.text = tag.tagName!
        }
        
        return cell!
        
    }
    
}
