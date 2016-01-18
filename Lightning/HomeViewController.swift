//
//  HomeViewController.swift
//  Lightning
//
//  Created by Shi Yan on 7/29/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, ImageProgressiveTableViewDelegate{
    
    @IBOutlet weak var promotionsTable: ImageProgressiveTableView!
    
    @IBOutlet weak var containerView: UIScrollView!
    
    @IBOutlet weak var topContainerView: UIView!
    
    
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
    
    var ratingAndFavoriteDelegate: RatingAndFavoriteDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePullRefresh()
        initPromotionsTable()
        ratingAndFavoriteDelegate = RatingAndFavoriteImpl(baseVC: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configurePullRefresh(){
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.containerView.addSubview(refreshControl)
    }
    
    private func initPromotionsTable(){
        self.promotionsTable.separatorStyle = UITableViewCellSeparatorStyle.None
        self.promotionsTable.imageDelegate = self
        loadPromotionsTableData()
    }
    
    @objc private func refresh(sender:AnyObject) {
        loadPromotionsTableData()
    }
    
    private func loadPromotionsTableData() {
        let getPromotionsRequest = GetPromotionsRequest()
        getPromotionsRequest.limit = PROMOTIONS_LIMIT
        getPromotionsRequest.offset = PROMOTIONS_OFFSET
        DataAccessor(serviceConfiguration: ParseConfiguration()).getPromotions(getPromotionsRequest) { (response) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                self.loadResults(response?.results)
                self.fetchImageDetails()
                self.promotionsTable.reloadData()
                self.adjustUI()
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
        var contentRect : CGRect = CGRectZero
        for subView : UIView in self.containerView.subviews {
            contentRect = CGRectUnion(contentRect, subView.frame)
        }
        self.containerView.contentSize = CGSizeMake(contentRect.width, contentRect.height)
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
        if segue.identifier == "showRestaurants" {
            let restaurantsController : RestaurantsTableViewController = segue.destinationViewController as! RestaurantsTableViewController
            let getRestaurantsRequest = GetRestaurantsRequest()
            getRestaurantsRequest.limit = RESTAURANTS_LIMIT
            getRestaurantsRequest.offset = RESTAURANTS_OFFSET
            if let s = sender as? String {
                if s == "hottest" {
                    getRestaurantsRequest.sortParameter = SortParameter.Hotness
                    getRestaurantsRequest.sortOrder = SortOrder.Decrease
                    restaurantsController.request = getRestaurantsRequest
                } else if s == "nearest" {
                    getRestaurantsRequest.sortParameter = SortParameter.Distance
                    getRestaurantsRequest.sortOrder = SortOrder.Increase
                    restaurantsController.request = getRestaurantsRequest
                }
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
        return self.images[indexPath.section]
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return promotions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let promotion : Promotion = self.promotions[indexPath.section]
        
        if promotion.restaurant != nil {
            var cell : RestaurantTableViewCell? = tableView.dequeueReusableCellWithIdentifier("restaurantCell") as? RestaurantTableViewCell
            if cell == nil {
                tableView.registerNib(UINib(nibName: "RestaurantCell", bundle: nil), forCellReuseIdentifier: "restaurantCell")
                cell = tableView.dequeueReusableCellWithIdentifier("restaurantCell") as? RestaurantTableViewCell
            }
            let imageDetails = imageForIndexPath(tableView: self.promotionsTable, indexPath: indexPath)
            cell?.setUp(restaurant: promotions[indexPath.section].restaurant!, image: imageDetails.image!)
            
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
            cell?.setUp(dish: promotions[indexPath.section].dish!, image: imageDetails.image!)
            
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
        let promotion : Promotion = self.promotions[indexPath.section]
        if promotion.restaurant != nil {
            return RestaurantTableViewCell.height
        } else if promotion.dish != nil {
            return DishTableViewCell.height
        }
        return 200
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let promotion : Promotion = self.promotions[indexPath.section]
        if promotion.restaurant != nil {
            let restaurant : Restaurant = promotions[indexPath.section].restaurant!
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
        if section == 0 {
            let headerView = RecommendationsHeaderView()
            return headerView
        } else {
            let headerView = UIView()
            headerView.backgroundColor = UIColor.groupTableViewBackgroundColor()
            return headerView
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) ->
        [UITableViewRowAction]? {
            
        let promotion : Promotion = self.promotions[indexPath.section]
        var favoriteCount : Int = 0
        var likeCount : Int = 0
        var neutralCount : Int = 0
        var dislikeCount : Int = 0
        if promotion.dish != nil {
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
            if promotion.restaurant!.favoriteCount != nil {
                favoriteCount = promotion.dish!.favoriteCount!
            }
            if promotion.restaurant!.likeCount != nil {
                likeCount = promotion.dish!.likeCount!
            }
            if promotion.restaurant!.neutralCount != nil {
                neutralCount = promotion.dish!.neutralCount!
            }
            if promotion.restaurant!.dislikeCount != nil {
                dislikeCount = promotion.dish!.dislikeCount!
            }
        }
            
        let addBookmarkAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "收藏\n\(favoriteCount)", handler:{(action, indexpath) -> Void in
            self.addToFavorites(indexPath)
            tableView.setEditing(false, animated: true)
        });
        addBookmarkAction.backgroundColor = UIColor(red: 0, green: 0.749, blue: 1, alpha: 1.0);
        
        let likeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "好吃\n\(likeCount)", handler:{(action, indexpath) -> Void in
            self.ratePromotion(indexPath, ratingType: RatingTypeEnum.like)
            tableView.setEditing(false, animated: true)
        });
        likeAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        let neutralAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "一般\n\(neutralCount)", handler:{(action, indexpath) -> Void in
            self.ratePromotion(indexPath, ratingType: RatingTypeEnum.neutral)
            tableView.setEditing(false, animated: true)
        });
        neutralAction.backgroundColor = UIColor(red: 1, green: 0.501, blue: 0, alpha: 1.0);
        
        let dislikeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "难吃\n\(dislikeCount)", handler:{(action, indexpath) -> Void in
            self.ratePromotion(indexPath, ratingType: RatingTypeEnum.dislike)
            tableView.setEditing(false, animated: true)
        });
        dislikeAction.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 1.0)
        
        
        return [addBookmarkAction, dislikeAction, neutralAction, likeAction];
    }
    
    private func addToFavorites(indexPath: NSIndexPath){
        let promotion : Promotion = self.promotions[indexPath.section]
        if promotion.dish != nil {
            ratingAndFavoriteDelegate?.addToFavorites("dish", objectId: (promotions[indexPath.row].dish?.id)!)
        } else if promotion.restaurant != nil {
            ratingAndFavoriteDelegate?.addToFavorites("restaurant", objectId: (promotions[indexPath.row].restaurant?.id)!)
        }
    }
    
    private func ratePromotion(indexPath: NSIndexPath, ratingType: RatingTypeEnum){
        var type: String?
        var objectId: String?
        
        let promotion : Promotion = self.promotions[indexPath.section]
        if promotion.dish != nil {
            type = "dish"
            objectId = promotions[indexPath.row].dish?.id
        } else if promotion.restaurant != nil {
            type = "restaurant"
            objectId = promotions[indexPath.row].restaurant?.id
        }
        
        if ratingType == RatingTypeEnum.like {
            ratingAndFavoriteDelegate?.like(type!, objectId: objectId!)
        } else if ratingType == RatingTypeEnum.dislike {
            ratingAndFavoriteDelegate?.dislike(type!, objectId: objectId!)
        } else {
            ratingAndFavoriteDelegate?.neutral(type!, objectId: objectId!)
        }        
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
    }
}

