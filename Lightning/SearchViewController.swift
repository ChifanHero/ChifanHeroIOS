//
//  SecondViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 7/29/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate,UISearchResultsUpdating, UISearchControllerDelegate, UITableViewDelegate, UITableViewDataSource, ImageProgressiveTableViewDelegate{
    
    @IBOutlet weak var selectionBar: SelectionBar!
    
    
    @IBOutlet weak var searchResultsTableView: ImageProgressiveTableView!
    
    
    var searchController: UISearchController!
    
    var restaurants : [Restaurant] = [Restaurant]()
    
    var pendingOperations = PendingOperations()
    var restaurantImages = [PhotoRecord]()
    
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
        
        searchController.searchBar.delegate = self
        
        // Make sure the that the search bar is visible within the navigation bar.
        searchController.searchBar.sizeToFit()
        self.navigationItem.titleView = searchController.searchBar
        searchController.searchBar.barTintColor = UIColor.clearColor()
        searchController.searchBar.placeholder = "大家都在搜：韶山冲"

        definesPresentationContext = true
        searchResultsTableView.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Too expensive. For now, search only when the search buttion gets clicked
    func updateSearchResultsForSearchController(searchController: UISearchController) {
//        if searchController.active == false {
//            let text = searchController.searchBar.text
//            print(text)
//            print("called")
//        }
        
    }
    
    // For now, search only when the search buttion gets clicked
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let keyword = searchBar.text
        print(keyword)
        if keyword != nil && keyword != "" {
//            let scope = selectionBar.scope
            searchRestaurant(keyword: keyword!)
        }
    }
    
    func searchRestaurant(keyword keyword : String) {
        cleanStates()
        let request : RestaurantSearchRequest = RestaurantSearchRequest()
        request.keyword = keyword
        let location : (Double, Double) = UserContext.getUserLocation()
        let userLocation = Location()
        userLocation.lat = location.0
        userLocation.lon = location.1
        request.userLocation = userLocation
        DataAccessor(serviceConfiguration: SearchServiceConfiguration()).searchRestaurants(request) { (searchResponse) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                if let results = searchResponse?.results {
                    self.restaurants += results
                    for restaurant : Restaurant in results {
                        var url = restaurant.picture?.original
                        if url == nil {
                            url = ""
                        }
                        let record = PhotoRecord(name: "", url: NSURL(string: url!)!)
                        self.restaurantImages.append(record)
                    }
                    self.searchResultsTableView.hidden = false
                    self.searchResultsTableView.reloadData()
                    self.adjustSearchResultsTableHeight()
                }
                
            })
        }
    }
    
    func cleanStates () {
        self.restaurants.removeAll()
        self.restaurantImages.removeAll()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return restaurants.count
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : RestaurantTableViewCell? = tableView.dequeueReusableCellWithIdentifier("restaurantCell") as? RestaurantTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "RestaurantCell", bundle: nil), forCellReuseIdentifier: "restaurantCell")
            cell = tableView.dequeueReusableCellWithIdentifier("restaurantCell") as? RestaurantTableViewCell
        }
        let imageDetails = imageForIndexPath(tableView: tableView, indexPath: indexPath)
        cell?.setUp(restaurant: restaurants[indexPath.section], image: imageDetails.image!)
        
        switch (imageDetails.state){
        case .New:
            searchResultsTableView.startOperationsForPhotoRecord(&pendingOperations, photoDetails: imageDetails,indexPath:indexPath)
        default: break
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return RestaurantTableViewCell.height
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
        
    }
    
    func imageForIndexPath(tableView tableView : UITableView, indexPath : NSIndexPath) -> PhotoRecord {
        return self.restaurantImages[indexPath.section]
    }
    
    private func adjustSearchResultsTableHeight() {
        let originalFrame : CGRect = self.searchResultsTableView.frame
        self.searchResultsTableView.frame = CGRectMake(originalFrame.origin.x, originalFrame.origin.y, originalFrame.size.width, self.searchResultsTableView.contentSize.height)
    }
    
}



