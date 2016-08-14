//
//  RestaurantsViewController.swift
//  Lightning
//
//  Created by Shi Yan on 8/5/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit
import PullToMakeSoup
import MapKit

let searchContext : SearchContext = SearchContext()

class RestaurantsViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, ARNImageTransitionZoomable, ARNImageTransitionIdentifiable {
    
    var containerViewController : RestaurantsContainerViewController?
    
    @IBOutlet weak var searchResultsTable: UITableView!
    
//    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    @IBOutlet weak var searchBar: UITextField!
    
//    let refresher = PullToMakeSoup()
    
    var loadingIndicator = NVActivityIndicatorView(frame: CGRectMake(0, 0, 40, 40))
    
    var buckets : [Bucket] = [Bucket]()
    
    private var isLoadingMore = false
    
    private var loadedAll = false
    
    var footerView : LoadMoreFooterView?
    
    private var currentState = CurrentState.BROWSE
    
    var animateTransition = false
    
    weak var selectedImageView: UIImageView?
    
    var selectedRestaurantName: String?
    
    var selectedRestaurantId: String?
    
    var pullRefresher: UIRefreshControl!
    
    var lastUsedLocation : Location?
    
    @IBOutlet weak var currentLocationLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
//        filterButton.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.shadowImage = UIImage()
//        if self.searchResultsTable.pullToRefresh == nil {
//            self.searchResultsTable.addPullToRefresh(refresher) {
//                self.refreshData()
//            }
//        }
        setDefaultSearchContext()
        configLoadingIndicator()
        setTableViewFooterView()
        self.configureNavigationController()
        addFilterButton()
        configPullToRefresh()
        self.clearTitleForBackBarButtonItem()
    }
    
    private func setDefaultSearchContext() {
        searchContext.distance = RangeFilter.AUTO
        searchContext.rating = RatingFilter.NONE
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
    
    func setTableViewFooterView() {
        let frame = CGRectMake(0, 0, self.view.frame.size.width, 30)
        footerView = LoadMoreFooterView(frame: frame)
        footerView?.activityIndicator.backgroundColor = UIColor.groupTableViewBackgroundColor()
        footerView?.backgroundColor = UIColor.groupTableViewBackgroundColor()
        footerView?.reset()
        self.searchResultsTable.tableFooterView = footerView
    }
    
    func configPullToRefresh() {
        pullRefresher = UIRefreshControl()
        let attribute = [ NSForegroundColorAttributeName: UIColor.lightGrayColor(),
                          NSFontAttributeName: UIFont(name: "Arial", size: 14.0)!]
        pullRefresher.attributedTitle = NSAttributedString(string: "正在刷新", attributes: attribute)
        pullRefresher.tintColor = UIColor.lightGrayColor()
        //        self.homepageTable.addSubview(pullRefresher)
        pullRefresher.addTarget(self, action: #selector(RestaurantsViewController.refreshData), forControlEvents: .ValueChanged)
        self.searchResultsTable.insertSubview(pullRefresher, atIndex: 0)
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.animateTransition = false
    }
    
    // MARK - TextField methods
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        performSegueWithIdentifier("search", sender: nil)
        return false
    }
    
    
    // MARK - perform search
    func performNewSearchIfNeeded(hideCurrentResults : Bool) {
        if searchContext.newSearch || needToRefresh(){
            print("search requested. should do a new search here")
            print("keyword = \(searchContext.keyword)")
            print("range = \(searchContext.distance)")
            print("rating = \(searchContext.rating)")
            print("sort = \(searchContext.sort)")
            print("address = \(searchContext.address)")
            if searchContext.keyword != nil || searchContext.address != nil{
                currentState = CurrentState.SEARCH
            } else {
                currentState = CurrentState.BROWSE
            }
            
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
    
    func needToRefresh() -> Bool {
        if currentState == CurrentState.BROWSE && locationChangedSignificantly() {
            return true
        } else {
            return false
        }
    }
    
    func locationChangedSignificantly() -> Bool {
        let currentLocation = userLocationManager.getLocationInUse()
        if lastUsedLocation == nil || currentLocation == nil {
            return false
        }
        let currentCLLocation = CLLocation(latitude: (currentLocation?.lat)!, longitude: (currentLocation?.lon)!)
        let lastCLLocation = CLLocation(latitude: lastUsedLocation!.lat!, longitude: lastUsedLocation!.lon!)
        let distance : CLLocationDistance = currentCLLocation.distanceFromLocation(lastCLLocation)
        print(distance)
        if distance >= 1600 {
            return true
        } else {
            return false
        }
        
    }
    
    func buildSearchRequest() -> RestaurantSearchV2Request{
        var searchRequest : RestaurantSearchV2Request = RestaurantSearchV2Request()
        if currentState == CurrentState.BROWSE {
            searchContext.coordinates = userLocationManager.getLocationInUse()
            lastUsedLocation = searchContext.coordinates
        }
        searchRequest.keyword = searchContext.keyword
        searchRequest.offset = searchContext.offSet
        searchRequest.limit = searchContext.limit
        buildSort(&searchRequest)
        buildFilter(&searchRequest)
        return searchRequest
    }
    
    func search(searchRequest : RestaurantSearchV2Request) {
        updateSearchbarAndLocationLabel()
        DataAccessor(serviceConfiguration: SearchServiceConfiguration()).searchRestaurants(searchRequest) { (searchResponse) in
            NSOperationQueue.mainQueue().addOperationWithBlock({
                searchContext.newSearch = false
                if let buckets = searchResponse?.buckets {
                    if (buckets.count == 0) {
                        self.loadedAll = true
                    }
                    if searchContext.offSet == 0 {
                        self.footerView?.reset()
                        self.buckets.removeAll()
                    }
                    self.buckets += buckets
                    self.searchResultsTable.allowsSelection = true
                    self.searchResultsTable.endRefreshing()
                    self.searchResultsTable.reloadData()
                    self.pullRefresher.endRefreshing()
                    self.searchResultsTable.hidden = false
                    self.isLoadingMore = false
                    self.loadingIndicator.stopAnimation()
                    self.footerView!.activityIndicator.stopAnimating()
                } else {
                    self.searchResultsTable.endRefreshing()
                    self.pullRefresher.endRefreshing()
                    self.isLoadingMore = false
                    self.loadingIndicator.stopAnimation()
                    self.footerView!.activityIndicator.stopAnimating()

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
            searchRequest.sortBy = SortParameter.Rating.description
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
    
    func updateSearchbarAndLocationLabel() {
        searchBar.text = searchContext.keyword
        var currentLocation = "位置: "
        if searchContext.address != nil {
            currentLocation = currentLocation + searchContext.address!
            currentLocationLabel.text = currentLocation
        } else {
            if let city = userLocationManager.getCityInUse() {
                currentLocation = currentLocation + city.name! + ", " + city.state!
                currentLocationLabel.text = currentLocation
            } else {
                LocationHelper.getStreetAddressFromLocation((searchContext.coordinates?.lat)!, lon: (searchContext.coordinates?.lon)!, completionHandler: { (street) in
                    currentLocation = currentLocation + "当前位置(\(street))"
                    self.currentLocationLabel.text = currentLocation
                })
                
            }
        }
        
    }
    
    // MARK - Pull to refresh
    func refreshData() {
        searchContext.offSet = 0
        searchContext.coordinates = userLocationManager.getLocationInUse()
        performNewSearchIfNeeded(false)
    }
    
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
        if section == buckets.count - 1 {
            return 0.01
        } else {
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let restaurantSelected : Restaurant = buckets[indexPath.section].results[indexPath.row]
        let selectedCell : RestaurantTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! RestaurantTableViewCell
        self.selectedImageView = selectedCell.restaurantImageView
        selectedRestaurantName = selectedCell.nameLabel.text
        selectedRestaurantId = restaurantSelected.id
        showRestaurant(restaurantSelected.id!)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        performSegueWithIdentifier("showRestaurant", sender: restaurantSelected.id)
    }
    
    // Mark - Navigation
    func showRestaurant(id : String) {
        self.animateTransition = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let restaurantController = storyboard.instantiateViewControllerWithIdentifier("RestaurantViewController") as! RestaurantViewController
        restaurantController.restaurantImage = self.selectedImageView?.image
        restaurantController.restaurantName = self.selectedRestaurantName
        restaurantController.restaurantId = self.selectedRestaurantId
        restaurantController.parentVCName = self.getId()
        self.navigationController?.pushViewController(restaurantController, animated: true)
    }
    
    // Mark - Pagination
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.isKindOfClass(UITableView.classForCoder()) && scrollView.contentOffset.y > 0.0 {
            let scrollPosition = scrollView.contentSize.height - CGRectGetHeight(scrollView.frame) - scrollView.contentOffset.y
            if scrollPosition < 30 && !self.isLoadingMore {
                if self.loadedAll {
                    footerView?.showFinishMessage()
                } else {
                    self.loadMore()
                }
                
            }
        }
    }
    
    private func loadMore() {
        isLoadingMore = true
        footerView?.activityIndicator.startAnimating()
        searchContext.offSet = searchContext.offSet! + searchContext.limit
        performNewSearchIfNeeded(false)
    }
    
    // MARK: - ARNImageTransitionZoomable
    
    func createTransitionImageView() -> UIImageView {
        let imageView = UIImageView(image: self.selectedImageView!.image)
        imageView.contentMode = self.selectedImageView!.contentMode
        imageView.clipsToBounds = true
        imageView.userInteractionEnabled = false
        //        imageView.frame = self.selectedImageView!.convertRect(self.selectedImageView!.frame, toView: self.view)
        imageView.frame = PositionConverter.getViewAbsoluteFrame(self.selectedImageView!)
        
        return imageView
    }
    
    func presentationCompletionAction(completeTransition: Bool) {
        self.selectedImageView?.hidden = true
    }
    
    func dismissalCompletionAction(completeTransition: Bool) {
        self.selectedImageView?.hidden = false
    }
    
    func usingAnimatedTransition() -> Bool {
        return animateTransition
    }
    
    func getId() -> String {
        return "RestaurantsViewController"
    }
    
    func getDirectAncestorId() -> String {
        return ""
    }

    
    // Mark - Filter
    func openFilter(sender: AnyObject) {
        self.containerViewController?.slideMenuController()?.openRight()
    }
    
    
    func addFilterButton() {
        let button: UIButton = UIButton.barButtonWithTextAndBorder("筛选", size: CGRectMake(0, 0, 80, 26))
        button.addTarget(self, action: #selector(RestaurantsViewController.openFilter), forControlEvents: UIControlEvents.TouchUpInside)
        let filterButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = filterButton
    }
    
    private enum CurrentState {
        case BROWSE
        case SEARCH
    }

}
