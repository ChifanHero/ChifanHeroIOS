//
//  AboutMeViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 8/5/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class AboutMeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let username = NSUserDefaults.standardUserDefaults().valueForKey("username")
        print(username)
    }
    
}
