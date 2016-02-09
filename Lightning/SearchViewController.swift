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
    
    @IBOutlet weak var scrollView: UIScrollView!
    let refreshControl = UIRefreshControl()
    
    var restaurants : [Restaurant] = [Restaurant]()
    var dishes : [Dish] = [Dish]()
    var lists : [List] = [List]()
    
    var pendingOperations = PendingOperations()
    var restaurantImages = [PhotoRecord]()
    var dishImages = [PhotoRecord]()
    
    let footerView : LoadMoreFooterView = LoadMoreFooterView()
    
    @IBOutlet weak var waitingIndicator: UIActivityIndicatorView!
    
    private var heightConstraint:NSLayoutConstraint?
    
    let LIMIT = 50
    var offset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Search view");
        waitingIndicator.hidden = true
        selectionBar.hidden = false
        configurePullRefresh()
        
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
    
    private func configurePullRefresh(){
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.searchResultsTableView.addSubview(refreshControl)
    }
    
    @objc private func refresh(sender:AnyObject) {
        self.clearStates()
        search(0, limit: LIMIT)
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
        clearStates()
        search(0, limit: LIMIT)
    }
    
    func search(offset : Int, limit : Int) {
        
        let keyword = self.searchController.searchBar.text
        print(keyword)
        if keyword != nil && keyword != "" {
            if self.searchResultsTableView.hidden == true {
                waitingIndicator.hidden = false
                waitingIndicator.startAnimating()
            }
            let scope = selectionBar.scope
            if scope == "restaurant" {
                searchRestaurant(keyword: keyword!, offset: offset, limit: limit)
            } else if scope == "list" {
                searchList(keyword: keyword!, offset: offset, limit: limit)
            } else if scope == "dish" {
                searchDish(keyword: keyword!, offset: offset, limit: limit)
            }
            
        }
    }
    
    func searchRestaurant(keyword keyword : String, offset : Int, limit : Int) {
//        cleanStates()
        let request : RestaurantSearchRequest = RestaurantSearchRequest()
        request.highlightInField = true
        request.keyword = keyword
        request.offset = offset
        request.limit = limit
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
                    self.waitingIndicator.hidden = true
                    self.waitingIndicator.stopAnimating()
                    self.searchResultsTableView.allowsSelection = true
                    self.refreshControl.endRefreshing()
                    self.searchResultsTableView.reloadData()
//                    self.adjustSearchResultsTableHeight()
//                    self.adjustScrollViewContentHeight()
                }
                
            })
        }
    }
    
    func searchDish(keyword keyword : String, offset : Int, limit : Int) {
//        cleanStates()
        let request : DishSearchRequest = DishSearchRequest()
        request.keyword = keyword
        request.offset = offset
        request.limit = limit
        let userLocation = UserContext.instance.userLocation
        //        userLocation.lat = location.0
        //        userLocation.lon = location.1
        request.userLocation = userLocation
        request.highlightInField = true
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
                    self.waitingIndicator.hidden = true
                    self.waitingIndicator.stopAnimating()
                    self.searchResultsTableView.allowsSelection = false
                    self.refreshControl.endRefreshing()
                    self.searchResultsTableView.reloadData()
                }
                
            })
        }
    }
    
    func searchList(keyword keyword : String, offset : Int, limit : Int) {
//        cleanStates()
        let request : DishListSearchRequest = DishListSearchRequest()
        request.keyword = keyword
        request.offset = offset
        request.limit = limit
        let userLocation = UserContext.instance.userLocation
        //        userLocation.lat = location.0
        //        userLocation.lon = location.1
        request.userLocation = userLocation
        DataAccessor(serviceConfiguration: SearchServiceConfiguration()).searchLists(request) { (searchResponse) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                if let results = searchResponse?.results {
                    self.lists += results
                    self.searchResultsTableView.hidden = false
                    self.waitingIndicator.hidden = true
                    self.waitingIndicator.stopAnimating()
                    self.searchResultsTableView.allowsSelection = true
                    self.refreshControl.endRefreshing()
                    self.searchResultsTableView.reloadData()
//                    self.adjustSearchResultsTableHeight()
//                    self.adjustScrollViewContentHeight()
                }
                
            })
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if selectionBar.scope == "list" {
            return self.lists.count
        } else if selectionBar.scope == "dish" {
            return self.dishes.count
        } else {
            return self.restaurants.count
        }
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            print("section == 1")
        }
        if indexPath.section == 0 {
            print("section == 0")
        }
        if indexPath.section == 2 {
            print("section == 2")
        }
        if indexPath.section == 3 {
            print("section == 3")
        }
        if selectionBar.scope == "list" {
            var cell : ListTableViewCell? = tableView.dequeueReusableCellWithIdentifier("listCell") as? ListTableViewCell
            if cell == nil {
                tableView.registerNib(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "listCell")
                cell = tableView.dequeueReusableCellWithIdentifier("listCell") as? ListTableViewCell
            }
            cell!.model = lists[indexPath.section]
            return cell!
        } else if selectionBar.scope == "dish" {
            
            var cell : OwnerInfoDishTableViewCell? = tableView.dequeueReusableCellWithIdentifier("ownerInfoDishCell") as? OwnerInfoDishTableViewCell
            if cell == nil {
                tableView.registerNib(UINib(nibName: "OwnerInfoDishCell", bundle: nil), forCellReuseIdentifier: "ownerInfoDishCell")
                cell = tableView.dequeueReusableCellWithIdentifier("ownerInfoDishCell") as? OwnerInfoDishTableViewCell
            }
//            var cell : DishTableViewCell? = tableView.dequeueReusableCellWithIdentifier("dishCell") as? DishTableViewCell
//            if cell == nil {
//                tableView.registerNib(UINib(nibName: "DishCell", bundle: nil), forCellReuseIdentifier: "dishCell")
//                cell = tableView.dequeueReusableCellWithIdentifier("dishCell") as? DishTableViewCell
//            }

            let imageDetails = imageForIndexPath(tableView: self.searchResultsTableView, indexPath: indexPath)
            cell?.setUp(dish: self.dishes[indexPath.section], image: imageDetails.image!)
            
            switch (imageDetails.state){
            case PhotoRecordState.New:
                self.searchResultsTableView.startOperationsForPhotoRecord(&pendingOperations, photoDetails: imageDetails,indexPath:indexPath)
            default: break
            }
            return cell!
        } else {
            var cell : RestaurantSearchTableViewCell? = tableView.dequeueReusableCellWithIdentifier("restaurantSearchCell") as? RestaurantSearchTableViewCell
            if cell == nil {
                tableView.registerNib(UINib(nibName: "RestaurantSearchCell", bundle: nil), forCellReuseIdentifier: "restaurantSearchCell")
                cell = tableView.dequeueReusableCellWithIdentifier("restaurantSearchCell") as? RestaurantSearchTableViewCell
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
            return 82
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
    
//    private func adjustSearchResultsTableHeight() {
//        if self.searchResultsTableView.hidden == false {
//            if self.heightConstraint != nil {
//                self.searchResultsTableView.removeConstraint(heightConstraint!)
//            }
//            heightConstraint = NSLayoutConstraint(item: self.searchResultsTableView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute:NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.searchResultsTableView.contentSize.height);
//            heightConstraint!.priority = 1000
//            self.searchResultsTableView.addConstraint(heightConstraint!);
//            self.layoutComplete = false
//            self.view.layoutIfNeeded()
//            self.layoutComplete = true
//        }
//    }
//    
//    private func adjustScrollViewContentHeight () {
//        if self.searchResultsTableView.contentSize.height > self.scrollView.frame.height {
//            self.scrollView.contentSize.height = self.searchResultsTableView.contentSize.height
//        }
//    }
    
    
    func restaurantButtonClicked() {
        clearStates()
        search(0, limit: LIMIT)
    }
    
    func dishButtonPressed() {
        clearStates()
//        self.searchResultsTableView.hidden = true
        search(0, limit: LIMIT)
    }
    
    func listButtonPressed() {
        clearStates()
//        self.searchResultsTableView.hidden = true
        search(0, limit: LIMIT)
    }
    
    func clearStates() {
        self.offset = 0
        self.dishes.removeAll()
        self.restaurants.removeAll()
        self.lists.removeAll()
        self.restaurantImages.removeAll()
        self.dishImages.removeAll()
        self.searchResultsTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let scope = selectionBar.scope
        if scope == "restaurant" {
            let restaurant : Restaurant = self.restaurants[indexPath.section]
            self.performSegueWithIdentifier("showRestaurant", sender: restaurant.id)
            self.searchResultsTableView.deselectRowAtIndexPath(indexPath, animated: true)
        } else if scope == "list" {
            let list : List = self.lists[indexPath.section]
            self.performSegueWithIdentifier("showList", sender: list.id)
            self.searchResultsTableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRestaurant" {
            let restaurantController : RestaurantViewController = segue.destinationViewController as! RestaurantViewController
            restaurantController.restaurantId = sender as? String
        } else if segue.identifier == "showList" {
            let listMemberController : ListMemberViewController = segue.destinationViewController as! ListMemberViewController
            listMemberController.listId = sender as? String
        }
    }
    
    func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        // if last section, add activity indicator
        var resultsCount = 0
        let scope = selectionBar.scope
        if scope == "restaurant" {
            resultsCount = self.restaurants.count
        } else if scope == "list" {
            resultsCount = self.lists.count
        } else if scope == "dish" {
            resultsCount = self.dishes.count
        }
//        print("section = \(section), resultsCount = \(resultsCount)")
        if section == resultsCount - 1 {
            footerView.activityIndicator.startAnimating()
            loadMore()
        }
    }
    
    func loadMore() {
        var resultsCount = 0
        let scope = selectionBar.scope
        if scope == "restaurant" {
            resultsCount = self.restaurants.count
        } else if scope == "list" {
            resultsCount = self.lists.count
        } else if scope == "dish" {
            resultsCount = self.dishes.count
        }
        if resultsCount == offset + LIMIT {
            offset += LIMIT
            search(offset, limit: LIMIT)
        } else {
            footerView.activityIndicator.stopAnimating()
            footerView.activityIndicator.hidden = true
        }
        
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return footerView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        var resultsCount = 0
        let scope = selectionBar.scope
        if scope == "restaurant" {
            resultsCount = self.restaurants.count
        } else if scope == "list" {
            resultsCount = self.lists.count
        } else if scope == "dish" {
            resultsCount = self.dishes.count
        }
        if section == resultsCount - 1 {
            return 30
        } else {
            return 0
        }

        
    }
    
}



