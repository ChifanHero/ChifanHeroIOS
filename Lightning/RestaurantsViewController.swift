//
//  RestaurantsViewController.swift
//  Lightning
//
//  Created by Shi Yan on 8/5/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit
import PullToMakeSoup

let searchContext : SearchContext = SearchContext()

class RestaurantsViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var containerViewController : RestaurantsContainerViewController?
    
    @IBOutlet weak var searchResultsTable: UITableView!
    
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    @IBOutlet weak var searchBar: UITextField!
    
    let refresher = PullToMakeSoup()
    
    var loadingIndicator = NVActivityIndicatorView(frame: CGRectMake(0, 0, 40, 40))
    
    var buckets : [Bucket] = [Bucket]()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
//        filterButton.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        if self.searchResultsTable.pullToRefresh == nil {
            self.searchResultsTable.addPullToRefresh(refresher) {
                self.refreshData()
            }
        }
        setDefaultSearchContext()
        configLoadingIndicator()
    }
    
    private func setDefaultSearchContext() {
        searchContext.distance = RangeFilter.AUTO
        searchContext.rating = RatingFilter.FOUR
        searchContext.sort = SortOptions.HOTNESS
        searchContext.coordinates = userLocationManager.getLocationInUse()
        searchContext.offSet = 0
    }
    
    private func configLoadingIndicator() {
        loadingIndicator.color = UIColor.themeOrange()
        loadingIndicator.type = NVActivityIndicatorType.Pacman
        loadingIndicator.center = self.view.center
        self.view.addSubview(loadingIndicator)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        print("restaurants view did appear")
        super.viewDidAppear(animated)
        performNewSearchIfNeeded(true)
    }
    
    // MARK - TextField methods
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        performSegueWithIdentifier("search", sender: nil)
        return false
    }
    
    
    // MARK - perform search
    func performNewSearchIfNeeded(hideCurrentResults : Bool) {
        if searchContext.newSearch {
            print("search requested. should do a new search here")
            print("keyword = \(searchContext.keyword)")
            print("range = \(searchContext.distance)")
            print("rating = \(searchContext.rating)")
            print("sort = \(searchContext.sort)")
            print("address = \(searchContext.address)")
            searchContext.newSearch = false
            searchBar.text = searchContext.keyword
            if hideCurrentResults {
                searchResultsTable.hidden = true
                loadingIndicator.startAnimation()
            } 
            if searchContext.address != nil && searchContext.address != "" {
                LocationHelper.getLocationFromAddress(searchContext.address!, completionHandler: { (location) in
                    NSOperationQueue.mainQueue().addOperationWithBlock({ 
                        if location == nil {
                            searchContext.coordinates = userLocationManager.getLocationInUse()
                        } else {
                            searchContext.coordinates = location
                        }
                        let searchRequest : RestaurantSearchV2Request = self.buildSearchRequest()
                        self.search(searchRequest)
                    })
                    
                })
            } else {
                let searchRequest : RestaurantSearchV2Request = self.buildSearchRequest()
                self.search(searchRequest)
            }
            
        } else {
            print("search requested, but no new search needed")
        }
    }
    
    func buildSearchRequest() -> RestaurantSearchV2Request{
        var searchRequest : RestaurantSearchV2Request = RestaurantSearchV2Request()
        searchRequest.keyword = searchContext.keyword
        searchRequest.offset = searchContext.offSet
        searchRequest.limit = searchContext.limit
        buildSort(&searchRequest)
        buildFilter(&searchRequest)
        return searchRequest
    }
    
    func search(searchRequest : RestaurantSearchV2Request) {
        DataAccessor(serviceConfiguration: SearchServiceConfiguration()).searchRestaurants(searchRequest) { (searchResponse) in
            NSOperationQueue.mainQueue().addOperationWithBlock({ 
                if let buckets = searchResponse?.buckets {
                    if searchContext.offSet == 0 {
                        self.buckets.removeAll()
                    }
                    self.buckets += buckets
                    self.searchResultsTable.allowsSelection = true
                    self.searchResultsTable.endRefreshing()
                    self.searchResultsTable.reloadData()
                    self.searchResultsTable.hidden = false
                    self.loadingIndicator.stopAnimation()
                }
            })
        }
    }
    
    func buildSort(inout searchRequest : RestaurantSearchV2Request) {
        let sortOption = searchContext.sort
        if sortOption == SortOptions.DISTANCE {
            searchRequest.sortBy = SortParameter.Distance.description
            searchRequest.sortOrder = SortOrder.Ascend.description
        } else if sortOption == SortOptions.HOTNESS {
            searchRequest.sortBy = SortParameter.Hotness.description
            searchRequest.sortOrder = SortOrder.Descend.description
        } else if sortOption == SortOptions.RATING {
            searchRequest.sortBy = SortParameter.Hotness.description
            searchRequest.sortOrder = SortOrder.Descend.description
        }
    }
    
    func buildFilter(inout searchRequest : RestaurantSearchV2Request) {
        let filters = Filters()
        searchRequest.filters = filters
        let ratingFilter = searchContext.rating
        let rangeFilter = searchContext.distance
        if ratingFilter == RatingFilter.FIVE {
            filters.minRating = 5.0
        } else if ratingFilter == RatingFilter.FOUR {
            filters.minRating = 4.0
        } else if ratingFilter == RatingFilter.FOURHALF {
            filters.minRating = 4.5
        } else if ratingFilter == RatingFilter.THREEHALF {
            filters.minRating = 3.5
        } else if ratingFilter == RatingFilter.THREE {
            filters.minRating = 3.0
        }
        let range = Range()
        range.center = searchContext.coordinates
        let distance = Distance()
        distance.unit = DistanceUnit.MILE.description
        if rangeFilter == RangeFilter.AUTO {
            distance.value = 30.0
        } else if rangeFilter == RangeFilter.POINT5{
            distance.value = 0.5
        } else if rangeFilter == RangeFilter.ONE{
            distance.value = 1.0
        } else if rangeFilter == RangeFilter.FIVE{
            distance.value = 5.0
        } else if rangeFilter == RangeFilter.TWENTY{
            distance.value = 20.0
        }
        range.distance = distance
        filters.range = range
        searchRequest.userLocation = searchContext.coordinates
    }
    
    // MARK - Pull to refresh
    func refreshData() {
        searchContext.offSet = 0
        performNewSearchIfNeeded(false)
    }
    
    // MARK - Pagination
    
    // Mark - UITableViewDelegate, UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return buckets.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buckets[section].results.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: RestaurantTableViewCell? = tableView.dequeueReusableCellWithIdentifier("restaurantCell") as? RestaurantTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "RestaurantCell", bundle: nil), forCellReuseIdentifier: "restaurantCell")
            cell = tableView.dequeueReusableCellWithIdentifier("restaurantCell") as? RestaurantTableViewCell
        }
        cell?.setUp(restaurant: buckets[indexPath.section].results[indexPath.row])
        return cell!
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = SearchResultsTableViewHeader()
        let header = buckets[section].label
        let source = buckets[section].source
        headerView.title = header
        headerView.source = source
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if buckets[section].label != nil {
            return 40
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return RestaurantTableViewCell.height
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        return footerView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section < buckets.count - 1 {
            return 10
        } else {
            return 0.01
        }
        
    }

    
    // Mark - Filter
    @IBAction func openFilter(sender: AnyObject) {
        self.containerViewController?.slideMenuController()?.openRight()
    }

}
