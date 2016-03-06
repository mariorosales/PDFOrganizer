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

class MenuController {
    
    internal var vController :MenuViewController

    init(vC : MenuViewController?){
        
        if let _ = vC{
            self.vController = vC!
        } else {
            self.vController = MenuViewController()
        }
    }
    
    func MenuControllerDidShow(){
    
    }
    
    func MenuControllerDidHide(){
        
        if let tView = self.vController.tableView {
            tView.reloadData()
        }
       
    }
    
    func MenuOptionSelected(optionSelected : MenuOptions){
    
    
    }
    
}
