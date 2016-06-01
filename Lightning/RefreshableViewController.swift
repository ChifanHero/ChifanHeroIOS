//
//  RefreshableViewController.swift
//  Lightning
//
//  Created by Shi Yan on 3/6/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import UIKit
import Flurry_iOS_SDK

class RefreshableViewController: UIViewController {
    
    let noNetworkDefaultView: NoNetworkDefaultView = NoNetworkDefaultView()
    
    func refreshData() {
        
    }
    
    func loadData(refreshHandler : ((success : Bool) -> Void)?) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        noNetworkDefaultView.translatesAutoresizingMaskIntoConstraints = false
        noNetworkDefaultView.parentVC = self
        self.view.addSubview(noNetworkDefaultView)
        
        let leadingConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: noNetworkDefaultView, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0.0)
        let trailingConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: noNetworkDefaultView, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0.0)
        let topConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: noNetworkDefaultView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: noNetworkDefaultView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0)
        self.view.addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
        self.view.layoutIfNeeded()
        self.view.bringSubviewToFront(noNetworkDefaultView)
        if Reachability.isConnectedToNetwork() {
            noNetworkDefaultView.hide()
        } else {
            noNetworkDefaultView.show()
        }
        
    }
}
