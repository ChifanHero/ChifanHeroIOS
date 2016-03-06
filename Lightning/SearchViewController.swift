//
//  SecondViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 7/29/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate,UISearchResultsUpdating, UISearchControllerDelegate, UITableViewDelegate, UITableViewDataSource, ImageProgressiveTableViewDelegate, SelectionBarDelegate{
    
    @IBOutlet weak var selectionBar: SelectionBar!
    
    
    @IBOutlet weak var searchResultsTableView: ImageProgressiveTableView!
    
    
    var searchController: UISearchController!
    
    var ratingAndBookmarkExecutor: RatingAndBookmarkExecutor?
    
    @IBOutlet weak var scrollView: UIScrollView!
    let refreshControl = UIRefreshControl()
    
    var restaurants : [Restaurant] = [Restaurant]()
    var dishes : [Dish] = [Dish]()
    var lists : [List] = [List]()
    
    var pendingOperations = PendingOperations()
    var restaurantImages = [PhotoRecord]()
    var dishImages = [PhotoRecord]()
    
    let footerView : LoadMoreFooterView = LoadMoreFooterView()
    
    @IBOutlet weak var waitingIndicator: UIActivityIndicatorView!
    
    private var heightConstraint:NSLayoutConstraint?
    
    let LIMIT = 50
    var offset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Search view");
        waitingIndicator.hidden = true
        selectionBar.hidden = false
        configurePullRefresh()
        configureNavigationController()
        
        searchController = UISearchController(searchResultsController: nil)
        
        // The object responsible for updating the contents of the search results controller.
        searchController.searchResultsUpdater = self
        
        // Determines whether the underlying content is dimmed during a search.
        // if we are presenting the display results in the same view, this should be false
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.delegate = self
        
        searchController.searchBar.delegate = self
        
        selectionBar.delegate = self
        
        // Make sure the that the search bar is visible within the navigation bar.
        searchController.searchBar.sizeToFit()
        self.navigationItem.titleView = searchController.searchBar
        searchController.searchBar.barTintColor = UIColor.clearColor()
//        searchController.searchBar.placeholder = "大家都在搜：韶山冲"

        definesPresentationContext = true
        searchResultsTableView.hidden = true
        ratingAndBookmarkExecutor = RatingAndBookmarkExecutor(baseVC: self)
    }
    
    private func configurePullRefresh(){
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.searchResultsTableView.insertSubview(self.refreshControl, atIndex: 0)
    }
    
    func configureNavigationController() {
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    @objc private func refresh(sender:AnyObject) {
        search(0, limit: LIMIT)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Too expensive. For now, search only when the search buttion gets clicked
    func updateSearchResultsForSearchController(searchController: UISearchController) {
//        if searchController.active == false {
//            let text = searchController.searchBar.text
//            print(text)
//            print("called")
//        }
        
    }
    
    // For now, search only when the search buttion gets clicked
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        clearStates()
        search(0, limit: LIMIT)
    }
    
    func search(offset : Int, limit : Int) {
        
        let keyword = self.searchController.searchBar.text
        print(keyword)
        if keyword != nil && keyword != "" {
            if self.searchResultsTableView.hidden == true {
                waitingIndicator.hidden = false
                waitingIndicator.startAnimating()
            }
            let scope = selectionBar.scope
            if scope == "restaurant" {
                searchRestaurant(keyword: keyword!, offset: offset, limit: limit)
            } else if scope == "list" {
                searchList(keyword: keyword!, offset: offset, limit: limit)
            } else if scope == "dish" {
                searchDish(keyword: keyword!, offset: offset, limit: limit)
            }
            
        }
    }
    
    func searchRestaurant(keyword keyword : String, offset : Int, limit : Int) {
        let request : RestaurantSearchRequest = RestaurantSearchRequest()
        request.highlightInField = true
        request.keyword = keyword
        request.offset = offset
        request.limit = limit
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        let userLocation = appDelegate!.currentLocation
        request.userLocation = userLocation
        print(request.getRequestBody())
        DataAccessor(serviceConfiguration: SearchServiceConfiguration()).searchRestaurants(request) { (searchResponse) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                if offset == 0 {
                    self.clearStates()
                }
                if let results = searchResponse?.results {
                    self.restaurants += results
                    for restaurant : Restaurant in results {
                        var url = restaurant.picture?.original
                        if url == nil {
                            url = ""
                        }
                        let record = PhotoRecord(name: "", url: NSURL(string: url!)!)
                        self.restaurantImages.append(record)
                    }
                    self.searchResultsTableView.hidden = false
                    
                    self.searchResultsTableView.allowsSelection = true
                    self.refreshControl.endRefreshing()
                    self.searchResultsTableView.reloadData()
                    self.waitingIndicator.hidden = true
                    self.waitingIndicator.stopAnimating()
//                    self.adjustSearchResultsTableHeight()
//                    self.adjustScrollViewContentHeight()
                }
                
            })
        }
    }
    
    func searchDish(keyword keyword : String, offset : Int, limit : Int) {
//        cleanStates()
        let request : DishSearchRequest = DishSearchRequest()
        request.keyword = keyword
        request.offset = offset
        request.limit = limit
        let userLocation = UserContext.instance.userLocation
        //        userLocation.lat = location.0
        //        userLocation.lon = location.1
        request.userLocation = userLocation
        request.highlightInField = true
        DataAccessor(serviceConfiguration: SearchServiceConfiguration()).searchDishes(request) { (searchResponse) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                if let results = searchResponse?.results {
                    self.dishes += results
                    for dish : Dish in results {
                        var url = dish.picture?.original
                        if url == nil {
                            url = ""
                        }
                        let record = PhotoRecord(name: "", url: NSURL(string: url!)!)
                        self.dishImages.append(record)
                    }
                    self.searchResultsTableView.hidden = false
                    
                    self.searchResultsTableView.allowsSelection = false
                    self.refreshControl.endRefreshing()
                    self.searchResultsTableView.reloadData()
                    self.waitingIndicator.hidden = true
                    self.waitingIndicator.stopAnimating()
                }
                
            })
        }
    }
    
    func searchList(keyword keyword : String, offset : Int, limit : Int) {
//        cleanStates()
        let request : DishListSearchRequest = DishListSearchRequest()
        request.keyword = keyword
        request.offset = offset
        request.limit = limit
        let userLocation = UserContext.instance.userLocation
        //        userLocation.lat = location.0
        //        userLocation.lon = location.1
        request.userLocation = userLocation
        DataAccessor(serviceConfiguration: SearchServiceConfiguration()).searchLists(request) { (searchResponse) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                if let results = searchResponse?.results {
                    self.lists += results
                    self.searchResultsTableView.hidden = false
                    
                    self.searchResultsTableView.allowsSelection = true
                    self.refreshControl.endRefreshing()
                    self.searchResultsTableView.reloadData()
                    self.waitingIndicator.hidden = true
                    self.waitingIndicator.stopAnimating()
//                    self.adjustSearchResultsTableHeight()
//                    self.adjustScrollViewContentHeight()
                }
                
            })
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if selectionBar.scope == "list" {
            return self.lists.count
        } else if selectionBar.scope == "dish" {
            return self.dishes.count
        } else {
            return self.restaurants.count
        }
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        if indexPath.section == 1 {
//            print("section == 1")
//        }
//        if indexPath.section == 0 {
//            print("section == 0")
//        }
//        if indexPath.section == 2 {
//            print("section == 2")
//        }
//        if indexPath.section == 3 {
//            print("section == 3")
//        }
        if selectionBar.scope == "list" {
            var cell : ListTableViewCell? = tableView.dequeueReusableCellWithIdentifier("listCell") as? ListTableViewCell
            if cell == nil {
                tableView.registerNib(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "listCell")
                cell = tableView.dequeueReusableCellWithIdentifier("listCell") as? ListTableViewCell
            }
            cell!.model = lists[indexPath.section]
            return cell!
        } else if selectionBar.scope == "dish" {
            
            var cell : OwnerInfoDishTableViewCell? = tableView.dequeueReusableCellWithIdentifier("ownerInfoDishCell") as? OwnerInfoDishTableViewCell
            if cell == nil {
                tableView.registerNib(UINib(nibName: "OwnerInfoDishCell", bundle: nil), forCellReuseIdentifier: "ownerInfoDishCell")
                cell = tableView.dequeueReusableCellWithIdentifier("ownerInfoDishCell") as? OwnerInfoDishTableViewCell
            }
//            var cell : DishTableViewCell? = tableView.dequeueReusableCellWithIdentifier("dishCell") as? DishTableViewCell
//            if cell == nil {
//                tableView.registerNib(UINib(nibName: "DishCell", bundle: nil), forCellReuseIdentifier: "dishCell")
//                cell = tableView.dequeueReusableCellWithIdentifier("dishCell") as? DishTableViewCell
//            }

            let imageDetails = imageForIndexPath(tableView: self.searchResultsTableView, indexPath: indexPath)
            cell?.baseVC = self
            cell?.setUp(dish: self.dishes[indexPath.section], image: imageDetails.image!)
            
            switch (imageDetails.state){
            case PhotoRecordState.New:
                self.searchResultsTableView.startOperationsForPhotoRecord(&pendingOperations, photoDetails: imageDetails,indexPath:indexPath)
            default: break
            }
            return cell!
        } else {
            var cell : RestaurantSearchTableViewCell? = tableView.dequeueReusableCellWithIdentifier("restaurantSearchCell") as? RestaurantSearchTableViewCell
            if cell == nil {
                tableView.registerNib(UINib(nibName: "RestaurantSearchCell", bundle: nil), forCellReuseIdentifier: "restaurantSearchCell")
                cell = tableView.dequeueReusableCellWithIdentifier("restaurantSearchCell") as? RestaurantSearchTableViewCell
            }
            let imageDetails = imageForIndexPath(tableView: tableView, indexPath: indexPath)
            cell?.setUp(restaurant: restaurants[indexPath.section], image: imageDetails.image!)
            
            switch (imageDetails.state){
            case .New:
                searchResultsTableView.startOperationsForPhotoRecord(&pendingOperations, photoDetails: imageDetails,indexPath:indexPath)
            default: break
            }
            return cell!
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if selectionBar.scope == "list" {
            return ListTableViewCell.height
        } else if selectionBar.scope == "dish" {
            return 90
        } else {
            return RestaurantTableViewCell.height
        }
        
    }
    
    func imageForIndexPath(tableView tableView : UITableView, indexPath : NSIndexPath) -> PhotoRecord {
        if selectionBar.scope == "dish" {
            return self.dishImages[indexPath.section]
        } else if selectionBar.scope == "restaurant" {
            return self.restaurantImages[indexPath.section]
        } else {
            return PhotoRecord(name: "", url: NSURL())
        }
        
    }
    
//    private func adjustSearchResultsTableHeight() {
//        if self.searchResultsTableView.hidden == false {
//            if self.heightConstraint != nil {
//                self.searchResultsTableView.removeConstraint(heightConstraint!)
//            }
//            heightConstraint = NSLayoutConstraint(item: self.searchResultsTableView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute:NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.searchResultsTableView.contentSize.height);
//            heightConstraint!.priority = 1000
//            self.searchResultsTableView.addConstraint(heightConstraint!);
//            self.layoutComplete = false
//            self.view.layoutIfNeeded()
//            self.layoutComplete = true
//        }
//    }
//    
//    private func adjustScrollViewContentHeight () {
//        if self.searchResultsTableView.contentSize.height > self.scrollView.frame.height {
//            self.scrollView.contentSize.height = self.searchResultsTableView.contentSize.height
//        }
//    }
    
    
    func restaurantButtonClicked() {
        clearStates()
        search(0, limit: LIMIT)
    }
    
    func dishButtonPressed() {
        clearStates()
//        self.searchResultsTableView.hidden = true
        search(0, limit: LIMIT)
    }
    
    func listButtonPressed() {
        clearStates()
//        self.searchResultsTableView.hidden = true
        search(0, limit: LIMIT)
    }
    
    func clearStates() {
        self.offset = 0
        self.dishes.removeAll()
        self.restaurants.removeAll()
        self.lists.removeAll()
        self.restaurantImages.removeAll()
        self.dishImages.removeAll()
        self.searchResultsTableView.hidden = true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let scope = selectionBar.scope
        if scope == "restaurant" {
            let restaurant : Restaurant = self.restaurants[indexPath.section]
            self.performSegueWithIdentifier("showRestaurant", sender: restaurant.id)
            self.searchResultsTableView.deselectRowAtIndexPath(indexPath, animated: true)
        } else if scope == "list" {
            let list : List = self.lists[indexPath.section]
            self.performSegueWithIdentifier("showList", sender: list.id)
            self.searchResultsTableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let barButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = barButtonItem
        if segue.identifier == "showRestaurant" {
            let restaurantController : RestaurantViewController = segue.destinationViewController as! RestaurantViewController
            restaurantController.restaurantId = sender as? String
        } else if segue.identifier == "showList" {
            let listMemberController : ListMemberViewController = segue.destinationViewController as! ListMemberViewController
            listMemberController.listId = sender as? String
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        clearStates()
    }
    
    func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        // if last section, add activity indicator
        var resultsCount = 0
        let scope = selectionBar.scope
        if scope == "restaurant" {
            resultsCount = self.restaurants.count
        } else if scope == "list" {
            resultsCount = self.lists.count
        } else if scope == "dish" {
            resultsCount = self.dishes.count
        }
//        print("section = \(section), resultsCount = \(resultsCount)")
        if section == resultsCount - 1 {
            footerView.activityIndicator.startAnimating()
            loadMore()
        }
    }
    
    func loadMore() {
        var resultsCount = 0
        let scope = selectionBar.scope
        if scope == "restaurant" {
            resultsCount = self.restaurants.count
        } else if scope == "list" {
            resultsCount = self.lists.count
        } else if scope == "dish" {
            resultsCount = self.dishes.count
        }
        if resultsCount == offset + LIMIT {
            offset += LIMIT
            search(offset, limit: LIMIT)
        } else {
            footerView.activityIndicator.stopAnimating()
            footerView.activityIndicator.hidden = true
        }
        
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return footerView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        var resultsCount = 0
        let scope = selectionBar.scope
        if scope == "restaurant" {
            resultsCount = self.restaurants.count
        } else if scope == "list" {
            resultsCount = self.lists.count
        } else if scope == "dish" {
            resultsCount = self.dishes.count
        }
        if section == resultsCount - 1 {
            return 30
        } else {
            return 0
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
        self.searchResultsTableView.setEditing(false, animated: true)
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("reloadTable"), userInfo: nil, repeats: false)
    }
    
    @objc private func reloadTable() {
        self.searchResultsTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        var favoriteCount = 0
        var likeCount = 0
        var neutralCount = 0
        var dislikeCount = 0
        var positiveText = "好吃"
        let favoriteText = "收藏"
        let scope = selectionBar.scope
        var objectId : String = ""
        if scope == "restaurant" {
            objectId = self.restaurants[indexPath.section].id!
            if self.restaurants[indexPath.section].favoriteCount != nil {
                favoriteCount = self.restaurants[indexPath.section].favoriteCount!
            }
            if self.restaurants[indexPath.section].likeCount != nil {
                likeCount = self.restaurants[indexPath.section].likeCount!
            }
            if self.restaurants[indexPath.section].dislikeCount != nil {
                dislikeCount = self.restaurants[indexPath.section].dislikeCount!
            }
            if self.restaurants[indexPath.section].neutralCount != nil {
                neutralCount = self.restaurants[indexPath.section].neutralCount!
            }
            
        } else if scope == "list" {
            positiveText = "喜欢"
            objectId = self.lists[indexPath.section].id!
            if self.lists[indexPath.section].favoriteCount != nil {
                favoriteCount = self.lists[indexPath.section].favoriteCount!
            }
            if self.lists[indexPath.section].likeCount != nil {
                likeCount = self.lists[indexPath.section].likeCount!
            }
        } else if scope == "dish" {
            objectId = self.dishes[indexPath.section].id!
            if self.dishes[indexPath.section].favoriteCount != nil {
                favoriteCount = self.dishes[indexPath.section].favoriteCount!
            }
            if self.dishes[indexPath.section].likeCount != nil {
                likeCount = self.dishes[indexPath.section].likeCount!
            }
            if self.dishes[indexPath.section].dislikeCount != nil {
                dislikeCount = self.dishes[indexPath.section].dislikeCount!
            }
            if self.dishes[indexPath.section].neutralCount != nil {
                neutralCount = self.dishes[indexPath.section].neutralCount!
            }
        }
        
        let addBookmarkAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: favoriteText + "\n\(favoriteCount)", handler:{(action, indexpath) -> Void in
            if (!UserContext.isValidUser()) {
                self.popupSigninAlert()
            } else {
                favoriteCount++
                if scope == "restaurant" {
                    if self.restaurants[indexPath.section].favoriteCount == nil {
                       self.restaurants[indexPath.section].favoriteCount = 1
                    } else {
                        self.restaurants[indexPath.section].favoriteCount!++
                    }
                } else if scope == "list" {
                    if self.lists[indexPath.section].favoriteCount == nil {
                        self.lists[indexPath.section].favoriteCount = 1
                    } else {
                        self.lists[indexPath.section].favoriteCount!++
                    }
                } else if scope == "dish" {
                    if self.dishes[indexPath.section].favoriteCount == nil {
                        self.dishes[indexPath.section].favoriteCount = 1
                    } else {
                        self.dishes[indexPath.section].favoriteCount!++
                    }
                }
                self.searchResultsTableView.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView("收藏\n\(favoriteCount)", index: 0)
                self.addToFavorites(indexPath)
            }
            self.dismissActionViewWithDelay()
            
        });
        addBookmarkAction.backgroundColor = UIColor(red: 0, green: 0.749, blue: 1, alpha: 1.0);
        
        let likeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: positiveText + "\n\(likeCount)", handler:{(action, indexpath) -> Void in
            
            if (UserContext.isRatingTooFrequent(objectId)) {
                JSSAlertView().warning(self, title: "评价太频繁")
            } else {
                likeCount++
                if scope == "restaurant" {
                    if self.restaurants[indexPath.section].likeCount == nil {
                        self.restaurants[indexPath.section].likeCount = 1
                    } else {
                        self.restaurants[indexPath.section].likeCount!++
                    }
                } else if scope == "list" {
                    if self.lists[indexPath.section].likeCount == nil {
                        self.lists[indexPath.section].likeCount = 1
                    } else {
                        self.lists[indexPath.section].likeCount!++
                    }
                } else if scope == "dish" {
                    if self.dishes[indexPath.section].likeCount == nil {
                        self.dishes[indexPath.section].likeCount = 1
                    } else {
                        self.dishes[indexPath.section].likeCount!++
                    }
                }
                
                self.searchResultsTableView.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView(positiveText + "\n\(likeCount)", index: 3)
                
                self.rate(indexPath, ratingType: RatingTypeEnum.like)
            }
            self.dismissActionViewWithDelay()
        });
        likeAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        if scope != "list" {
            let neutralAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "一般\n\(neutralCount)", handler:{(action, indexpath) -> Void in
                if (UserContext.isRatingTooFrequent(objectId)) {
                    JSSAlertView().warning(self, title: "评价太频繁")
                } else {
                    neutralCount++
                    if scope == "restaurant" {
                        if self.restaurants[indexPath.section].neutralCount == nil {
                            self.restaurants[indexPath.section].neutralCount = 1
                        } else {
                            self.restaurants[indexPath.section].neutralCount!++
                        }
                    } else if scope == "dish" {
                        if self.dishes[indexPath.section].neutralCount == nil {
                            self.dishes[indexPath.section].neutralCount = 1
                        } else {
                            self.dishes[indexPath.section].neutralCount!++
                        }
                    }
                    self.searchResultsTableView.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView("一般\n\(neutralCount)", index: 2)
                    self.rate(indexPath, ratingType: RatingTypeEnum.neutral)
                }
                self.dismissActionViewWithDelay()
            });
            neutralAction.backgroundColor = UIColor(red: 1, green: 0.501, blue: 0, alpha: 1.0);
            
            let dislikeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "难吃\n\(dislikeCount)", handler:{(action, indexpath) -> Void in
                if (UserContext.isRatingTooFrequent(objectId)) {
                    JSSAlertView().warning(self, title: "评价太频繁")
                } else {
                    dislikeCount++
                    if scope == "restaurant" {
                        if self.restaurants[indexPath.section].dislikeCount == nil {
                            self.restaurants[indexPath.section].dislikeCount = 1
                        } else {
                            self.restaurants[indexPath.section].dislikeCount!++
                        }
                    } else if scope == "dish" {
                        if self.dishes[indexPath.section].dislikeCount == nil {
                            self.dishes[indexPath.section].dislikeCount = 1
                        } else {
                            self.dishes[indexPath.section].dislikeCount!++
                        }
                    }
                    self.searchResultsTableView.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView("难吃\n\(dislikeCount)", index: 1)
                    self.rate(indexPath, ratingType: RatingTypeEnum.dislike)
                }
                self.dismissActionViewWithDelay()
            });
            dislikeAction.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 1.0)
            return [addBookmarkAction, dislikeAction, neutralAction, likeAction];
        } else {
            return [addBookmarkAction, likeAction]
        }
    }
    
    private func addToFavorites(indexPath: NSIndexPath){
        let scope = selectionBar.scope
        if scope == "restaurant" {
            let restaurant = self.restaurants[indexPath.section]
            ratingAndBookmarkExecutor?.addToFavorites("restaurant", objectId: restaurant.id!, failureHandler: { (objectId) -> Void in
                if restaurant.favoriteCount != nil {
                    restaurant.favoriteCount!--
                }
            })
            
        } else if scope == "list" {
            let list = self.lists[indexPath.section]
            ratingAndBookmarkExecutor?.addToFavorites("list", objectId: list.id!, failureHandler: { (objectId) -> Void in
                if list.favoriteCount != nil {
                    list.favoriteCount!--
                }
            })
            
        } else if scope == "dish" {
            let dish = self.dishes[indexPath.section]
            ratingAndBookmarkExecutor?.addToFavorites("dish", objectId: dish.id!, failureHandler: { (objectId) -> Void in
                if dish.favoriteCount != nil {
                    dish.favoriteCount!--
                }
            })
        }
    }
    
    private func rate(indexPath: NSIndexPath, ratingType: RatingTypeEnum){
        let scope = selectionBar.scope
        if ratingType == RatingTypeEnum.like {
            if scope == "restaurant" {
                let restaurant = self.restaurants[indexPath.section]
                ratingAndBookmarkExecutor?.like("restaurant", objectId: restaurant.id!, failureHandler: { (objectId) -> Void in
                    if restaurant.likeCount != nil {
                        restaurant.likeCount!--
                    }
                })
            } else if scope == "dish" {
                let dish = self.dishes[indexPath.section]
                ratingAndBookmarkExecutor?.like("dish", objectId: dish.id!, failureHandler: { (objectId) -> Void in
                    if dish.likeCount != nil {
                        dish.likeCount!--
                    }
                })
            } else if scope == "list" {
                let list = self.lists[indexPath.section]
                ratingAndBookmarkExecutor?.like("list", objectId: list.id!, failureHandler: { (objectId) -> Void in
                    if list.likeCount != nil {
                        list.likeCount!--
                    }
                })
            }
            
        } else if ratingType == RatingTypeEnum.dislike {
            if scope == "restaurant" {
                let restaurant = self.restaurants[indexPath.section]
                ratingAndBookmarkExecutor?.dislike("restaurant", objectId: restaurant.id!, failureHandler: { (objectId) -> Void in
                    if restaurant.likeCount != nil {
                        restaurant.likeCount!--
                    }
                })
            } else if scope == "dish" {
                let dish = self.dishes[indexPath.section]
                ratingAndBookmarkExecutor?.dislike("dish", objectId: dish.id!, failureHandler: { (objectId) -> Void in
                    if dish.likeCount != nil {
                        dish.likeCount!--
                    }
                })
            }
        } else if ratingType == RatingTypeEnum.neutral{
            if scope == "restaurant" {
                let restaurant = self.restaurants[indexPath.section]
                ratingAndBookmarkExecutor?.neutral("restaurant", objectId: restaurant.id!, failureHandler: { (objectId) -> Void in
                    if restaurant.likeCount != nil {
                        restaurant.likeCount!--
                    }
                })
            } else if scope == "dish" {
                let dish = self.dishes[indexPath.section]
                ratingAndBookmarkExecutor?.neutral("dish", objectId: dish.id!, failureHandler: { (objectId) -> Void in
                    if dish.likeCount != nil {
                        dish.likeCount!--
                    }
                })
            }
        }
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        return headerView
    }

    
}



