//
//  RefreshableViewDelegate.swift
//  Lightning
//
//  Created by Zhang, Alex on 5/9/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import UIKit

protocol RefreshableViewDelegate {
    
    func handleNoNetwork()
    
    func refreshData()
    
    func loadData(_ refreshHandler : ((_ success : Bool) -> Void)?)
}
