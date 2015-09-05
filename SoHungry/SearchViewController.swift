//
//  SecondViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 7/29/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, SelectionPanelDelegate{

    @IBOutlet weak var selectionPanel: SelectionPanel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Search view");
        let searchBar : UISearchBar = UISearchBar()
        searchBar.placeholder = "大家都在搜：韶山冲"
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        selectionPanel.setUpSelectionPanel(options: ["餐厅", "菜名", "榜单"], defaultSelection: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.placeholder = "AAAAA"
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchBar.text)
    }
    
    func selectionPanel(selectionPanel : SelectionPanel, didSelectElementAtIndex : Int) -> Void {
        
    }


}

