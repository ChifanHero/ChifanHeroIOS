//
//  SecondViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 7/29/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchResultsUpdating, UISearchControllerDelegate, ImageProgressiveTableViewDelegate{
    
    @IBOutlet weak var selectionBar: SelectionBar!
    
    
    @IBOutlet weak var searchResultTableView: UITableView!
    
    
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Search view");
        
        searchController = UISearchController(searchResultsController: nil)
        
        // The object responsible for updating the contents of the search results controller.
        searchController.searchResultsUpdater = self
        
        // Determines whether the underlying content is dimmed during a search.
        // if we are presenting the display results in the same view, this should be false
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.delegate = self
        
        // Make sure the that the search bar is visible within the navigation bar.
        searchController.searchBar.sizeToFit()
        self.navigationItem.titleView = searchController.searchBar
        searchController.searchBar.barTintColor = UIColor.clearColor()
        searchController.searchBar.placeholder = "大家都在搜：韶山冲"

        definesPresentationContext = true
        searchResultTableView.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
//        searchBar.placeholder = "AAAAA"
//        self.searchBar?.setShowsCancelButton(true, animated: true)
//    }
//    
//    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
//        self.searchBar?.endEditing(true)
//        self.searchBar?.setShowsCancelButton(false, animated: true)
//    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchBar.text)
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
    }
    
    func imageForIndexPath(tableView tableView : UITableView, indexPath : NSIndexPath) -> PhotoRecord {
        return PhotoRecord(name: "", url: NSURL())
    }
    
}



