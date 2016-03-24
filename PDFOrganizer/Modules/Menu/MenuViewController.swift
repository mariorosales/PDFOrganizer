//
//  MenuViewController.swift
//  PDFOrganizer
//
//  Created by iMario on 6/3/16.
//  Copyright © 2016 Mario. All rights reserved.
//

import UIKit

public enum MenuStates{
    case MenuOpen, MenuClose, MenuInit
}

protocol MenuViewControllerDelegate {
    
    func MenuDidShow(menu: MenuViewController)
    func MenuDidHide(menu: MenuViewController)
}

class MenuViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var controller: MenuControllerProtocol?
    
    var delegate: MenuViewControllerDelegate?
    var menuStatus : MenuStates = .MenuInit
    
    @IBOutlet weak var menuOptionsView : UIView?
    @IBOutlet weak var tableView : UITableView?

    var menuOptionsReady : ((Void) -> Void)?
    var optionDidChange : ((MenuOptions) -> Void)?
    var optionWillChange : ((MenuOptions) -> Void)?
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)!

        self.menuOptionsReady = { () -> Void in
        
            if let _ = self.tableView {
                self.tableView!.delegate = self
                self.tableView!.dataSource = self
            }
        }
        
        self.optionDidChange = { (optionSelected : MenuOptions) -> Void in
            NSLog("%@", optionSelected.rawValue)
            
        }
        
        self.optionWillChange = { (optionSelected : MenuOptions) -> Void in
            NSLog("%@", optionSelected.rawValue)
        }
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _ = self.menuOptionsReady{
            self.controller = MenuController(optionsReady: self.menuOptionsReady!)
            if let _ = self.controller{
                self.controller!.menuOptionSelectedDidChange = self.optionDidChange
                self.controller!.menuOptionSelectedWillChange = self.optionWillChange
            }
        }
    
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (self.menuStatus == .MenuInit){
            self.hideMenu  { () -> Void in
                if let _ = self.tableView{
                    self.tableView!.reloadData()
                }
            }
        }
    }

    
    //MARK: - Status Actions 
    
    func hideMenu(completion:(Void) -> Void ){
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            if let _ = self.delegate{
                self.delegate!.MenuDidHide(self)
            }
            
            if let _ = self.menuOptionsView{
                self.menuOptionsView!.alpha = 0.0
            }
            
            }, completion: { (complete) -> Void in
                
                if (complete){
                    completion()
                }
        })
        
    }
    
    func showMenu(completion: (Void) -> Void){
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            if let _ = self.delegate{
                self.delegate!.MenuDidShow(self)
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
        case .MenuInit, .MenuClose:
            
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

        if let _ = self.controller{
            return self.controller!.menuOptions.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("menuCell")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "menuCell")
        }
        
        if let _ = cell, _ = self.controller {
            cell!.textLabel!.text = self.controller!.menuOptions[indexPath.row].label
        }

        return cell!
    }
}