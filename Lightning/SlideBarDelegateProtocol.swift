//
//  SlideBarDelegateProtocol.swift
//  HorizontalScroll
//
//  Created by Shi Yan on 8/25/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation
import UIKit

protocol SlideBarDelegate {
    
    func slideBar(_ slideBar : SlideBar, didSelectElementAtIndex index : Int) -> Void

}
