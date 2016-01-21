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
    
    func changeTitleForActionView(newTitle : String, index : Int) {
        
        var deleteConfirmationView: UIView? 
        for subview in subviews {
            if subview.isKindOfClass(NSClassFromString("UITableViewCellDeleteConfirmationView")!) {
                deleteConfirmationView = subview
                break
            }
        }
        
        if let unwrappedDeleteView = deleteConfirmationView {
            let actionbuttons = unwrappedDeleteView.valueForKey("_actionButtons") as? [AnyObject]
            
            if let actionButton = actionbuttons?[index] as? UIButton {
                
                actionButton.setTitle(newTitle, forState: .Normal)
            }
            
        }
        
    }
    
}
