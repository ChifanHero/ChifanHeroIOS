//
//  RestaurantsTableViewController.swift
//  Lightning
//
//  Created by Shi Yan on 8/20/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import UIKit

class RestaurantsTableViewController: UITableViewController, ImageProgressiveTableViewDelegate {
    
    @IBOutlet var restaurantsTable: ImageProgressiveTableView!
    
    private var request : GetRestaurantsRequest?
    
    var sortBy : String?
    
    var restaurants : [Restaurant] = []
    
    var pendingOperations = PendingOperations()
    var images = [PhotoRecord]()
    
    var indicatorContainer : UIView?
    var indicator : UIActivityIndicatorView?
    
    var loadMoreIndicator : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    let footerView : LoadMoreFooterView = LoadMoreFooterView()
    
    var ratingAndFavoriteExecutor: RatingAndBookmarkExecutor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.restaurantsTable.addSubview(refreshControl!)
        self.restaurantsTable.imageDelegate = self
        loadTableData()
        ratingAndFavoriteExecutor = RatingAndBookmarkExecutor(baseVC: self)
    }
    
    func loadTableData() {
        if request == nil {
            request = GetRestaurantsRequest()
            if sortBy == "hottest" {
                request?.sortBy = SortParameter.Hotness
                request?.sortOrder = SortOrder.Descend
            } else if sortBy == "nearest" {
                request?.sortBy = SortParameter.Distance
                request?.sortOrder = SortOrder.Ascend
            }
            request?.limit = 50
            request?.skip = 0
        }
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let location = appDelegate.currentLocation
        if (location.lat == nil || location.lon == nil) {
            return
        }
        request?.userLocation = location
        DataAccessor(serviceConfiguration: ParseConfiguration()).getRestaurants(request!) { (response) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                if response != nil && (response?.results) != nil {
                    self.restaurants = (response?.results)!
                    self.fetchImageDetails()
                }
                self.refreshControl!.endRefreshing()
                self.tableView.reloadData()
            });
        }
        
    }
    
    func refresh(sender:AnyObject) {
        self.restaurants.removeAll()
        self.images.removeAll()
        loadTableData()
    }
    
    private func fetchImageDetails() {
        for restaurant : Restaurant in self.restaurants {
            var url = restaurant.picture?.original
            if url == nil {
                url = ""
            }
            let record = PhotoRecord(name: "", url: NSURL(string: url!)!)
            self.images.append(record)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return RestaurantTableViewCell.height
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 10
        }
        
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        return headerView
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return restaurants.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : RestaurantTableViewCell? = tableView.dequeueReusableCellWithIdentifier("restaurantCell") as? RestaurantTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "RestaurantCell", bundle: nil), forCellReuseIdentifier: "restaurantCell")
            cell = tableView.dequeueReusableCellWithIdentifier("restaurantCell") as? RestaurantTableViewCell
        }
        let imageDetails = imageForIndexPath(tableView: self.restaurantsTable, indexPath: indexPath)
        cell?.setUp(restaurant: restaurants[indexPath.section], image: imageDetails.image!)
        
        switch (imageDetails.state){
        case .New:
            self.restaurantsTable.startOperationsForPhotoRecord(&pendingOperations, photoDetails: imageDetails,indexPath:indexPath)
        default: break
        }
        return cell!
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // if last row, do: load more data
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let restaurantSelected : Restaurant = restaurants[indexPath.row]
        performSegueWithIdentifier("showRestaurant", sender: restaurantSelected.id)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRestaurant" {
            let restaurantController : RestaurantViewController = segue.destinationViewController as! RestaurantViewController
            restaurantController.restaurantId = sender as? String
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        // if last section, add activity indicator
        if section == restaurants.count - 1 {
            footerView.activityIndicator.startAnimating()
            loadMore()
        }
    }
    
    private func loadMore() {
        request?.skip = (request?.skip)! + (request?.limit)!
        DataAccessor(serviceConfiguration: ParseConfiguration()).getRestaurants(request!) { (response) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                if response != nil && (response?.results) != nil {
                    for restaurant : Restaurant in (response?.results)! {
                        var url = restaurant.picture?.original
                        if url == nil {
                            url = ""
                        }
                        let record = PhotoRecord(name: "", url: NSURL(string: url!)!)
                        self.images.append(record)
                        self.restaurants.append(restaurant)
                    }
                }
                self.footerView.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            });
        }
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == restaurants.count - 1 {
           return 30
        } else {
            return 0
        }
        
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let restaurant : Restaurant = self.restaurants[indexPath.section]
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
        
        let addBookmarkAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "收藏\n\(favoriteCount)", handler:{(action, indexpath) -> Void in
            let defaults = NSUserDefaults.standardUserDefaults()
            let sessionToken = defaults.stringForKey("sessionToken")
            if sessionToken == nil {
                self.popupSigninAlert()
            } else {
                favoriteCount++
                if restaurant.favoriteCount == nil {
                    restaurant.favoriteCount = 1
                } else {
                    restaurant.favoriteCount!++
                }
                
                action.title = "收藏\n\(favoriteCount)"
                self.addToFavorites(indexPath)
            }
            self.dismissActionViewWithDelay()
        });
        addBookmarkAction.backgroundColor = UIColor(red: 0, green: 0.749, blue: 1, alpha: 1.0);
        
        let likeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "好吃\n\(likeCount)", handler:{(action, indexpath) -> Void in
            let defaults = NSUserDefaults.standardUserDefaults()
            let sessionToken = defaults.stringForKey("sessionToken")
            if sessionToken == nil {
                self.popupSigninAlert()
            } else {
                if (self.isRatingTooFrequent(objectId!)) {
                    JSSAlertView().warning(self, title: "评价太频繁")
                } else {
                    likeCount++
                    if restaurant.likeCount == nil {
                        restaurant.likeCount = 1
                    } else {
                        restaurant.likeCount!++
                    }
                    action.title = "好吃\n\(likeCount)"
                    self.rateRestaurant(indexPath, ratingType: RatingTypeEnum.like)
                }
                
            }
            self.dismissActionViewWithDelay()
        });
        likeAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        let neutralAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "一般\n\(neutralCount)", handler:{(action, indexpath) -> Void in
            let defaults = NSUserDefaults.standardUserDefaults()
            let sessionToken = defaults.stringForKey("sessionToken")
            if sessionToken == nil {
                self.popupSigninAlert()
            } else {
                if (self.isRatingTooFrequent(objectId!)) {
                    JSSAlertView().warning(self, title: "评价太频繁")
                } else {
                    neutralCount++
                    if restaurant.neutralCount == nil {
                        restaurant.neutralCount = 1
                    } else {
                        restaurant.neutralCount!++
                    }
                    action.title = "一般\n\(neutralCount)"
                    self.rateRestaurant(indexPath, ratingType: RatingTypeEnum.neutral)
                }
                
            }
            
            self.dismissActionViewWithDelay()
        });
        neutralAction.backgroundColor = UIColor(red: 1, green: 0.501, blue: 0, alpha: 1.0);
        
        let dislikeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "难吃\n\(dislikeCount)", handler:{(action, indexpath) -> Void in
            let defaults = NSUserDefaults.standardUserDefaults()
            let sessionToken = defaults.stringForKey("sessionToken")
            if sessionToken == nil {
                self.popupSigninAlert()
            } else {
                if (self.isRatingTooFrequent(objectId!)) {
                    JSSAlertView().warning(self, title: "评价太频繁")
                } else {
                    dislikeCount++
                    if restaurant.dislikeCount == nil {
                        restaurant.dislikeCount = 1
                    } else {
                        restaurant.dislikeCount!++
                    }
                    action.title = "难吃\n\(dislikeCount)"
                    self.rateRestaurant(indexPath, ratingType: RatingTypeEnum.dislike)
                }
                
            }
            
            self.dismissActionViewWithDelay()
        });
        dislikeAction.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 1.0)
        
        
        return [addBookmarkAction, dislikeAction, neutralAction, likeAction];
    }
    
    private func isRatingTooFrequent(objectId : String) -> Bool{
        let defaults = NSUserDefaults.standardUserDefaults()
        let now : Int = Int(NSDate().timeIntervalSince1970 * 1000)
        let lastRateTime = defaults.integerForKey(objectId)
        if (now - lastRateTime < HomeViewController.RATE_MINUTES_INTERVAL * 60 * 60) {
            return true
        } else {
            return false
        }
    }
    
    private func popupSigninAlert() {
        let alertview = JSSAlertView().show(self, title: "请登录", text: nil, buttonText: "我知道了")
        alertview.setTextTheme(.Dark)
    }
    
    private func dismissActionViewWithDelay() {
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("dismissActionView"), userInfo: nil, repeats: false)
    }
    
    @objc private func dismissActionView() {
        self.restaurantsTable.setEditing(false, animated: true)
    }
    
    private func addToFavorites(indexPath: NSIndexPath){
        let restaurant = self.restaurants[indexPath.section]
        ratingAndFavoriteExecutor?.addToFavorites("restaurant", objectId: restaurant.id!, failureHandler: { (objectId) -> Void in
            for restaurant : Restaurant in self.restaurants {
                if restaurant.id == objectId {
                    if restaurant.favoriteCount != nil {
                        restaurant.favoriteCount!--
                    }
                }
            }
        })
    }
    
    private func rateRestaurant(indexPath: NSIndexPath, ratingType: RatingTypeEnum){
        
        let objectId: String? = restaurants[indexPath.section].id
        let type = "restaurant"
        
        if ratingType == RatingTypeEnum.like {
            ratingAndFavoriteExecutor?.like(type, objectId: objectId!, failureHandler: { (objectId) -> Void in
                for restaurant : Restaurant in self.restaurants {
                    if restaurant.id == objectId {
                        if restaurant.likeCount != nil {
                            restaurant.likeCount!--
                        }
                    }
                }
            })
        } else if ratingType == RatingTypeEnum.dislike {
            ratingAndFavoriteExecutor?.dislike(type, objectId: objectId!,failureHandler: { (objectId) -> Void in
                for restaurant : Restaurant in self.restaurants {
                    if restaurant.id == objectId {
                        if restaurant.dislikeCount != nil {
                            restaurant.dislikeCount!--
                        }
                    }
                }
            })
        } else {
            ratingAndFavoriteExecutor?.neutral(type, objectId: objectId!,failureHandler: { (objectId) -> Void in
                for restaurant : Restaurant in self.restaurants {
                    if restaurant.id == objectId {
                        if restaurant.neutralCount != nil {
                            restaurant.neutralCount!--
                        }
                    }
                }
            })
        }

    }
    
    func imageForIndexPath(tableView tableView : UITableView, indexPath : NSIndexPath) -> PhotoRecord {
        return self.images[indexPath.section]
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.restaurantsTable.cancellImageLoadingForUnvisibleCells(&pendingOperations)
        self.restaurantsTable.loadImageForVisibleCells(&pendingOperations)
        pendingOperations.downloadQueue.suspended = false
    }
    
    // As soon as the user starts scrolling, suspend all operations
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        pendingOperations.downloadQueue.suspended = true
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            if scrollView == self.restaurantsTable {
                self.restaurantsTable.cancellImageLoadingForUnvisibleCells(&pendingOperations)
                self.restaurantsTable.loadImageForVisibleCells(&pendingOperations)
                pendingOperations.downloadQueue.suspended = false
            }
        }
    }
}

