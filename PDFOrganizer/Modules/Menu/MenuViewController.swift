//
//  MenuViewController.swift
//  PDFOrganizer
//
//  Created by iMario on 6/3/16.
//  Copyright © 2016 Mario. All rights reserved.
//

import UIKit

public enum MenuStates{

    case MenuOpen
    case MenuClose
}

public enum MenuOptions{

    case MenuOptionSearch
    case MenuOptionRecent
    case MenuOptionCatalogue
}

protocol MenuViewControllerDelegate {
    
    func MenuDidShow(menu: MenuViewController)
    func MenuDidHide(menu: MenuViewController)

}

class MenuViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var menuController: MenuController?
    var menuStatus : MenuStates = .MenuClose
    
    var delegate: MenuViewControllerDelegate?
    
    @IBOutlet weak var openCloseButton : UIButton?
    @IBOutlet weak var menuOptionsView : UIView?
    @IBOutlet weak var tableView : UITableView?
    @IBOutlet weak var titleLabel : UILabel?
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.menuController = MenuController(vC: self)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.hideMenu { () -> Void in
            if let _ = self.menuController{
                self.menuController!.MenuControllerDidHide()
            }
        }
    }
    
    //MARK: - Status Actions 
    
    func hideMenu(completion:(Void) -> Void ){
        
        if let _ = self.openCloseButton{
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                if let _ = self.delegate{
                    self.delegate!.MenuDidHide(self)
                }
                
                self.openCloseButton!.setTitle(">", forState: UIControlState.Normal)
                if let _ = self.menuOptionsView{
                    self.menuOptionsView!.alpha = 0.0
                }
                
                }, completion: { (complete) -> Void in
                    
                    if (complete){
                        completion()
                    }
            })
        }
    }
    
    func showMenu(completion: (Void) -> Void){
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            if let _ = self.delegate{
                self.delegate!.MenuDidShow(self)
            }
            
            if let _ = self.openCloseButton{
                self.openCloseButton!.setTitle("<", forState: UIControlState.Normal)
            }

            if let _ = self.menuOptionsView{
                self.menuOptionsView!.alpha = 1.0
            }
            }, completion: { (complete) -> Void in
                
                if (complete){
                    completion()
                }
        })
    }
    
    //MARK: - IBActions
    
    @IBAction func openCloseButtonPresed(sender: UIButton){
        
        switch self.menuStatus {
        
        case .MenuOpen:
            
            self.hideMenu({ () -> Void in
                if let _ = self.menuController{
                    self.menuController!.MenuControllerDidHide()
                }
                self.menuStatus = .MenuClose
            })
            break
        case .MenuClose:
            
            self.showMenu({ () -> Void in
                if let _ = self.menuController{
                    self.menuController!.MenuControllerDidShow()
                }
                self.menuStatus = .MenuOpen
            })
            break
        }
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let _ = self.menuController{
        
            self.menuController!.MenuOptionSelected(MenuOptions.MenuOptionCatalogue)
        }
    }

    //MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL")
        }
        
        if let _ = cell{
            
            cell!.textLabel!.text = "Baking Soda"
            cell!.detailTextLabel!.text = "1/2 cup"
        }

        return cell!
        
    }

}