//
//  SelectionPanelDelegateProtocol.swift
//  SoHungry
//
//  Created by Shi Yan on 9/4/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation
import UIKit

protocol SelectionPanelDelegateProtocol {
    
    func selectionPanel(selectionPanel : SelectionPanel, didSelectElementAtIndex : Int) -> Void
    
}