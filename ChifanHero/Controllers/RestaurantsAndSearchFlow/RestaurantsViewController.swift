//
//  RestaurantsViewController.swift
//  Lightning
//
//  Created by Shi Yan on 8/5/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit
import MapKit

let searchContext : SearchContext = SearchContext()

class RestaurantsViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, ARNImageTransitionZoomable, ARNImageTransitionIdentifiable {
    
    var containerViewController : RestaurantsContainerViewController?
    
    @IBOutlet weak var searchResultsTable: UITableView!
    
    @IBOutlet weak var searchBar: UITextField!
    
    var loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    var buckets : [Bucket] = [Bucket]()
    
    fileprivate var isLoadingMore = false
    
    fileprivate var loadedAll = false
    
    var footerView : LoadMoreFooterView?
    
    fileprivate var currentState = CurrentState.browse
    
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
        self.navigationController?.navigationBar.shadowImage = UIImage()
        setDefaultSearchContext()
        configLoadingIndicator()
        setTableViewFooterView()
        self.configureNavigationController()
        addFilterButton()
        configPullToRefresh()
        self.clearTitleForBackBarButtonItem()
    }
    
    fileprivate func setDefaultSearchContext() {
        searchContext.distance = RangeFilter.auto
        searchContext.rating = RatingFilter.none
        searchContext.sort = SortOptions.distance
        searchContext.coordinates = userLocationManager.getLocationInUse()
        searchContext.offSet = 0
    }
    
    fileprivate func configLoadingIndicator() {
        loadingIndicator.color = UIColor.themeOrange()
        loadingIndicator.type = NVActivityIndicatorType.pacman
        loadingIndicator.center = (UIApplication.shared.keyWindow?.center)!
        self.view.addSubview(loadingIndicator)
    }
    
    func setTableViewFooterView() {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30)
        footerView = LoadMoreFooterView(frame: frame)
        footerView?.activityIndicator.backgroundColor = UIColor.groupTableViewBackground
        footerView?.backgroundColor = UIColor.groupTableViewBackground
        footerView?.reset()
        self.searchResultsTable.tableFooterView = footerView
    }
    
    fileprivate func configPullToRefresh() {
        pullRefresher = UIRefreshControl()
        let attribute = [ NSForegroundColorAttributeName: UIColor.lightGray,
                          NSFontAttributeName: UIFont(name: "Arial", size: 14.0)!]
        pullRefresher.attributedTitle = NSAttributedString(string: "正在刷新", attributes: attribute)
        pullRefresher.tintColor = UIColor.lightGray
        //        self.homepageTable.addSubview(pullRefresher)
        pullRefresher.addTarget(self, action: #selector(RestaurantsViewController.refreshData), for: .valueChanged)
        self.searchResultsTable.insertSubview(pullRefresher, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TrackingUtil.trackRestaurantsView()
        performNewSearchIfNeeded(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.animateTransition = false
    }
    
    // MARK - TextField methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        performSegue(withIdentifier: "search", sender: nil)
        return false
    }
    
    
    // MARK - perform search
    func performNewSearchIfNeeded(_ hideCurrentResults : Bool) {
        if searchContext.newSearch || needToRefresh(){
            print("search requested. should do a new search here")
            print("keyword = \(searchContext.keyword ?? "")")
            print("range = \(searchContext.distance)")
            print("rating = \(searchContext.rating)")
            print("sort = \(searchContext.sort)")
            print("address = \(searchContext.address ?? "")")
            if searchContext.keyword != nil || searchContext.address != nil{
                currentState = CurrentState.search
            } else {
                currentState = CurrentState.browse
            }
            
            if hideCurrentResults {
                searchResultsTable.isHidden = true
                loadingIndicator.startAnimation()
            }
            if searchContext.address != nil && searchContext.address != "" {
                LocationHelper.getLocationFromAddress(searchContext.address!, completionHandler: { (location) in
                    OperationQueue.main.addOperation({ 
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
        if currentState == CurrentState.browse && locationChangedSignificantly() {
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
        let distance : CLLocationDistance = currentCLLocation.distance(from: lastCLLocation)
        if distance >= 1600 {
            return true
        } else {
            return false
        }
        
    }
    
    func buildSearchRequest() -> RestaurantSearchV2Request{
        var searchRequest : RestaurantSearchV2Request = RestaurantSearchV2Request()
        if currentState == CurrentState.browse {
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
    
    func search(_ searchRequest : RestaurantSearchV2Request) {
        updateSearchbarAndLocationLabel()
        DataAccessor(serviceConfiguration: SearchServiceConfiguration()).searchRestaurants(searchRequest) { (searchResponse) in
            OperationQueue.main.addOperation({
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
                    self.searchResultsTable.reloadData()
                    self.pullRefresher.endRefreshing()
                    self.searchResultsTable.isHidden = false
                    self.isLoadingMore = false
                    self.loadingIndicator.stopAnimation()
                    self.footerView!.activityIndicator.stopAnimating()
                } else {
                    self.pullRefresher.endRefreshing()
                    self.isLoadingMore = false
                    self.loadingIndicator.stopAnimation()
                    self.footerView!.activityIndicator.stopAnimating()

                }
            })
        }
    }
    
    func buildSort(_ searchRequest : inout RestaurantSearchV2Request) {
        let sortOption = searchContext.sort
        if sortOption == SortOptions.distance {
            searchRequest.sortBy = SortParameter.distance.description
            searchRequest.sortOrder = SortOrder.ascend.description
        } else if sortOption == SortOptions.hotness {
            searchRequest.sortBy = SortParameter.hotness.description
            searchRequest.sortOrder = SortOrder.descend.description
        } else if sortOption == SortOptions.rating {
            searchRequest.sortBy = SortParameter.rating.description
            searchRequest.sortOrder = SortOrder.descend.description
        }
    }
    
    func buildFilter(_ searchRequest : inout RestaurantSearchV2Request) {
        let filters = Filters()
        searchRequest.filters = filters
        let ratingFilter = searchContext.rating
        let rangeFilter = searchContext.distance
        if ratingFilter == RatingFilter.five {
            filters.minRating = 5.0
        } else if ratingFilter == RatingFilter.four {
            filters.minRating = 4.0
        } else if ratingFilter == RatingFilter.fourhalf {
            filters.minRating = 4.5
        } else if ratingFilter == RatingFilter.threehalf {
            filters.minRating = 3.5
        } else if ratingFilter == RatingFilter.three {
            filters.minRating = 3.0
        }
        let range = Range()
        range.center = searchContext.coordinates
        let distance = Distance()
        distance.unit = DistanceUnit.mile.description
        if rangeFilter == RangeFilter.auto {
            distance.value = 30.0
        } else if rangeFilter == RangeFilter.point5{
            distance.value = 0.5
        } else if rangeFilter == RangeFilter.one{
            distance.value = 1.0
        } else if rangeFilter == RangeFilter.five{
            distance.value = 5.0
        } else if rangeFilter == RangeFilter.twenty{
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return buckets.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buckets[section].results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: RestaurantTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "restaurantCell") as? RestaurantTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "RestaurantCell", bundle: nil), forCellReuseIdentifier: "restaurantCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell") as? RestaurantTableViewCell
        }
        cell?.setUp(restaurant: buckets[indexPath.section].results[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = SearchResultsTableViewHeader()
        let header = buckets[section].label
        let source = buckets[section].source
        headerView.title = header
        headerView.source = source
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if buckets[section].label != nil {
            return 40
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return RestaurantTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.groupTableViewBackground
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == buckets.count - 1 {
            return 0.01
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let restaurantSelected: Restaurant = buckets[indexPath.section].results[indexPath.row]
        let selectedCell: RestaurantTableViewCell = tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell
        self.selectedImageView = selectedCell.restaurantImageView
        selectedRestaurantName = selectedCell.nameLabel.text
        selectedRestaurantId = restaurantSelected.id
        if buckets[indexPath.section].source == "google" {
            showRestaurant(restaurantSelected.id!, restaurant: restaurantSelected, isFromGoogleSearch: true)
        } else {
            showRestaurant(restaurantSelected.id!, restaurant: restaurantSelected, isFromGoogleSearch: false)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Mark - Navigation
    func showRestaurant(_ id: String, restaurant: Restaurant, isFromGoogleSearch: Bool) {
        self.animateTransition = true
        let storyboard = UIStoryboard(name: "Restaurant", bundle: nil)
        let restaurantController = storyboard.instantiateViewController(withIdentifier: "RestaurantMainTableViewController") as! RestaurantMainTableViewController
        restaurantController.restaurantImage = self.selectedImageView?.image
        restaurantController.restaurantName = self.selectedRestaurantName
        restaurantController.restaurantId = self.selectedRestaurantId
        restaurantController.parentVCName = self.getId()
        restaurantController.isFromGoogleSearch = isFromGoogleSearch
        if isFromGoogleSearch {
            restaurantController.restaurantFromGoogle = restaurant
        }
        self.navigationController?.pushViewController(restaurantController, animated: true)
    }
    
    // Mark - Pagination
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isKind(of: UITableView.classForCoder()) && scrollView.contentOffset.y > 0.0 {
            let scrollPosition = scrollView.contentSize.height - scrollView.frame.height - scrollView.contentOffset.y
            if scrollPosition < 30 && !self.isLoadingMore {
                if self.loadedAll {
                    footerView?.showFinishMessage()
                } else {
                    self.loadMore()
                }
                
            }
        }
    }
    
    fileprivate func loadMore() {
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
        imageView.isUserInteractionEnabled = false
        //        imageView.frame = self.selectedImageView!.convertRect(self.selectedImageView!.frame, toView: self.view)
        imageView.frame = PositionConverter.getViewAbsoluteFrame(self.selectedImageView!)
        
        return imageView
    }
    
    func presentationCompletionAction(_ completeTransition: Bool) {
        self.selectedImageView?.isHidden = true
    }
    
    func dismissalCompletionAction(_ completeTransition: Bool) {
        self.selectedImageView?.isHidden = false
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
    func openFilter(_ sender: AnyObject) {
        self.containerViewController?.slideMenuController()?.openRight()
    }
    
    
    fileprivate func addFilterButton() {
        let button: UIButton = ButtonUtil.barButtonWithTextAndBorder("筛选", size: CGRect(x: 0, y: 0, width: 80, height: 26))
        button.addTarget(self, action: #selector(RestaurantsViewController.openFilter), for: UIControlEvents.touchUpInside)
        let filterButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = filterButton
    }
    
    fileprivate enum CurrentState {
        case browse
        case search
    }

}
