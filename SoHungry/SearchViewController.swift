//
//  SecondViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 7/29/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var selectionPanel: SelectionPanel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Search view");
        self.navigationItem.titleView = UISearchBar()
        selectionPanel.setUpSelectionPanel(options: ["餐厅", "菜名", "榜单"], defaultSelection: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

