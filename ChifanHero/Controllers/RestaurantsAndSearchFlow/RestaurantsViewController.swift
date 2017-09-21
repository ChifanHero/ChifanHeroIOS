//
//  RestaurantsViewController.swift
//  Lightning
//
//  Created by Shi Yan on 8/5/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit
import MapKit

class RestaurantsViewController: AutoNetworkCheckViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, ARNImageTransitionZoomable, ARNImageTransitionIdentifiable {
    
    @IBOutlet weak var searchResultsTable: UITableView!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var currentLocationLabel: UILabel!
    
    var containerViewController: RestaurantsContainerViewController?
    
    var restaurants: [Restaurant] = []
    
    private var currentState = CurrentState.browse
    
    var animateTransition = false
    
    weak var selectedImageView: UIImageView?
    
    var selectedRestaurantName: String?
    
    var lastUsedLocation: Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.setDefaultSearchContext()
        self.configureNavigationController()
        self.addFilterButton()
        self.configPullToRefresh()
        self.clearTitleForBackBarButtonItem()
        self.searchResultsTable.register(UINib(nibName: "RestaurantCell", bundle: nil), forCellReuseIdentifier: "restaurantCell")
        self.searchResultsTable.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TrackingUtil.trackRestaurantsView()
        self.loadingIndicator.startAnimation()
        self.refreshData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.animateTransition = false
    }
    
    private func setDefaultSearchContext() {
        SearchContext.distance = RangeFilter.auto
        SearchContext.rating = RatingFilter.none
        SearchContext.sort = SortOptions.distance
        SearchContext.coordinates = userLocationManager.getLocationInUse()
    }
    
    private func configPullToRefresh() {
        pullRefresher.addTarget(self, action: #selector(self.pullToRefreshData), for: .valueChanged)
        self.searchResultsTable.insertSubview(pullRefresher, at: 0)
    }
    
    // MARK - TextField methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        performSegue(withIdentifier: "search", sender: nil)
        return false
    }
    
    // MARK - perform search
    
    // Launch a new search if needed
    override func loadData() {
        if SearchContext.newSearch || needToRefresh(){
            log.debug("Search requested. Will perform a new search")
            if SearchContext.keyword != nil || SearchContext.address != nil{
                currentState = CurrentState.search
            } else {
                currentState = CurrentState.browse
            }
            
            if SearchContext.address != nil && SearchContext.address != "" {
                LocationHelper.getLocationFromAddress(SearchContext.address!, completionHandler: { (location) in
                    if location == nil {
                        SearchContext.coordinates = userLocationManager.getLocationInUse()
                    } else {
                        SearchContext.coordinates = location
                    }
                    let searchRequest: RestaurantSearchV2Request = self.buildSearchRequest()
                    self.search(searchRequest)
                })
            } else {
                let searchRequest : RestaurantSearchV2Request = self.buildSearchRequest()
                self.search(searchRequest)
            }
            
        } else {
            log.debug("Search requested. But no new search needed")
            self.pullRefresher.endRefreshing()
            self.loadingIndicator.stopAnimation()
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
            SearchContext.coordinates = userLocationManager.getLocationInUse()
            lastUsedLocation = SearchContext.coordinates
        }
        buildSort(&searchRequest)
        buildFilter(&searchRequest)
        buildOpen(&searchRequest)
        return searchRequest
    }
    
    private func search(_ searchRequest: RestaurantSearchV2Request) {
        updateSearchbarAndLocationLabel()
        DataAccessor(serviceConfiguration: SearchServiceConfiguration()).searchRestaurants(searchRequest) { (searchResponse) in
            OperationQueue.main.addOperation({
                SearchContext.newSearch = false
                self.restaurants = searchResponse?.results ?? []
                self.searchResultsTable.allowsSelection = true
                self.searchResultsTable.reloadData()
                self.pullRefresher.endRefreshing()
                self.loadingIndicator.stopAnimation()
            })
        }
    }
    
    private func buildOpen(_ searchRequest: inout RestaurantSearchV2Request) {
        searchRequest.open = SearchContext.open
    }
    
    private func buildSort(_ searchRequest: inout RestaurantSearchV2Request) {
        let sortOption = SearchContext.sort
        if sortOption == SortOptions.distance {
            searchRequest.order = "nearest"
        } else if sortOption == SortOptions.hotness {
            
        } else if sortOption == SortOptions.rating {
            searchRequest.order = "rating"
        }
    }
    
    private func buildFilter(_ searchRequest: inout RestaurantSearchV2Request) {
        let ratingFilter = SearchContext.rating
        let rangeFilter = SearchContext.distance
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
        range.center = SearchContext.coordinates
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
        searchRequest.keyword = SearchContext.keyword
    }
    
    func updateSearchbarAndLocationLabel() {
        searchBar.text = SearchContext.keyword
        var currentLocation = "位置: "
        if SearchContext.address != nil {
            currentLocation = currentLocation + SearchContext.address!
            currentLocationLabel.text = currentLocation
        } else {
            if let city = userLocationManager.getCityInUse() {
                currentLocation = currentLocation + city.name! + ", " + city.state!
                currentLocationLabel.text = currentLocation
            } else {
                LocationHelper.getStreetAddressFromLocation((SearchContext.coordinates?.lat)!, lon: (SearchContext.coordinates?.lon)!, completionHandler: { (street) in
                    currentLocation = currentLocation + "当前位置(\(street))"
                    self.currentLocationLabel.text = currentLocation
                })
                
            }
        }
        
    }
    
    // MARK - Pull to refresh
    func pullToRefreshData() {
        SearchContext.coordinates = userLocationManager.getLocationInUse()
        self.refreshData()
    }
    
    override func refreshData() {
        super.refreshData()
    }
    
    // Mark - UITableViewDelegate, UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell") as! RestaurantTableViewCell
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
