//
//  RestaurantsTableViewController.swift
//  Lightning
//
//  Created by Shi Yan on 8/20/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import UIKit
import Kingfisher
import PullToMakeSoup

class RestaurantsViewController: RefreshableViewController, UITableViewDataSource, UITableViewDelegate, ARNImageTransitionZoomable {
    
    @IBOutlet var restaurantsTable: UITableView!
    
    private var request: GetRestaurantsRequest = GetRestaurantsRequest()
    
    var animateTransition = false
    
    weak var selectedImageView: UIImageView?
    
    var selectedRestaurantName: String?
    
    var selectedRestaurantId: String?
    
    var sortBy: String? {
        didSet {
            if isFromBookMark == false {
                if sortBy == "hottest" {
                    request.sortBy = SortParameter.Hotness
                    request.sortOrder = SortOrder.Descend
                    self.navigationItem.title = "热门餐厅"
                } else {
                    request.sortBy = SortParameter.Distance
                    request.sortOrder = SortOrder.Ascend
                    self.navigationItem.title = "离我最近"
                }
            }
        }
    }
    
    var restaurants: [Restaurant] = []
    
    var loadMoreIndicator : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    var footerView : LoadMoreFooterView?
    
    var ratingAndFavoriteExecutor: RatingAndBookmarkExecutor?
    
    var isLoadingMore = false
    
    let refresher = PullToMakeSoup()
    
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
        clearTitleForBackBarButtonItem()
        configLoadingIndicator()
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
        self.restaurantsTable.addPullToRefresh(refresher) {
            self.refreshData()
        }
        TrackingUtil.trackRestaurantsView()
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
        footerView?.reset()
        self.restaurantsTable.tableFooterView = footerView
    }
    
    override func refreshData() {
        request.limit = 50
        request.skip = 0
        footerView?.reset()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let location = appDelegate.getCurrentLocation()
        if (location.lat == nil || location.lon == nil) {
            return
        }
        request.userLocation = location
        loadData(nil)
    }
    
    func firstLoadData() {
        request.limit = 50
        request.skip = 0
        footerView?.reset()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let location = appDelegate.getCurrentLocation()
        if (location.lat == nil || location.lon == nil) {
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
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let location = appDelegate.getCurrentLocation()
            request.lat = location.lat
            request.lon = location.lon
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
                    self.restaurantsTable.endRefreshing()
                });
            }
        } else {
            DataAccessor(serviceConfiguration: ParseConfiguration()).getRestaurants(request) { (response) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    if response == nil {
                        if refreshHandler != nil {
                            refreshHandler!(success: false)
                        }
                        self.restaurantsTable.endRefreshing()
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
                        self.restaurantsTable.endRefreshing()
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
            let restaurantController : RestaurantViewController = segue.destinationViewController as! RestaurantViewController
            restaurantController.restaurantId = sender as? String
            restaurantController.restaurantImage = self.selectedImageView?.image
            restaurantController.restaurantName = self.selectedRestaurantName
        }
    }
    
    private func loadMore() {
        request.skip = (request.skip)! + (request.limit)!
        isLoadingMore = true
        footerView?.activityIndicator.startAnimating()
        loadData(nil)
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let restaurant : Restaurant = self.restaurants[indexPath.row]
        var favoriteCount : Int = 0
        var likeCount : Int = 0
        var neutralCount : Int = 0
        var dislikeCount : Int = 0
        let objectId = restaurant.id
        if restaurant.favoriteCount != nil {
            favoriteCount = restaurant.favoriteCount!
        }
        if restaurant.likeCount != nil {
            likeCount = restaurant.likeCount!
        }
        if restaurant.neutralCount != nil {
            neutralCount = restaurant.neutralCount!
        }
        if restaurant.dislikeCount != nil {
            dislikeCount = restaurant.dislikeCount!
        }
        
        let addBookmarkAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: CellActionTitle.bookMark(favoriteCount), handler:{(action, indexpath) -> Void in
            favoriteCount += 1
            if restaurant.favoriteCount == nil {
                restaurant.favoriteCount = 1
            } else {
                restaurant.favoriteCount! += 1
            }
            self.restaurantsTable.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView(CellActionTitle.bookMark(favoriteCount), index: 0)
            self.addToFavorites(indexPath)
            self.dismissActionViewWithDelay()
        });
        addBookmarkAction.backgroundColor = LightningColor.bookMarkYellow()
        
        let likeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: CellActionTitle.positive(likeCount), handler:{(action, indexpath) -> Void in
            if (UserContext.isRatingTooFrequent(objectId!)) {
                JSSAlertView().warning(self, title: "评价太频繁")
            } else {
                likeCount += 1
                if restaurant.likeCount == nil {
                    restaurant.likeCount = 1
                } else {
                    restaurant.likeCount! += 1
                }
                self.restaurantsTable.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView(CellActionTitle.positive(likeCount), index: 3)
                self.rateRestaurant(indexPath, ratingType: RatingTypeEnum.like)
            }
            self.dismissActionViewWithDelay()
        });
        likeAction.backgroundColor = LightningColor.likeBackground()
        
        let neutralAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: CellActionTitle.neutral(neutralCount), handler:{(action, indexpath) -> Void in
            if (UserContext.isRatingTooFrequent(objectId!)) {
                JSSAlertView().warning(self, title: "评价太频繁")
            } else {
                neutralCount += 1
                if restaurant.neutralCount == nil {
                    restaurant.neutralCount = 1
                } else {
                    restaurant.neutralCount! += 1
                }
                action.title = "一般\n\(neutralCount)"
                self.restaurantsTable.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView(CellActionTitle.neutral(neutralCount), index: 2)
                self.rateRestaurant(indexPath, ratingType: RatingTypeEnum.neutral)
            }
            self.dismissActionViewWithDelay()
        });
        neutralAction.backgroundColor = LightningColor.neutralOrange()
        
        let dislikeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: CellActionTitle.negative(dislikeCount), handler:{(action, indexpath) -> Void in
            if (UserContext.isRatingTooFrequent(objectId!)) {
                JSSAlertView().warning(self, title: "评价太频繁")
            } else {
                dislikeCount += 1
                if restaurant.dislikeCount == nil {
                    restaurant.dislikeCount = 1
                } else {
                    restaurant.dislikeCount! += 1
                }
                self.restaurantsTable.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView(CellActionTitle.negative(dislikeCount), index: 1)
                self.rateRestaurant(indexPath, ratingType: RatingTypeEnum.dislike)
            }
            self.dismissActionViewWithDelay()
        });
        dislikeAction.backgroundColor = LightningColor.negativeBlue()
        
        
        return [addBookmarkAction, dislikeAction, neutralAction, likeAction];
    }
    
    private func popupSigninAlert() {
        let alertview = JSSAlertView().show(self, title: "请登录", text: nil, buttonText: "我知道了")
        alertview.setTextTheme(.Dark)
    }
    
    private func dismissActionViewWithDelay() {
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(RestaurantsViewController.dismissActionView), userInfo: nil, repeats: false)
    }
    
    @objc private func dismissActionView() {
        self.restaurantsTable.setEditing(false, animated: true)
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(RestaurantsViewController.reloadTable), userInfo: nil, repeats: false)
    }
    
    @objc private func reloadTable() {
        self.restaurantsTable.reloadData()
    }
    
    private func addToFavorites(indexPath: NSIndexPath){
        let restaurant = self.restaurants[indexPath.row]
        ratingAndFavoriteExecutor?.addToFavorites("restaurant", objectId: restaurant.id!, failureHandler: { (objectId) -> Void in
            for restaurant : Restaurant in self.restaurants {
                if restaurant.id == objectId {
                    if restaurant.favoriteCount != nil {
                        restaurant.favoriteCount! -= 1
                    }
                }
            }
        })
    }
    
    private func rateRestaurant(indexPath: NSIndexPath, ratingType: RatingTypeEnum){
        
        let objectId: String? = restaurants[indexPath.row].id
        let type = "restaurant"
        
        if ratingType == RatingTypeEnum.like {
            ratingAndFavoriteExecutor?.like(type, objectId: objectId!, failureHandler: { (objectId) -> Void in
                for restaurant : Restaurant in self.restaurants {
                    if restaurant.id == objectId {
                        if restaurant.likeCount != nil {
                            restaurant.likeCount! -= 1
                        }
                    }
                }
            })
        } else if ratingType == RatingTypeEnum.dislike {
            ratingAndFavoriteExecutor?.dislike(type, objectId: objectId!,failureHandler: { (objectId) -> Void in
                for restaurant : Restaurant in self.restaurants {
                    if restaurant.id == objectId {
                        if restaurant.dislikeCount != nil {
                            restaurant.dislikeCount! -= 1
                        }
                    }
                }
            })
        } else {
            ratingAndFavoriteExecutor?.neutral(type, objectId: objectId!,failureHandler: { (objectId) -> Void in
                for restaurant : Restaurant in self.restaurants {
                    if restaurant.id == objectId {
                        if restaurant.neutralCount != nil {
                            restaurant.neutralCount! -= 1
                        }
                    }
                }
            })
        }

    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.isKindOfClass(UITableView.classForCoder()) && scrollView.contentOffset.y > 0.0 {
            let scrollPosition = scrollView.contentSize.height - CGRectGetHeight(scrollView.frame) - scrollView.contentOffset.y
            if scrollPosition < 30 && !self.isLoadingMore {
                if self.needToLoadMore() {
                    self.loadMore()
                } else {
                    footerView?.showFinishMessage()
                }
                
            }
        }
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

}

