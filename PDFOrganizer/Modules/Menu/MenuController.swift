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

protocol MenuControllerProtocol{

    var menuOptionSelected : MenuOptions {get set}
    
    var menuOptionSelectedDidChange : ((MenuOptions)-> Void)? {get set}
    var menuOptionSelectedWillChange : ((MenuOptions)-> Void)? {get set}
    
}

class MenuController : MenuControllerProtocol{
    
    var menuOptionSelectedDidChange : ((MenuOptions)-> Void)?
    var menuOptionSelectedWillChange : ((MenuOptions)-> Void)?
    
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
    
    init(){
        self.menuOptionSelected = .MenuOptionNone
    }
    
}
