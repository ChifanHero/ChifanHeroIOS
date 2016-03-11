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
        clearTitleForBackBarButtonItem()
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
    
    private func clearTitleForBackBarButtonItem(){
        let barButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = barButtonItem
    }
    
    private func configurePullRefresh(){
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.searchResultsTableView.insertSubview(self.refreshControl, atIndex: 0)
    }
    
    func configureNavigationController() {
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    @objc private func refresh(sender:AnyObject) {
        search(offset: 0, limit: LIMIT)
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
        search(offset: 0, limit: LIMIT)
    }
    
    func search(offset offset : Int, limit : Int) {
        
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
        let range = Range()
        range.center = userLocation
        let distance = Distance()
        distance.value = 50
        distance.unit = "mi"
        range.distance = distance
        request.range = range
        DataAccessor(serviceConfiguration: SearchServiceConfiguration()).searchRestaurants(request) { (searchResponse) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                if offset == 0 {
                    self.clearStates()
//                    self.searchResultsTableView.reloadData()
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
                    
                    
                    self.searchResultsTableView.allowsSelection = true
                    self.refreshControl.endRefreshing()
                    self.searchResultsTableView.hidden = true
                    self.searchResultsTableView.reloadData()
                    self.waitingIndicator.hidden = true
                    self.waitingIndicator.stopAnimating()
                    self.searchResultsTableView.hidden = false
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
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        let userLocation = appDelegate!.currentLocation
        request.userLocation = userLocation
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
        if selectionBar.scope == "list" {
            return self.lists.count
        } else if selectionBar.scope == "dish" {
            return self.dishes.count
        } else {
            return self.restaurants.count
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if selectionBar.scope == "list" {
            var cell : ListTableViewCell? = tableView.dequeueReusableCellWithIdentifier("listCell") as? ListTableViewCell
            if cell == nil {
                tableView.registerNib(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "listCell")
                cell = tableView.dequeueReusableCellWithIdentifier("listCell") as? ListTableViewCell
            }
            cell!.model = lists[indexPath.row]
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
            cell?.setUp(dish: self.dishes[indexPath.row], image: imageDetails.image!)
            
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
            cell?.setUp(restaurant: restaurants[indexPath.row], image: imageDetails.image!)
            
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
            return OwnerInfoDishTableViewCell.height
        } else {
            return RestaurantSearchTableViewCell.height
        }
        
    }
    
    func imageForIndexPath(tableView tableView : UITableView, indexPath : NSIndexPath) -> PhotoRecord {
        if selectionBar.scope == "dish" {
            return self.dishImages[indexPath.row]
        } else if selectionBar.scope == "restaurant" {
            return self.restaurantImages[indexPath.row]
        } else {
            return PhotoRecord(name: "", url: NSURL())
        }
        
    }
    
    func restaurantButtonClicked() {
        clearStates()
        search(offset: 0, limit: LIMIT)
    }
    
    func dishButtonPressed() {
        clearStates()
        search(offset: 0, limit: LIMIT)
    }
    
    func listButtonPressed() {
        clearStates()
        search(offset: 0, limit: LIMIT)
    }
    
    func clearStates() {
        self.offset = 0
        self.dishes.removeAll()
        self.restaurants.removeAll()
        self.lists.removeAll()
        self.restaurantImages.removeAll()
        self.dishImages.removeAll()
        self.searchResultsTableView.hidden = true
        self.offset = 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let scope = selectionBar.scope
        if scope == "restaurant" {
            let restaurant : Restaurant = self.restaurants[indexPath.row]
            self.performSegueWithIdentifier("showRestaurant", sender: restaurant.id)
            self.searchResultsTableView.deselectRowAtIndexPath(indexPath, animated: true)
        } else if scope == "list" {
            let list : List = self.lists[indexPath.row]
            self.performSegueWithIdentifier("showList", sender: list.id)
            self.searchResultsTableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
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
            search(offset: offset, limit: LIMIT)
        } else {
            footerView.activityIndicator.stopAnimating()
            footerView.activityIndicator.hidden = true
        }
        
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return footerView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 30

        
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
        let scope = selectionBar.scope
        var objectId : String = ""
        if scope == "restaurant" {
            objectId = self.restaurants[indexPath.row].id!
            if self.restaurants[indexPath.row].favoriteCount != nil {
                favoriteCount = self.restaurants[indexPath.row].favoriteCount!
            }
            if self.restaurants[indexPath.row].likeCount != nil {
                likeCount = self.restaurants[indexPath.row].likeCount!
            }
            if self.restaurants[indexPath.row].dislikeCount != nil {
                dislikeCount = self.restaurants[indexPath.row].dislikeCount!
            }
            if self.restaurants[indexPath.row].neutralCount != nil {
                neutralCount = self.restaurants[indexPath.row].neutralCount!
            }
            
        } else if scope == "list" {
            objectId = self.lists[indexPath.row].id!
            if self.lists[indexPath.row].favoriteCount != nil {
                favoriteCount = self.lists[indexPath.row].favoriteCount!
            }
            if self.lists[indexPath.row].likeCount != nil {
                likeCount = self.lists[indexPath.row].likeCount!
            }
        } else if scope == "dish" {
            objectId = self.dishes[indexPath.row].id!
            if self.dishes[indexPath.row].favoriteCount != nil {
                favoriteCount = self.dishes[indexPath.row].favoriteCount!
            }
            if self.dishes[indexPath.row].likeCount != nil {
                likeCount = self.dishes[indexPath.row].likeCount!
            }
            if self.dishes[indexPath.row].dislikeCount != nil {
                dislikeCount = self.dishes[indexPath.row].dislikeCount!
            }
            if self.dishes[indexPath.row].neutralCount != nil {
                neutralCount = self.dishes[indexPath.row].neutralCount!
            }
        }
        
        let addBookmarkAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: CellActionTitle.bookMark(favoriteCount), handler:{(action, indexpath) -> Void in
            if (!UserContext.isValidUser()) {
                self.popupSigninAlert()
            } else {
                favoriteCount++
                if scope == "restaurant" {
                    if self.restaurants[indexPath.row].favoriteCount == nil {
                       self.restaurants[indexPath.row].favoriteCount = 1
                    } else {
                        self.restaurants[indexPath.row].favoriteCount!++
                    }
                } else if scope == "list" {
                    if self.lists[indexPath.row].favoriteCount == nil {
                        self.lists[indexPath.row].favoriteCount = 1
                    } else {
                        self.lists[indexPath.row].favoriteCount!++
                    }
                } else if scope == "dish" {
                    if self.dishes[indexPath.row].favoriteCount == nil {
                        self.dishes[indexPath.row].favoriteCount = 1
                    } else {
                        self.dishes[indexPath.row].favoriteCount!++
                    }
                }
                self.searchResultsTableView.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView(CellActionTitle.bookMark(favoriteCount), index: 0)
                self.addToFavorites(indexPath)
            }
            self.dismissActionViewWithDelay()
            
        });
        addBookmarkAction.backgroundColor = LightningColor.bookMarkYellow()
        
        let likeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: CellActionTitle.positive(likeCount), handler:{(action, indexpath) -> Void in
            
            if (UserContext.isRatingTooFrequent(objectId)) {
                JSSAlertView().warning(self, title: "评价太频繁")
            } else {
                likeCount++
                if scope == "restaurant" {
                    if self.restaurants[indexPath.row].likeCount == nil {
                        self.restaurants[indexPath.row].likeCount = 1
                    } else {
                        self.restaurants[indexPath.row].likeCount!++
                    }
                } else if scope == "list" {
                    if self.lists[indexPath.row].likeCount == nil {
                        self.lists[indexPath.row].likeCount = 1
                    } else {
                        self.lists[indexPath.row].likeCount!++
                    }
                } else if scope == "dish" {
                    if self.dishes[indexPath.row].likeCount == nil {
                        self.dishes[indexPath.row].likeCount = 1
                    } else {
                        self.dishes[indexPath.row].likeCount!++
                    }
                }
                
                self.searchResultsTableView.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView(CellActionTitle.positive(likeCount), index: 3)
                
                self.rate(indexPath, ratingType: RatingTypeEnum.like)
            }
            self.dismissActionViewWithDelay()
        });
        likeAction.backgroundColor = LightningColor.themeRed()
        
        if scope != "list" {
            let neutralAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: CellActionTitle.neutral(neutralCount), handler:{(action, indexpath) -> Void in
                if (UserContext.isRatingTooFrequent(objectId)) {
                    JSSAlertView().warning(self, title: "评价太频繁")
                } else {
                    neutralCount++
                    if scope == "restaurant" {
                        if self.restaurants[indexPath.row].neutralCount == nil {
                            self.restaurants[indexPath.row].neutralCount = 1
                        } else {
                            self.restaurants[indexPath.row].neutralCount!++
                        }
                    } else if scope == "dish" {
                        if self.dishes[indexPath.row].neutralCount == nil {
                            self.dishes[indexPath.row].neutralCount = 1
                        } else {
                            self.dishes[indexPath.row].neutralCount!++
                        }
                    }
                    self.searchResultsTableView.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView(CellActionTitle.neutral(neutralCount), index: 2)
                    self.rate(indexPath, ratingType: RatingTypeEnum.neutral)
                }
                self.dismissActionViewWithDelay()
            });
            neutralAction.backgroundColor = LightningColor.neutralOrange()
            
            let dislikeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: CellActionTitle.negative(dislikeCount), handler:{(action, indexpath) -> Void in
                if (UserContext.isRatingTooFrequent(objectId)) {
                    JSSAlertView().warning(self, title: "评价太频繁")
                } else {
                    dislikeCount++
                    if scope == "restaurant" {
                        if self.restaurants[indexPath.row].dislikeCount == nil {
                            self.restaurants[indexPath.row].dislikeCount = 1
                        } else {
                            self.restaurants[indexPath.row].dislikeCount!++
                        }
                    } else if scope == "dish" {
                        if self.dishes[indexPath.row].dislikeCount == nil {
                            self.dishes[indexPath.row].dislikeCount = 1
                        } else {
                            self.dishes[indexPath.row].dislikeCount!++
                        }
                    }
                    self.searchResultsTableView.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView(CellActionTitle.negative(dislikeCount), index: 1)
                    self.rate(indexPath, ratingType: RatingTypeEnum.dislike)
                }
                self.dismissActionViewWithDelay()
            });
            dislikeAction.backgroundColor = LightningColor.negativeBlue()
            return [addBookmarkAction, dislikeAction, neutralAction, likeAction];
        } else {
            return [addBookmarkAction, likeAction]
        }
    }
    
    private func addToFavorites(indexPath: NSIndexPath){
        let scope = selectionBar.scope
        if scope == "restaurant" {
            let restaurant = self.restaurants[indexPath.row]
            ratingAndBookmarkExecutor?.addToFavorites("restaurant", objectId: restaurant.id!, failureHandler: { (objectId) -> Void in
                if restaurant.favoriteCount != nil {
                    restaurant.favoriteCount!--
                }
            })
            
        } else if scope == "list" {
            let list = self.lists[indexPath.row]
            ratingAndBookmarkExecutor?.addToFavorites("list", objectId: list.id!, failureHandler: { (objectId) -> Void in
                if list.favoriteCount != nil {
                    list.favoriteCount!--
                }
            })
            
        } else if scope == "dish" {
            let dish = self.dishes[indexPath.row]
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
                let restaurant = self.restaurants[indexPath.row]
                ratingAndBookmarkExecutor?.like("restaurant", objectId: restaurant.id!, failureHandler: { (objectId) -> Void in
                    if restaurant.likeCount != nil {
                        restaurant.likeCount!--
                    }
                })
            } else if scope == "dish" {
                let dish = self.dishes[indexPath.row]
                ratingAndBookmarkExecutor?.like("dish", objectId: dish.id!, failureHandler: { (objectId) -> Void in
                    if dish.likeCount != nil {
                        dish.likeCount!--
                    }
                })
            } else if scope == "list" {
                let list = self.lists[indexPath.row]
                ratingAndBookmarkExecutor?.like("list", objectId: list.id!, failureHandler: { (objectId) -> Void in
                    if list.likeCount != nil {
                        list.likeCount!--
                    }
                })
            }
            
        } else if ratingType == RatingTypeEnum.dislike {
            if scope == "restaurant" {
                let restaurant = self.restaurants[indexPath.row]
                ratingAndBookmarkExecutor?.dislike("restaurant", objectId: restaurant.id!, failureHandler: { (objectId) -> Void in
                    if restaurant.likeCount != nil {
                        restaurant.likeCount!--
                    }
                })
            } else if scope == "dish" {
                let dish = self.dishes[indexPath.row]
                ratingAndBookmarkExecutor?.dislike("dish", objectId: dish.id!, failureHandler: { (objectId) -> Void in
                    if dish.likeCount != nil {
                        dish.likeCount!--
                    }
                })
            }
        } else if ratingType == RatingTypeEnum.neutral{
            if scope == "restaurant" {
                let restaurant = self.restaurants[indexPath.row]
                ratingAndBookmarkExecutor?.neutral("restaurant", objectId: restaurant.id!, failureHandler: { (objectId) -> Void in
                    if restaurant.likeCount != nil {
                        restaurant.likeCount!--
                    }
                })
            } else if scope == "dish" {
                let dish = self.dishes[indexPath.row]
                ratingAndBookmarkExecutor?.neutral("dish", objectId: dish.id!, failureHandler: { (objectId) -> Void in
                    if dish.likeCount != nil {
                        dish.likeCount!--
                    }
                })
            }
        }
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        return headerView
    }

    
}



