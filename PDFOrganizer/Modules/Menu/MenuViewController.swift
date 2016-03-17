//
//  MenuViewController.swift
//  PDFOrganizer
//
//  Created by iMario on 6/3/16.
//  Copyright © 2016 Mario. All rights reserved.
//

import UIKit

public enum MenuStates{
    case MenuOpen, MenuClose
}

public enum MenuOptions : String{
    case MenuOptionSearch, MenuOptionRecent, MenuOptionCatalogue, MenuOptionNone
}

protocol MenuViewControllerDelegate {
    
    func MenuDidShow(menu: MenuViewController)
    func MenuDidHide(menu: MenuViewController)
}

class MenuViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var controller: MenuControllerProtocol?
    
    var delegate: MenuViewControllerDelegate?
    var menuStatus : MenuStates = .MenuClose
    
    @IBOutlet weak var openCloseButton : UIButton?
    @IBOutlet weak var menuOptionsView : UIView?
    @IBOutlet weak var tableView : UITableView?
    @IBOutlet weak var titleLabel : UILabel?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.controller = MenuController()
        if let _ = self.controller{
            self.controller!.menuOptionSelectedDidChange = optionDidChange
            self.controller!.menuOptionSelectedWillChange = optionWillChange
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.hideMenu { () -> Void in
            if let _ = self.tableView{
                self.tableView!.reloadData()
            }
        }
    }
    
    let optionDidChange : ((MenuOptions) -> Void) = { (optionSelected : MenuOptions) -> Void in
        NSLog("%@", optionSelected.rawValue)
        
    }
    
    let optionWillChange : ((MenuOptions) -> Void) =  { (optionSelected : MenuOptions) -> Void in
        NSLog("%@", optionSelected.rawValue)
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
                self.menuStatus = .MenuClose
            })
            break
        case .MenuClose:
            
            self.showMenu({ () -> Void in
                self.menuStatus = .MenuOpen
            })
            break
        }
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let _ = self.controller{
            switch indexPath.row{
            case 1:
                self.controller!.menuOptionSelected = .MenuOptionCatalogue
            case 2:
                self.controller!.menuOptionSelected = .MenuOptionRecent
            default:
                self.controller!.menuOptionSelected = .MenuOptionSearch
            }
        }
    }

    //MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
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