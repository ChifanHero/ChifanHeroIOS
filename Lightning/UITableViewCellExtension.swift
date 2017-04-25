//
//  UITableViewCellExtension.swift
//  Lightning
//
//  Created by Shi Yan on 1/20/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    
    func changeTitleForActionView(_ newTitle : String, index : Int) {
        
        var deleteConfirmationView: UIView? 
        for subview in subviews {
            if subview.isKind(of: NSClassFromString("UITableViewCellDeleteConfirmationView")!) {
                deleteConfirmationView = subview
                break
            }
        }
        
        if let unwrappedDeleteView = deleteConfirmationView {
            let actionbuttons = unwrappedDeleteView.value(forKey: "_actionButtons") as? [AnyObject]
            
            if let actionButton = actionbuttons?[index] as? UIButton {
                
                actionButton.setTitle(newTitle, for: UIControlState())
            }
            
        }
        
    }
    
}
