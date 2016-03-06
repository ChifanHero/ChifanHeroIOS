//
//  HomeViewController.swift
//  Lightning
//
//  Created by Shi Yan on 7/29/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import UIKit

class HomeViewController: RefreshableViewController, ImageProgressiveTableViewDelegate {
    
    @IBOutlet weak var promotionsTable: ImageProgressiveTableView!
    
    @IBOutlet weak var containerView: UIScrollView!
    
    @IBOutlet weak var topContainerView: UIView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBAction func showHottestRestaurants(sender: AnyObject) {
        self.performSegueWithIdentifier("showRestaurants", sender: "hottest")
    }
    
    @IBAction func showNearstRestaurants(sender: AnyObject) {
        self.performSegueWithIdentifier("showRestaurants", sender: "nearest")
    }
    
    @IBAction func showDishLists(sender: AnyObject) {
        self.performSegueWithIdentifier("showLists", sender: self)
    }
    
    let PROMOTIONS_LIMIT = 10
    let PROMOTIONS_OFFSET = 0
    let RESTAURANTS_LIMIT = 10
    let RESTAURANTS_OFFSET = 0
    let LISTS_LIMIT = 10
    let LISTS_OFFSET = 0

    let refreshControl = UIRefreshControl()
    var pendingOperations = PendingOperations()
    var images = [PhotoRecord]()
    var promotions: [Promotion] = []
    
    var ratingAndBookmarkExecutor: RatingAndBookmarkExecutor?
    
    var appDelegate : AppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.containerView.delegate = self
        configureNavigationController()
        loadingIndicator.hidden = false
        self.promotionsTable.separatorStyle = UITableViewCellSeparatorStyle.None
        appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        appDelegate!.startGettingLocation()
        appDelegate!.registerForPushNotifications()
        configurePullRefresh()
        initPromotionsTable()
        ratingAndBookmarkExecutor = RatingAndBookmarkExecutor(baseVC: self)
        generateNavigationItemTitle()
    }
    
    private func generateNavigationItemTitle() {
        let logo = UIImage(named: "Lightning_Title.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }
    
    func configureNavigationController() {
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configurePullRefresh(){
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.containerView.insertSubview(refreshControl, atIndex : 0)
        self.refreshControl.beginRefreshing()
        self.refreshControl.endRefreshing()
    }
    
    private func initPromotionsTable(){
        self.promotionsTable.imageDelegate = self
        loadingIndicator.startAnimating()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshData", name:"UserLocationAvailable", object: nil)
        
    }
    
    @objc private func refresh(sender:AnyObject) {
        loadPromotionsTableData(nil)
    }
    
    func refreshData() {
        loadPromotionsTableData(nil)
    }
    
    override func refreshView(refreshHandler : (success : Bool) -> Void) {
        self.loadPromotionsTableData { (success) -> Void in
            refreshHandler(success: success)
        }
    }
    
    func loadPromotionsTableData(refreshHandler : ((success : Bool) -> Void)?) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "UserLocationAvailable", object: nil)
        let getPromotionsRequest = GetPromotionsRequest()
        
        let location = appDelegate!.currentLocation
        if (location.lat == nil || location.lon == nil) {
           return
        }
        getPromotionsRequest.userLocation = location
        getPromotionsRequest.limit = PROMOTIONS_LIMIT
        getPromotionsRequest.offset = PROMOTIONS_OFFSET
        print(getPromotionsRequest.getRequestBody())
        DataAccessor(serviceConfiguration: ParseConfiguration()).getPromotions(getPromotionsRequest) { (response) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                if response == nil {
                    if refreshHandler != nil {
                        refreshHandler!(success: false)
                    }
                } else {
                    self.images.removeAll()
                    self.promotions.removeAll()
                    self.loadResults(response!.results)
                    self.fetchImageDetails()
                    
                    if self.promotions.count > 0 {
                        self.promotionsTable.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
                    }
                    self.promotionsTable.reloadData()
                    self.adjustUI()
                    if refreshHandler != nil {
                        refreshHandler!(success: true)
                    }
                }
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.hidden = true
                self.refreshControl.endRefreshing()
                
                
            });
        }
    }
    
    private func loadResults(results : [Promotion]?) {
        if results != nil {
            for promotion : Promotion in results! {
                if promotion.restaurant == nil && promotion.dish == nil {
                    continue;
                }
                if promotion.restaurant != nil && promotion.dish != nil {
                    continue;
                }
                self.promotions.append(promotion)
            }
        }
    }
    
    private func adjustUI() {
        adjustPromotionsTableHeight()
        adjustContainerViewHeight()
    }
    
    private func adjustPromotionsTableHeight() {
        let originalFrame : CGRect = self.promotionsTable.frame
        self.promotionsTable.frame = CGRectMake(originalFrame.origin.x, originalFrame.origin.y, originalFrame.size.width, self.promotionsTable.contentSize.height)
    }
    
    private func adjustContainerViewHeight() {
        self.containerView.contentSize.height = self.topContainerView.frame.height + 10 + self.promotionsTable.frame.height
    }
    
    private func fetchImageDetails() {
        for promotion: Promotion in self.promotions {
            var url: String?
            if promotion.dish != nil {
                url = promotion.dish?.picture?.original
            } else if promotion.restaurant != nil {
                url = promotion.restaurant?.picture?.original
            }
            if url == nil {
                url = ""
            }
            let record = PhotoRecord(name: "", url: NSURL(string: url!)!)
            self.images.append(record)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
//        self.navigationItem.backBarButtonItem = barButtonItem;
        let barButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = barButtonItem
        if segue.identifier == "showRestaurants" {
            let restaurantsController : RestaurantsViewController = segue.destinationViewController as! RestaurantsViewController
            if let s = sender as? String {
                restaurantsController.sortBy = s
            }
        } else if segue.identifier == "showLists" {
            let getListsRequest = GetListsRequest()
            getListsRequest.limit = LISTS_LIMIT
            getListsRequest.offset = LISTS_OFFSET
            let listsController : ListsTableViewController = segue.destinationViewController as! ListsTableViewController
            listsController.request = getListsRequest
        } else if segue.identifier == "showRestaurant" {
            let restaurantController : RestaurantViewController = segue.destinationViewController as! RestaurantViewController
            restaurantController.restaurantId = sender as? String
        }
    }
    
    internal func imageForIndexPath(tableView tableView : UITableView, indexPath : NSIndexPath) -> PhotoRecord {
        return self.images[indexPath.row]
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.promotionsTable.cancellImageLoadingForUnvisibleCells(&pendingOperations)
        self.promotionsTable.loadImageForVisibleCells(&pendingOperations)
        pendingOperations.downloadQueue.suspended = false
    }
    
    // As soon as the user starts scrolling, suspend all operations
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        pendingOperations.downloadQueue.suspended = true
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            if scrollView == self.promotionsTable {
                self.promotionsTable.cancellImageLoadingForUnvisibleCells(&pendingOperations)
                self.promotionsTable.loadImageForVisibleCells(&pendingOperations)
                pendingOperations.downloadQueue.suspended = false
            }
        }
        print(self.refreshControl.refreshing)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        if scrollView.contentOffset.y > 10 {
            
        }
    }

}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return promotions.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if promotions.isEmpty {
            return 0
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let promotion: Promotion = self.promotions[indexPath.row]
        
        if promotion.restaurant != nil {
            var cell: RestaurantTableViewCell? = tableView.dequeueReusableCellWithIdentifier("restaurantCell") as? RestaurantTableViewCell
            if cell == nil {
                tableView.registerNib(UINib(nibName: "RestaurantCell", bundle: nil), forCellReuseIdentifier: "restaurantCell")
                cell = tableView.dequeueReusableCellWithIdentifier("restaurantCell") as? RestaurantTableViewCell
            }
            let imageDetails = imageForIndexPath(tableView: self.promotionsTable, indexPath: indexPath)
            cell?.setUp(restaurant: promotions[indexPath.row].restaurant!, image: imageDetails.image!)
            
            switch (imageDetails.state){
            case .New:
                if (!tableView.dragging && !tableView.decelerating) {
                    self.promotionsTable.startOperationsForPhotoRecord(&pendingOperations, photoDetails: imageDetails,indexPath:indexPath)
                }
            default: break
            }
            return cell!
        } else if promotion.dish != nil {
            var cell : DishTableViewCell? = tableView.dequeueReusableCellWithIdentifier("dishCell") as? DishTableViewCell
            if cell == nil {
                tableView.registerNib(UINib(nibName: "DishCell", bundle: nil), forCellReuseIdentifier: "dishCell")
                cell = tableView.dequeueReusableCellWithIdentifier("dishCell") as? DishTableViewCell
            }
            let imageDetails = imageForIndexPath(tableView: self.promotionsTable, indexPath: indexPath)
            cell?.setUp(dish: promotions[indexPath.row].dish!, image: imageDetails.image!)
            
            switch (imageDetails.state){
            case .New:
                if (!tableView.dragging && !tableView.decelerating) {
                    self.promotionsTable.startOperationsForPhotoRecord(&pendingOperations, photoDetails: imageDetails,indexPath:indexPath)
                }
            default: break
            }
            return cell!
        } else {
            return UITableViewCell()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        let selectedCellIndexPath : NSIndexPath? = self.promotionsTable.indexPathForSelectedRow
        if selectedCellIndexPath != nil {
            self.promotionsTable.deselectRowAtIndexPath(selectedCellIndexPath!, animated: false)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let promotion: Promotion = self.promotions[indexPath.row]
        if promotion.restaurant != nil {
            return RestaurantTableViewCell.height
        } else if promotion.dish != nil {
            return DishTableViewCell.height
        }
        return 200
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let promotion : Promotion = self.promotions[indexPath.row]
        if promotion.restaurant != nil {
            let restaurant : Restaurant = promotions[indexPath.row].restaurant!
            self.performSegueWithIdentifier("showRestaurant", sender: restaurant.id)
        }
        
        self.promotionsTable.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 30
        } else {
            return 10
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = RecommendationsHeaderView()
        return headerView
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) ->
        [UITableViewRowAction]? {
            
        let promotion : Promotion = self.promotions[indexPath.row]
        var favoriteCount : Int = 0
        var likeCount : Int = 0
        var neutralCount : Int = 0
        var dislikeCount : Int = 0
        var objectId = ""
        if promotion.dish != nil {
            objectId = promotion.dish!.id!
            if promotion.dish!.favoriteCount != nil {
                favoriteCount = promotion.dish!.favoriteCount!
            }
            if promotion.dish!.likeCount != nil {
                likeCount = promotion.dish!.likeCount!
            }
            if promotion.dish!.neutralCount != nil {
                neutralCount = promotion.dish!.neutralCount!
            }
            if promotion.dish!.dislikeCount != nil {
                dislikeCount = promotion.dish!.dislikeCount!
            }
            
        } else if promotion.restaurant != nil {
            objectId = promotion.restaurant!.id!
            if promotion.restaurant!.favoriteCount != nil {
                favoriteCount = promotion.restaurant!.favoriteCount!
            }
            if promotion.restaurant!.likeCount != nil {
                likeCount = promotion.restaurant!.likeCount!
            }
            if promotion.restaurant!.neutralCount != nil {
                neutralCount = promotion.restaurant!.neutralCount!
            }
            if promotion.restaurant!.dislikeCount != nil {
                dislikeCount = promotion.restaurant!.dislikeCount!
            }
        }
            
        let addBookmarkAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "收藏\n\(favoriteCount)", handler:{(action, indexpath) -> Void in
            if (!UserContext.isValidUser()) {
                self.popupSigninAlert()
            } else {
                favoriteCount++
                if promotion.dish != nil {
                    if promotion.dish?.favoriteCount == nil {
                        promotion.dish?.favoriteCount = 1
                    } else {
                        promotion.dish?.favoriteCount!++
                    }
                } else {
                    if promotion.restaurant?.favoriteCount == nil {
                        promotion.restaurant?.favoriteCount = 1
                    } else {
                        promotion.restaurant?.favoriteCount!++
                    }
                }
                self.promotionsTable.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView("收藏\n\(favoriteCount)", index: 0)
                self.addToFavorites(indexPath)
            }
            self.dismissActionViewWithDelay()
            
        });
        addBookmarkAction.backgroundColor = UIColor(red: 0, green: 0.749, blue: 1, alpha: 1.0);
        
        let likeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "好吃\n\(likeCount)", handler:{(action, indexpath) -> Void in
            if (UserContext.isRatingTooFrequent(objectId)) {
                JSSAlertView().warning(self, title: "评价太频繁")
            } else {
                likeCount++
                if promotion.dish != nil {
                    if promotion.dish?.likeCount == nil {
                        promotion.dish?.likeCount = 1
                    } else {
                        promotion.dish?.likeCount!++
                    }
                } else {
                    if promotion.restaurant?.likeCount == nil {
                        promotion.restaurant?.likeCount = 1
                    } else {
                        promotion.restaurant?.likeCount!++
                    }
                }
                
                self.promotionsTable.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView("好吃\n\(likeCount)", index: 3)
                
                self.ratePromotion(indexPath, ratingType: RatingTypeEnum.like)
            }
            self.dismissActionViewWithDelay()
        });
        likeAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        let neutralAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "一般\n\(neutralCount)", handler:{(action, indexpath) -> Void in
            if (UserContext.isRatingTooFrequent(objectId)) {
                JSSAlertView().warning(self, title: "评价太频繁")
            } else {
                neutralCount++
                if promotion.dish != nil {
                    if promotion.dish?.neutralCount == nil {
                        promotion.dish?.neutralCount = 1
                    } else {
                        promotion.dish?.neutralCount!++
                    }
                } else {
                    if promotion.restaurant?.neutralCount == nil {
                        promotion.restaurant?.neutralCount = 1
                    } else {
                        promotion.restaurant?.neutralCount!++
                    }
                }
                self.promotionsTable.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView("一般\n\(neutralCount)", index: 2)
                self.ratePromotion(indexPath, ratingType: RatingTypeEnum.neutral)
            }
            self.dismissActionViewWithDelay()
        });
        neutralAction.backgroundColor = UIColor(red: 1, green: 0.501, blue: 0, alpha: 1.0);
        
        let dislikeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "难吃\n\(dislikeCount)", handler:{(action, indexpath) -> Void in
            if (UserContext.isRatingTooFrequent(objectId)) {
                JSSAlertView().warning(self, title: "评价太频繁")
            } else {
                dislikeCount++
                if promotion.dish != nil {
                    if promotion.dish?.dislikeCount == nil {
                        promotion.dish?.dislikeCount = 1
                    } else {
                        promotion.dish?.dislikeCount!++
                    }
                } else {
                    if promotion.restaurant?.dislikeCount == nil {
                        promotion.restaurant?.dislikeCount = 1
                    } else {
                        promotion.restaurant?.dislikeCount!++
                    }
                }
                self.promotionsTable.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView("难吃\n\(dislikeCount)", index: 1)
                self.ratePromotion(indexPath, ratingType: RatingTypeEnum.dislike)
            }
            self.dismissActionViewWithDelay()
        });
        dislikeAction.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 1.0)
        
        
        return [addBookmarkAction, dislikeAction, neutralAction, likeAction];
    }
    
    private func dismissActionViewWithDelay() {
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("dismissActionView"), userInfo: nil, repeats: false)
    }
    
    @objc private func dismissActionView() {
        self.promotionsTable.setEditing(false, animated: true)
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("reloadTable"), userInfo: nil, repeats: false)
    }
    
    @objc private func reloadTable() {
        self.promotionsTable.reloadData()
    }
    
    private func addToFavorites(indexPath: NSIndexPath){
        
        let promotion : Promotion = self.promotions[indexPath.row]
        if promotion.dish != nil {
            ratingAndBookmarkExecutor?.addToFavorites("dish", objectId: (promotion.dish?.id)!, failureHandler: { (objectId) -> Void in
                for promotion : Promotion in self.promotions {
                    if promotion.dish?.id == objectId {
                        if promotion.dish?.favoriteCount != nil {
                            promotion.dish?.favoriteCount!--
                        }
                    }
                }
            })
        } else if promotion.restaurant != nil {
            ratingAndBookmarkExecutor?.addToFavorites("restaurant", objectId: (promotion.restaurant?.id)!, failureHandler: { (objectId) -> Void in
                for promotion : Promotion in self.promotions {
                    if promotion.restaurant?.id == objectId {
                        if promotion.restaurant?.favoriteCount != nil {
                            promotion.restaurant?.favoriteCount!--
                        }
                    }
                }
            })
        }
        
    }
    
    private func ratePromotion(indexPath: NSIndexPath, ratingType: RatingTypeEnum){
        var type: String?
        var objectId: String?
        
        let promotion : Promotion = self.promotions[indexPath.row]
        if promotion.dish != nil {
            type = "dish"
            objectId = promotion.dish?.id
        } else if promotion.restaurant != nil {
            type = "restaurant"
            objectId = promotion.restaurant?.id
        }
        
        if ratingType == RatingTypeEnum.like {
            ratingAndBookmarkExecutor?.like(type!, objectId: objectId!, failureHandler: { (objectId) -> Void in
                for promotion : Promotion in self.promotions {
                    if promotion.dish?.id == objectId {
                        if promotion.dish?.likeCount != nil {
                            promotion.dish?.likeCount!--
                        }
                    } else if promotion.restaurant?.id == objectId {
                        if promotion.restaurant?.likeCount != nil {
                            promotion.restaurant?.likeCount!--
                        }
                    }
                }
            })
        } else if ratingType == RatingTypeEnum.dislike {
            ratingAndBookmarkExecutor?.dislike(type!, objectId: objectId!,failureHandler: { (objectId) -> Void in
                for promotion : Promotion in self.promotions {
                    if promotion.dish?.id == objectId {
                        if promotion.dish?.dislikeCount != nil {
                            promotion.dish?.dislikeCount!--
                        }
                    } else if promotion.restaurant?.id == objectId {
                        if promotion.restaurant?.dislikeCount != nil {
                            promotion.restaurant?.dislikeCount!--
                        }
                    }
                }
            })
        } else {
            ratingAndBookmarkExecutor?.neutral(type!, objectId: objectId!,failureHandler: { (objectId) -> Void in
                for promotion : Promotion in self.promotions {
                    if promotion.dish?.id == objectId {
                        if promotion.dish?.neutralCount != nil {
                            promotion.dish?.neutralCount!--
                        }
                    } else if promotion.restaurant?.id == objectId {
                        if promotion.restaurant?.neutralCount != nil {
                            promotion.restaurant?.neutralCount!--
                        }
                    }
                }
            })
        }
        
        
    }
    
    private func popupSigninAlert() {
        let alertview = JSSAlertView().show(self, title: "请登录", text: nil, buttonText: "我知道了")
        alertview.setTextTheme(.Dark)
    }
    
    
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        adjustUI()
    }
}

