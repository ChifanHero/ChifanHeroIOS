//
//  RestaurantsViewController.swift
//  Lightning
//
//  Created by Shi Yan on 8/5/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit
import MapKit

let searchContext: SearchContext = SearchContext()

class RestaurantsViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, ARNImageTransitionZoomable, ARNImageTransitionIdentifiable {
    
    @IBOutlet weak var searchResultsTable: UITableView!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var currentLocationLabel: UILabel!
    
    var containerViewController: RestaurantsContainerViewController?
    
    var loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    var restaurants: [Restaurant] = []
    
    private var currentState = CurrentState.browse
    
    var animateTransition = false
    
    weak var selectedImageView: UIImageView?
    
    var selectedRestaurantName: String?
    
    var pullRefresher: UIRefreshControl!
    
    var lastUsedLocation: Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.setDefaultSearchContext()
        self.configLoadingIndicator()
        self.configureNavigationController()
        self.addFilterButton()
        self.configPullToRefresh()
        self.clearTitleForBackBarButtonItem()
        self.searchResultsTable.register(UINib(nibName: "RestaurantCell", bundle: nil), forCellReuseIdentifier: "restaurantCell")
    }
    
    private func setDefaultSearchContext() {
        searchContext.distance = RangeFilter.auto
        searchContext.rating = RatingFilter.none
        searchContext.sort = SortOptions.distance
        searchContext.coordinates = userLocationManager.getLocationInUse()
    }
    
    private func configLoadingIndicator() {
        loadingIndicator.color = UIColor.themeOrange()
        loadingIndicator.type = NVActivityIndicatorType.pacman
        loadingIndicator.center = (UIApplication.shared.keyWindow?.center)!
        self.view.addSubview(loadingIndicator)
    }
    
    private func configPullToRefresh() {
        pullRefresher = UIRefreshControl()
        let attribute = [ NSForegroundColorAttributeName: UIColor.lightGray,
                          NSFontAttributeName: UIFont(name: "Arial", size: 14.0)!]
        pullRefresher.attributedTitle = NSAttributedString(string: "正在刷新", attributes: attribute)
        pullRefresher.tintColor = UIColor.lightGray
        pullRefresher.addTarget(self, action: #selector(RestaurantsViewController.refreshData), for: .valueChanged)
        self.searchResultsTable.insertSubview(pullRefresher, at: 0)
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
                        let searchRequest: RestaurantSearchV2Request = self.buildSearchRequest()
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
    
    private func needToRefresh() -> Bool {
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
        let distance: CLLocationDistance = currentCLLocation.distance(from: lastCLLocation)
        if distance >= 1600 {
            return true
        } else {
            return false
        }
    }
    
    private func buildSearchRequest() -> RestaurantSearchV2Request{
        var searchRequest: RestaurantSearchV2Request = RestaurantSearchV2Request()
        if currentState == CurrentState.browse {
            searchContext.coordinates = userLocationManager.getLocationInUse()
            lastUsedLocation = searchContext.coordinates
        }
        buildSort(&searchRequest)
        buildFilter(&searchRequest)
        return searchRequest
    }
    
    private func search(_ searchRequest: RestaurantSearchV2Request) {
        updateSearchbarAndLocationLabel()
        DataAccessor(serviceConfiguration: SearchServiceConfiguration()).searchRestaurants(searchRequest) { (searchResponse) in
            OperationQueue.main.addOperation({
                searchContext.newSearch = false
                self.restaurants = searchResponse?.results ?? []
                self.searchResultsTable.allowsSelection = true
                self.searchResultsTable.reloadData()
                self.searchResultsTable.isHidden = false
                self.pullRefresher.endRefreshing()
                self.loadingIndicator.stopAnimation()
            })
        }
    }
    
    private func buildSort(_ searchRequest: inout RestaurantSearchV2Request) {
        let sortOption = searchContext.sort
        if sortOption == SortOptions.distance {
            searchRequest.order = "nearest"
        } else if sortOption == SortOptions.hotness {
            searchRequest.order = "hottest"
        } else if sortOption == SortOptions.rating {
            
        }
    }
    
    private func buildFilter(_ searchRequest: inout RestaurantSearchV2Request) {
        let ratingFilter = searchContext.rating
        let rangeFilter = searchContext.distance
        if ratingFilter == RatingFilter.five {
            searchRequest.rating = 5.0
        } else if ratingFilter == RatingFilter.four {
            searchRequest.rating = 4.0
        } else if ratingFilter == RatingFilter.fourhalf {
            searchRequest.rating = 4.5
        } else if ratingFilter == RatingFilter.threehalf {
            searchRequest.rating = 3.5
        } else if ratingFilter == RatingFilter.three {
            searchRequest.rating = 3.0
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
        searchRequest.range = range
        searchRequest.keyword = searchContext.keyword
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
        searchContext.coordinates = userLocationManager.getLocationInUse()
        performNewSearchIfNeeded(false)
    }
    
    // Mark - UITableViewDelegate, UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RestaurantTableViewCell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell") as! RestaurantTableViewCell
        cell.setUp(restaurant: restaurants[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UINib(
            nibName: "SearchResultsTableViewHeader",
            bundle: nil
            ).instantiate(withOwner: nil, options: nil).first as! SearchResultsTableViewHeader
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return RestaurantTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.groupTableViewBackground
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let restaurantSelected: Restaurant = restaurants[indexPath.row]
        let selectedCell: RestaurantTableViewCell = tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell
        self.selectedImageView = selectedCell.restaurantImageView
        selectedRestaurantName = selectedCell.nameLabel.text
        showRestaurant(restaurantSelected.id!, restaurant: restaurantSelected)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Mark - Navigation
    func showRestaurant(_ id: String, restaurant: Restaurant) {
        self.animateTransition = true
        let storyboard = UIStoryboard(name: "Restaurant", bundle: nil)
        let restaurantController = storyboard.instantiateViewController(withIdentifier: "RestaurantMainTableViewController") as! RestaurantMainTableViewController
        restaurantController.restaurantImage = self.selectedImageView?.image
        restaurantController.restaurantId = id
        restaurantController.currentLocation = self.lastUsedLocation
        restaurantController.parentVCName = self.getId()
        self.navigationController?.pushViewController(restaurantController, animated: true)
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
    
    private func addFilterButton() {
        let button: UIButton = ButtonUtil.barButtonWithTextAndBorder("筛选", size: CGRect(x: 0, y: 0, width: 80, height: 26))
        button.addTarget(self, action: #selector(RestaurantsViewController.openFilter), for: UIControlEvents.touchUpInside)
        let filterButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = filterButton
    }
    
    private enum CurrentState {
        case browse
        case search
    }

}
