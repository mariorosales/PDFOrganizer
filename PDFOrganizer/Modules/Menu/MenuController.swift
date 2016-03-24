//
//  MenuController.swift
//  PDFOrganizer
//
//  Created by iMario on 6/3/16.
//  Copyright © 2016 Mario. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public enum MenuOptions : String{
    
    case MenuOptionSearch, MenuOptionRecent, MenuOptionCatalogue
    static let allValues = [MenuOptionSearch, MenuOptionRecent, MenuOptionCatalogue]
    static var count = 4
}

struct MenuOptionItem {
    
    var menuOption : MenuOptions
    var label : String
}

protocol MenuControllerProtocol{
    
    var menuOptionSelected : MenuOptions {get set}
    var menuOptionSelectedDidChange : ((MenuOptions)-> Void)? {get set}
    var menuOptionSelectedWillChange : ((MenuOptions)-> Void)? {get set}
    
    var menuOptions : Array<MenuOptionItem> {get set}
    var menuOptionsDidSet : ((Void)->  Void)? {get set}
    
}

class MenuController : MenuControllerProtocol{
    
    var menuOptionSelectedDidChange : ((MenuOptions)-> Void)?
    var menuOptionSelectedWillChange : ((MenuOptions)-> Void)?
    var menuOptionsDidSet : ((Void)->  Void)?

    var menuOptionSelected : MenuOptions {
        willSet {
            if let _ = self.menuOptionSelectedWillChange {
                self.menuOptionSelectedWillChange!(self.menuOptionSelected)
            }
        }
        didSet{
            if let _ = self.menuOptionSelectedDidChange {
                self.menuOptionSelectedDidChange!(self.menuOptionSelected)
            }
        }
    }
    
    var menuOptions : Array<MenuOptionItem>
    
    init(optionsReady : ((Void) -> Void)){
        self.menuOptionSelected = .MenuOptionSearch
        self.menuOptionsDidSet = optionsReady
        
        var arrayMenuItems = Array<MenuOptionItem>()
        
        for option in MenuOptions.allValues{
            
            let menuItem = MenuOptionItem(menuOption: option, label: NSLocalizedString(option.rawValue, comment: ""))
            arrayMenuItems.append(menuItem)
            
        }
        
        self.menuOptions = arrayMenuItems
        if let _ = self.menuOptionsDidSet{
            self.menuOptionsDidSet!()
        }
    }
}

