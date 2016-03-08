//
//  RestaurantsTableViewController.swift
//  Lightning
//
//  Created by Shi Yan on 8/20/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import UIKit

class RestaurantsViewController: RefreshableViewController, UITableViewDataSource, UITableViewDelegate, ImageProgressiveTableViewDelegate {
    
    @IBOutlet var restaurantsTable: ImageProgressiveTableView!
    
    private var request : GetRestaurantsRequest = GetRestaurantsRequest()
    
    var sortBy : String? {
        didSet {
            if sortBy == "hottest" {
                request.sortBy = SortParameter.Hotness
                request.sortOrder = SortOrder.Descend
            } else {
                request.sortBy = SortParameter.Distance
                request.sortOrder = SortOrder.Ascend
            }
        }
    }
    
    let refreshControl = UIRefreshControl()
    
    var restaurants : [Restaurant] = []
    
    var pendingOperations = PendingOperations()
    var images = [PhotoRecord]()
    
    @IBOutlet weak var waitingIndicator: UIActivityIndicatorView!
    
    var loadMoreIndicator : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    let footerView : LoadMoreFooterView = LoadMoreFooterView()
    
    var ratingAndFavoriteExecutor: RatingAndBookmarkExecutor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.restaurantsTable.delegate = self
        self.restaurantsTable.dataSource = self
        self.restaurantsTable.hidden = true
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.restaurantsTable.insertSubview(self.refreshControl, atIndex: 0)
        self.restaurantsTable.imageDelegate = self
        refreshData()
        ratingAndFavoriteExecutor = RatingAndBookmarkExecutor(baseVC: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        let selectedCellIndexPath : NSIndexPath? = self.restaurantsTable.indexPathForSelectedRow
        if selectedCellIndexPath != nil {
            self.restaurantsTable.deselectRowAtIndexPath(selectedCellIndexPath!, animated: false)
        }
    }
    
    override func refreshData() {
        request.limit = 50
        request.skip = 0
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let location = appDelegate.currentLocation
        if (location.lat == nil || location.lon == nil) {
            return
        }
        request.userLocation = location
        loadData(nil)
    }
    
    func clearStates() {
        self.restaurants.removeAll()
        self.images.removeAll()
    }
    
    override func loadData(refreshHandler: ((success: Bool) -> Void)?) {
        waitingIndicator.startAnimating()
        DataAccessor(serviceConfiguration: ParseConfiguration()).getRestaurants(request) { (response) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                if response == nil {
                    if refreshHandler != nil {
                        refreshHandler!(success: false)
                    }
                } else {
                    if self.request.skip == 0 {
                        self.clearStates()
                    }
                    self.loadResults(response?.results)
                    self.fetchImageDetails(response?.results)
                    if self.restaurants.count > 0 {
                        self.restaurantsTable.hidden = false
                    }
                    self.restaurantsTable.reloadData()
                    if refreshHandler != nil {
                        refreshHandler!(success: true)
                    }
                    
                }
                self.refreshControl.endRefreshing()
                self.waitingIndicator.stopAnimating()
                self.waitingIndicator.hidden = true
                self.footerView.activityIndicator.stopAnimating()

                
            });
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
    
    private func fetchImageDetails(results : [Restaurant]?) {
        if results != nil {
            for restaurant : Restaurant in results! {
                var url = restaurant.picture?.original
                if url == nil {
                    url = ""
                }
                let record = PhotoRecord(name: "", url: NSURL(string: url!)!)
                self.images.append(record)
            }
        }
        
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
        if restaurants.isEmpty {
            return 0
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : RestaurantTableViewCell? = tableView.dequeueReusableCellWithIdentifier("restaurantCell") as? RestaurantTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "RestaurantCell", bundle: nil), forCellReuseIdentifier: "restaurantCell")
            cell = tableView.dequeueReusableCellWithIdentifier("restaurantCell") as? RestaurantTableViewCell
        }
        let imageDetails = imageForIndexPath(tableView: self.restaurantsTable, indexPath: indexPath)
        cell?.setUp(restaurant: restaurants[indexPath.row], image: imageDetails.image!)
        
        switch (imageDetails.state){
        case .New:
            self.restaurantsTable.startOperationsForPhotoRecord(&pendingOperations, photoDetails: imageDetails,indexPath:indexPath)
        default: break
        }
        return cell!
    }
    
//    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        if indexPath.row == restaurants.count - 1 {
//            footerView.activityIndicator.startAnimating()
//            loadMore()
//        }
//    }
    
//    func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
//        footerView.activityIndicator.startAnimating()
//        loadMore()
//    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == restaurants.count - 1 {
            footerView.activityIndicator.startAnimating()
            loadMore()
        }
    }
    
//    func tableView(tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
//        footerView.activityIndicator.startAnimating()
//        loadMore()
//    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let restaurantSelected : Restaurant = restaurants[indexPath.row]
        performSegueWithIdentifier("showRestaurant", sender: restaurantSelected.id)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRestaurant" {
            let restaurantController : RestaurantViewController = segue.destinationViewController as! RestaurantViewController
            restaurantController.restaurantId = sender as? String
        }
    }
    
    private func loadMore() {
        request.skip = (request.skip)! + (request.limit)!
        loadData(nil)
//        DataAccessor(serviceConfiguration: ParseConfiguration()).getRestaurants(request) { (response) -> Void in
//            dispatch_async(dispatch_get_main_queue(), {
//                if response != nil && (response?.results) != nil {
//                    for restaurant : Restaurant in (response?.results)! {
//                        var url = restaurant.picture?.original
//                        if url == nil {
//                            url = ""
//                        }
//                        let record = PhotoRecord(name: "", url: NSURL(string: url!)!)
//                        self.images.append(record)
//                        self.restaurants.append(restaurant)
//                    }
//                }
//                self.footerView.activityIndicator.stopAnimating()
//                self.restaurantsTable.reloadData()
//            });
//        }
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        footerView.backgroundColor = UIColor.whiteColor()
        return footerView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if section == restaurants.count - 1 {
//           return 30
//        } else {
//            return 0
//        }
        return 30
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
        
        let addBookmarkAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "收藏\n\(favoriteCount)", handler:{(action, indexpath) -> Void in
            favoriteCount++
            if restaurant.favoriteCount == nil {
                restaurant.favoriteCount = 1
            } else {
                restaurant.favoriteCount!++
            }
            self.restaurantsTable.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView("收藏\n\(favoriteCount)", index: 0)
            self.addToFavorites(indexPath)
            self.dismissActionViewWithDelay()
        });
        addBookmarkAction.backgroundColor = UIColor(red: 0, green: 0.749, blue: 1, alpha: 1.0);
        
        let likeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "好吃\n\(likeCount)", handler:{(action, indexpath) -> Void in
            if (UserContext.isRatingTooFrequent(objectId!)) {
                JSSAlertView().warning(self, title: "评价太频繁")
            } else {
                likeCount++
                if restaurant.likeCount == nil {
                    restaurant.likeCount = 1
                } else {
                    restaurant.likeCount!++
                }
                self.restaurantsTable.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView("好吃\n\(likeCount)", index: 3)
                self.rateRestaurant(indexPath, ratingType: RatingTypeEnum.like)
            }
            self.dismissActionViewWithDelay()
        });
        likeAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        let neutralAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "一般\n\(neutralCount)", handler:{(action, indexpath) -> Void in
            if (UserContext.isRatingTooFrequent(objectId!)) {
                JSSAlertView().warning(self, title: "评价太频繁")
            } else {
                neutralCount++
                if restaurant.neutralCount == nil {
                    restaurant.neutralCount = 1
                } else {
                    restaurant.neutralCount!++
                }
                action.title = "一般\n\(neutralCount)"
                self.restaurantsTable.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView("一般\n\(neutralCount)", index: 2)
                self.rateRestaurant(indexPath, ratingType: RatingTypeEnum.neutral)
            }
            self.dismissActionViewWithDelay()
        });
        neutralAction.backgroundColor = UIColor(red: 1, green: 0.501, blue: 0, alpha: 1.0);
        
        let dislikeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "难吃\n\(dislikeCount)", handler:{(action, indexpath) -> Void in
            if (UserContext.isRatingTooFrequent(objectId!)) {
                JSSAlertView().warning(self, title: "评价太频繁")
            } else {
                dislikeCount++
                if restaurant.dislikeCount == nil {
                    restaurant.dislikeCount = 1
                } else {
                    restaurant.dislikeCount!++
                }
                self.restaurantsTable.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView("难吃\n\(dislikeCount)", index: 1)
                self.rateRestaurant(indexPath, ratingType: RatingTypeEnum.dislike)
            }
            self.dismissActionViewWithDelay()
        });
        dislikeAction.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 1.0)
        
        
        return [addBookmarkAction, dislikeAction, neutralAction, likeAction];
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
        let restaurant = self.restaurants[indexPath.row]
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
        
        let objectId: String? = restaurants[indexPath.row].id
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
        return self.images[indexPath.row]
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.restaurantsTable.cancellImageLoadingForUnvisibleCells(&pendingOperations)
        self.restaurantsTable.loadImageForVisibleCells(&pendingOperations)
        pendingOperations.downloadQueue.suspended = false
    }
    
    // As soon as the user starts scrolling, suspend all operations
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        pendingOperations.downloadQueue.suspended = true
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            if scrollView == self.restaurantsTable {
                self.restaurantsTable.cancellImageLoadingForUnvisibleCells(&pendingOperations)
                self.restaurantsTable.loadImageForVisibleCells(&pendingOperations)
                pendingOperations.downloadQueue.suspended = false
            }
        }
    }
}

