//
//  SecondViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 7/29/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate{
    
    @IBOutlet weak var selectionBar: SelectionBar!
    
    var searchBar : UISearchBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Search view");
        searchBar = UISearchBar()
        searchBar!.barTintColor = UIColor.clearColor()
        searchBar!.placeholder = "大家都在搜：韶山冲"
        searchBar!.delegate = self
        self.navigationItem.titleView = searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.placeholder = "AAAAA"
        self.searchBar?.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchBar?.endEditing(true)
        self.searchBar?.setShowsCancelButton(false, animated: true)
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchBar.text)
    }
    

}

