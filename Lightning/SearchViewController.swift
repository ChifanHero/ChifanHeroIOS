//
//  SecondViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 7/29/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate,UISearchResultsUpdating, UISearchControllerDelegate, UITableViewDelegate, UITableViewDataSource, ImageProgressiveTableViewDelegate, SelectionBarDelegate{
    
    @IBOutlet weak var selectionBar: SelectionBar!
    
    
    @IBOutlet weak var searchResultsTableView: ImageProgressiveTableView!
    
    
    var searchController: UISearchController!
    
    var restaurants : [Restaurant] = [Restaurant]()
    var dishes : [Dish] = [Dish]()
    var lists : [List] = [List]()
    
    var pendingOperations = PendingOperations()
    var restaurantImages = [PhotoRecord]()
    var dishImages = [PhotoRecord]()
    
    private var heightConstraint:NSLayoutConstraint?
    
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
        
        selectionBar.delegate = self
        
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
            let scope = selectionBar.scope
            if scope == "restaurant" {
                searchRestaurant(keyword: keyword!)
            } else if scope == "list" {
                searchList(keyword: keyword!)
            } else if scope == "dish" {
                searchDish(keyword: keyword!)
            }
            
        }
    }
    
    func searchRestaurant(keyword keyword : String) {
        cleanStates()
        let request : RestaurantSearchRequest = RestaurantSearchRequest()
        request.keyword = keyword
//        let location : (Double, Double) = UserContext.getUserLocation()
        let userLocation = UserContext.instance.userLocation
//        userLocation.lat = location.0
//        userLocation.lon = location.1
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
    
    func searchDish(keyword keyword : String) {
        cleanStates()
        let request : DishSearchRequest = DishSearchRequest()
        request.keyword = keyword
        let userLocation = UserContext.instance.userLocation
        //        userLocation.lat = location.0
        //        userLocation.lon = location.1
        request.userLocation = userLocation
        DataAccessor(serviceConfiguration: SearchServiceConfiguration()).searchDishes(request) { (searchResponse) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                if let results = searchResponse?.results {
                    self.dishes += results
                    for dish : Dish in results {
                        var url = dish.picture?.original
                        if url == nil {
                            url = ""
                        }
                        let record = PhotoRecord(name: "", url: NSURL(string: url!)!)
                        self.dishImages.append(record)
                    }
                    self.searchResultsTableView.hidden = false
                    self.searchResultsTableView.reloadData()
                    self.adjustSearchResultsTableHeight()
                }
                
            })
        }
    }
    
    func searchList(keyword keyword : String) {
        cleanStates()
        let request : DishListSearchRequest = DishListSearchRequest()
        request.keyword = keyword
        let userLocation = UserContext.instance.userLocation
        //        userLocation.lat = location.0
        //        userLocation.lon = location.1
        request.userLocation = userLocation
        DataAccessor(serviceConfiguration: SearchServiceConfiguration()).searchLists(request) { (searchResponse) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                if let results = searchResponse?.results {
                    self.lists += results
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
        self.dishes.removeAll()
        self.dishImages.removeAll()
        self.lists.removeAll()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectionBar.scope == "list" {
            return self.lists.count
        } else {
            return 1
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if selectionBar.scope == "list" {
            return 1
        } else if selectionBar.scope == "dish" {
            return self.dishes.count
        } else {
            return self.restaurants.count
        }
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if selectionBar.scope == "list" {
            var cell : ListTableViewCell? = tableView.dequeueReusableCellWithIdentifier("listCell") as? ListTableViewCell
            if cell == nil {
                tableView.registerNib(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "listCell")
                cell = tableView.dequeueReusableCellWithIdentifier("listCell") as? ListTableViewCell
            }
            cell!.model = lists[indexPath.row]
            return cell!
        } else if selectionBar.scope == "dish" {
            var cell : DishTableViewCell? = tableView.dequeueReusableCellWithIdentifier("dishCell") as? DishTableViewCell
            if cell == nil {
                tableView.registerNib(UINib(nibName: "DishCell", bundle: nil), forCellReuseIdentifier: "dishCell")
                cell = tableView.dequeueReusableCellWithIdentifier("dishCell") as? DishTableViewCell
            }
            let imageDetails = imageForIndexPath(tableView: self.searchResultsTableView, indexPath: indexPath)
            cell?.setUp(dish: self.dishes[indexPath.section], image: imageDetails.image!)
            
            switch (imageDetails.state){
            case PhotoRecordState.New:
                if (!tableView.dragging && !tableView.decelerating) {
                    self.searchResultsTableView.startOperationsForPhotoRecord(&pendingOperations, photoDetails: imageDetails,indexPath:indexPath)
                }
            default: break
            }
            return cell!
        } else {
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
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if selectionBar.scope == "list" {
            return ListTableViewCell.height
        } else if selectionBar.scope == "dish" {
            return DishTableViewCell.height
        } else {
            return RestaurantTableViewCell.height
        }
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
        
    }
    
    func imageForIndexPath(tableView tableView : UITableView, indexPath : NSIndexPath) -> PhotoRecord {
        if selectionBar.scope == "dish" {
            return self.dishImages[indexPath.section]
        } else if selectionBar.scope == "restaurant" {
            return self.restaurantImages[indexPath.section]
        } else {
            return PhotoRecord(name: "", url: NSURL())
        }
        
    }
    
    private func adjustSearchResultsTableHeight() {
        if self.searchResultsTableView.hidden == false {
            if self.heightConstraint != nil {
                self.searchResultsTableView.removeConstraint(heightConstraint!)
            }
            heightConstraint = NSLayoutConstraint(item: self.searchResultsTableView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute:NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.searchResultsTableView.contentSize.height);
            heightConstraint!.priority = 1000
            self.searchResultsTableView.addConstraint(heightConstraint!);
            self.view.layoutIfNeeded()
        }
    }
    
    
    func restaurantButtonClicked() {
        self.searchResultsTableView.hidden = true
    }
    
    func dishButtonPressed() {
        self.searchResultsTableView.hidden = true
    }
    
    func listButtonPressed() {
        self.searchResultsTableView.hidden = true
    }
    
}



