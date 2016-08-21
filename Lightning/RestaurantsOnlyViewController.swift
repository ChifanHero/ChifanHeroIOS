//
//  RestaurantsTableViewController.swift
//  Lightning
//
//  Created by Shi Yan on 8/20/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import UIKit

class RestaurantsOnlyViewController: RefreshableViewController, UITableViewDataSource, UITableViewDelegate, ARNImageTransitionZoomable, ARNImageTransitionIdentifiable {
    
    @IBOutlet var restaurantsTable: UITableView!
    
    private var request: GetRestaurantsRequest = GetRestaurantsRequest()
    
    var animateTransition = false
    
    weak var selectedImageView: UIImageView?
    
    var selectedRestaurantName: String?
    
    var selectedRestaurantId: String?
    
    var restaurants: [Restaurant] = []
    
    var loadMoreIndicator : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    var footerView : LoadMoreFooterView?
    
    var ratingAndFavoriteExecutor: RatingAndBookmarkExecutor?
    
    var isLoadingMore = false
    
    var pullRefresher: UIRefreshControl!
    
    var loadingIndicator = NVActivityIndicatorView(frame: CGRectMake(0, 0, 40, 40))
    
    var isFromBookMark = false {
        didSet {
            if isFromBookMark == true {
                self.navigationItem.title = "我的餐厅"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addImageForBackBarButtonItem()
        self.clearTitleForBackBarButtonItem()
        self.configLoadingIndicator()
        self.configPullToRefresh()
        self.restaurantsTable.delegate = self
        self.restaurantsTable.dataSource = self
        self.restaurantsTable.hidden = true
        setTableViewFooterView()
        firstLoadData()
        ratingAndFavoriteExecutor = RatingAndBookmarkExecutor(baseVC: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.animateTransition = false
        let selectedCellIndexPath : NSIndexPath? = self.restaurantsTable.indexPathForSelectedRow
        if selectedCellIndexPath != nil {
            self.restaurantsTable.deselectRowAtIndexPath(selectedCellIndexPath!, animated: false)
        }
        //        setTabBarVisible(false, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        TrackingUtil.trackRestaurantsView()
    }
    
    private func configPullToRefresh() {
        pullRefresher = UIRefreshControl()
        let attribute = [ NSForegroundColorAttributeName: UIColor.lightGrayColor(),
                          NSFontAttributeName: UIFont(name: "Arial", size: 14.0)!]
        pullRefresher.attributedTitle = NSAttributedString(string: "正在刷新", attributes: attribute)
        pullRefresher.tintColor = UIColor.lightGrayColor()
        pullRefresher.addTarget(self, action: #selector(RestaurantsOnlyViewController.refreshData), forControlEvents: .ValueChanged)
        self.restaurantsTable.insertSubview(pullRefresher, atIndex: 0)
    }
    
    private func configLoadingIndicator() {
        loadingIndicator.color = UIColor.themeOrange()
        loadingIndicator.type = NVActivityIndicatorType.Pacman
        loadingIndicator.center = (UIApplication.sharedApplication().keyWindow?.center)!
        self.view.addSubview(loadingIndicator)
    }
    
    func setTableViewFooterView() {
        let frame = CGRectMake(0, 0, self.view.frame.size.width, 30)
        footerView = LoadMoreFooterView(frame: frame)
        footerView?.reset()
        self.restaurantsTable.tableFooterView = footerView
    }
    
    override func refreshData() {
        request.limit = 50
        request.skip = 0
        footerView?.reset()
        let location = userLocationManager.getLocationInUse()
        if (location == nil || location!.lat == nil || location!.lon == nil) {
            return
        }
        request.userLocation = location
        loadData(nil)
    }
    
    func firstLoadData() {
        request.limit = 50
        request.skip = 0
        footerView?.reset()
        let location = userLocationManager.getLocationInUse()
        if (location == nil || location!.lat == nil || location!.lon == nil) {
            return
        }
        loadingIndicator.startAnimation()
        request.userLocation = location
        loadData { (success) -> Void in
            if !success {
                self.noNetworkDefaultView.show()
            }
        }
    }
    
    func clearData() {
        self.restaurants.removeAll()
    }
    
    override func loadData(refreshHandler: ((success: Bool) -> Void)?) {
        
        if isFromBookMark == true {
            let request: GetFavoritesRequest = GetFavoritesRequest(type: FavoriteTypeEnum.Restaurant)
            let location = userLocationManager.getLocationInUse()
            request.lat = location!.lat
            request.lon = location!.lon
            DataAccessor(serviceConfiguration: ParseConfiguration()).getFavorites(request) { (response) -> Void in
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.clearData()
                    for index in 0..<(response?.results)!.count {
                        self.restaurants.append((response?.results)![index].restaurant!)
                    }
                    if self.restaurants.count > 0 && self.restaurantsTable.hidden == true{
                        self.restaurantsTable.hidden = false
                    }
                    self.loadingIndicator.stopAnimation()
                    self.footerView!.activityIndicator.stopAnimating()
                    self.restaurantsTable.reloadData()
                    self.pullRefresher.endRefreshing()
                });
            }
        } else {
            DataAccessor(serviceConfiguration: ParseConfiguration()).getRestaurants(request) { (response) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    if response == nil {
                        if refreshHandler != nil {
                            refreshHandler!(success: false)
                        }
                        self.pullRefresher.endRefreshing()
                        self.loadingIndicator.stopAnimation()
                        self.footerView!.activityIndicator.stopAnimating()
                    } else {
                        if self.request.skip == 0 {
                            self.clearData()
                        }
                        self.loadResults(response?.results)
                        if self.restaurants.count > 0 && self.restaurantsTable.hidden == true{
                            self.restaurantsTable.hidden = false
                        }
                        self.pullRefresher.endRefreshing()
                        self.loadingIndicator.stopAnimation()
                        self.footerView!.activityIndicator.stopAnimating()
                        self.restaurantsTable.reloadData()
                        if refreshHandler != nil {
                            refreshHandler!(success: true)
                        }
                        
                    }
                    self.isLoadingMore = false
                    
                });
            }
        }
    }
    
    func loadResults(results : [Restaurant]?) {
        if results != nil {
            for restaurant in results! {
                self.restaurants.append(restaurant)
            }
        }
    }
    
    
    @objc private func refresh(sender:AnyObject) {
        refreshData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return RestaurantTableViewCell.height
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return restaurants.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: RestaurantTableViewCell? = tableView.dequeueReusableCellWithIdentifier("restaurantCell") as? RestaurantTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "RestaurantCell", bundle: nil), forCellReuseIdentifier: "restaurantCell")
            cell = tableView.dequeueReusableCellWithIdentifier("restaurantCell") as? RestaurantTableViewCell
        }
        cell?.setUp(restaurant: restaurants[indexPath.row])
        return cell!
    }
    
    func needToLoadMore() -> Bool {
        if self.restaurants.count == (request.skip)! + (request.limit)! {
            return true
        } else {
            return false
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let restaurantSelected : Restaurant = restaurants[indexPath.row]
        let selectedCell : RestaurantTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! RestaurantTableViewCell
        self.selectedImageView = selectedCell.restaurantImageView
        selectedRestaurantName = selectedCell.nameLabel.text
        selectedRestaurantId = restaurantSelected.id
        self.animateTransition = true
        performSegueWithIdentifier("showRestaurant", sender: restaurantSelected.id)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRestaurant" {
            let restaurantController : RestaurantMainTableViewController = segue.destinationViewController as! RestaurantMainTableViewController
            restaurantController.restaurantId = sender as? String
            restaurantController.restaurantImage = self.selectedImageView?.image
            restaurantController.restaurantName = self.selectedRestaurantName
            restaurantController.parentVCName = self.getId()
        }
    }
    
    private func loadMore() {
        request.skip = (request.skip)! + (request.limit)!
        isLoadingMore = true
        footerView?.activityIndicator.startAnimating()
        loadData(nil)
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let restaurant: Restaurant = self.restaurants[indexPath.row]
        let objectId = restaurant.id
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "删除", handler:{(action, indexpath) -> Void in
            
            let request = RemoveFavoriteRequest()
            request.type = "restaurant"
            request.objectId = objectId
            DataAccessor(serviceConfiguration: ParseConfiguration()).removeFavorite(request) { (response) -> Void in
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    
                });
            }
            
            self.restaurantsTable.beginUpdates()
            self.restaurants.removeAtIndex(indexPath.row)
            self.restaurantsTable.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.restaurantsTable.endUpdates()
            
        });
        
        return [deleteAction];
    }
    
    private func popupSigninAlert() {
        SCLAlertView().showWarning("请登录", subTitle: "登录享受更多便利")
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
        return "RestaurantsOnlyViewController"
    }
    
    func getDirectAncestorId() -> String {
        return ""
    }
    
}

