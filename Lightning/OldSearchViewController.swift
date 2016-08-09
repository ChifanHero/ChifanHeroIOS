//
//  SecondViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 7/29/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK
import PullToMakeSoup

class OldSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, ARNImageTransitionZoomable{
    
    
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    
    @IBOutlet weak var amplifierStackView: UIStackView!
    
    @IBOutlet weak var searchLogoView: UIImageView!
    
    var resultsCount = 0
    
    var ratingAndBookmarkExecutor: RatingAndBookmarkExecutor?
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var restaurants : [Restaurant] = [Restaurant]()
    var dishes : [Dish] = [Dish]()
    var lists : [List] = [List]()
    
    var loadingIndicator = NVActivityIndicatorView(frame: CGRectMake(0, 0, 40, 40))
    
    var searchBar : UISearchBar?
    
    private var heightConstraint:NSLayoutConstraint?
    
    let LIMIT = 50
    var offset = 0
    
    var footerView : LoadMoreFooterView?
    
    var isLoadingMore = false
    
    let refresher = PullToMakeSoup()
    
    var animateTransition = false
    
    weak var selectedImageView : UIImageView?
    
    var selectedRestaurantName : String?
    
    var selectedRestaurantId : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configLoadingIndicator()
        clearTitleForBackBarButtonItem()
        configureNavigationController()
        setTableFooterView()
        searchResultsTableView.hidden = true
        ratingAndBookmarkExecutor = RatingAndBookmarkExecutor(baseVC: self)
        searchBar = UISearchBar()
        searchBar!.delegate = self
        searchBar?.placeholder = "请输入餐厅名称开始搜索"
        setSearchBarCursorColor()
        searchBar!.sizeToFit()
        self.navigationItem.titleView = searchBar
        definesPresentationContext = true
        //searchLogoView.renderColorChangableImage(UIImage(named: "SearchLogo.png")!, fillColor: UIColor.themeOrange())
        //loadingIndicator.startAnimation()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        setTabBarVisible(true, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if self.searchResultsTableView.pullToRefresh == nil {
            self.searchResultsTableView.addPullToRefresh(refresher) {
                self.search(offset: 0, limit: self.LIMIT)
            }
        }
        TrackingUtil.trackSearchView()
    }
    
    func setTableFooterView() {
        let frame = CGRectMake(0, 0, self.view.frame.size.width, 30)
        footerView = LoadMoreFooterView(frame: frame)
        footerView?.reset()
        self.searchResultsTableView.tableFooterView = footerView
    }
    
    @objc private func refresh(sender:AnyObject) {
        search(offset: 0, limit: LIMIT)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configLoadingIndicator() {
        loadingIndicator.color = UIColor.themeOrange()
        loadingIndicator.type = NVActivityIndicatorType.Pacman
        loadingIndicator.center = self.view.center
        self.view.addSubview(loadingIndicator)
    }
    
    // For now, search only when the search buttion gets clicked
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        TrackingUtil.trackSearchEvent()
        clearStates()
        self.searchBar?.endEditing(true)
        search(offset: 0, limit: LIMIT)
    }

    
    func search(offset offset : Int, limit : Int) {
        
        let keyword = self.searchBar?.text
        print(keyword)
        if keyword != nil && keyword != "" {
            amplifierStackView.hidden = true
            if self.searchResultsTableView.hidden == true {
                loadingIndicator.startAnimation()
            }
            searchRestaurant(keyword: keyword!, offset: offset, limit: limit)
        }
    }
    
    func searchRestaurant(keyword keyword : String, offset : Int, limit : Int) {
        let request : RestaurantSearchRequest = RestaurantSearchRequest()
        request.highlightInField = true
        request.keyword = keyword
        request.offset = offset
        request.limit = limit
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        let userLocation = appDelegate!.getCurrentLocation()
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
                if let results = searchResponse?.results {
                    if offset == 0 {
                        self.restaurants.removeAll()
                    }
                    self.restaurants += results
                    self.resultsCount = self.restaurants.count
                    self.searchResultsTableView.allowsSelection = true
                    self.searchResultsTableView.endRefreshing()
                    self.searchResultsTableView.reloadData()
                    if offset == 0 {
                        self.scrollToTop()
                    }
                    self.searchResultsTableView.hidden = false
                    self.loadingIndicator.stopAnimation()
                }
                self.footerView!.activityIndicator.stopAnimating()
                self.isLoadingMore = false
            })
        }
    }
    
//    func searchDish(keyword keyword : String, offset : Int, limit : Int) {
////        cleanStates()
//        let request : DishSearchRequest = DishSearchRequest()
//        request.keyword = keyword
//        request.offset = offset
//        request.limit = limit
//        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
//        let userLocation = appDelegate!.currentLocation
//        request.userLocation = userLocation
//        request.highlightInField = true
//        DataAccessor(serviceConfiguration: SearchServiceConfiguration()).searchDishes(request) { (searchResponse) -> Void in
//            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                if let results = searchResponse?.results {
//                    if offset == 0 {
//                        self.dishes.removeAll()
//                    }
//                    self.dishes += results
//                    self.resultsCount = self.dishes.count
//                    self.searchResultsTableView.hidden = false
//                    
//                    self.searchResultsTableView.allowsSelection = false
//                    self.refreshControl.endRefreshing()
//                    self.searchResultsTableView.reloadData()
//                    if offset == 0 {
//                        self.scrollToTop()
//                    }
//                    
//                }
//                self.waitingIndicator.hidden = true
//                self.waitingIndicator.stopAnimating()
//                self.footerView!.activityIndicator.stopAnimating()
//                self.isLoadingMore = false
//                
//            })
//        }
//    }
    
//    func searchList(keyword keyword : String, offset : Int, limit : Int) {
////        cleanStates()
//        let request : DishListSearchRequest = DishListSearchRequest()
//        request.keyword = keyword
//        request.offset = offset
//        request.limit = limit
//        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
//        let userLocation = appDelegate!.currentLocation
//        request.userLocation = userLocation
//        DataAccessor(serviceConfiguration: SearchServiceConfiguration()).searchLists(request) { (searchResponse) -> Void in
//            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                if let results = searchResponse?.results {
//                    if offset == 0 {
//                        self.lists.removeAll()
//                    }
//                    self.lists += results
//                    self.resultsCount = self.lists.count
//                    self.searchResultsTableView.hidden = false
//                    
//                    self.searchResultsTableView.allowsSelection = true
//                    self.refreshControl.endRefreshing()
//                    self.searchResultsTableView.reloadData()
//                    if offset == 0 {
//                        self.scrollToTop()
//                    }
//                    
//                }
//                self.waitingIndicator.hidden = true
//                self.waitingIndicator.stopAnimating()
//                self.footerView!.activityIndicator.stopAnimating()
//                self.isLoadingMore = false
//                
//            })
//        }
//    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsCount
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : RestaurantSearchTableViewCell? = tableView.dequeueReusableCellWithIdentifier("restaurantSearchCell") as? RestaurantSearchTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "RestaurantSearchCell", bundle: nil), forCellReuseIdentifier: "restaurantSearchCell")
            cell = tableView.dequeueReusableCellWithIdentifier("restaurantSearchCell") as? RestaurantSearchTableViewCell
        }
        cell?.setUp(restaurant: restaurants[indexPath.row])
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return RestaurantSearchTableViewCell.height
    }
    
//    func restaurantButtonClicked() {
//        if selectionBar.previousScope != "restaurant" {
//            self.searchResultsTableView.hidden = true
//            clearStates()
//            search(offset: 0, limit: LIMIT)
//        }
//        
//    }
//    
//    func dishButtonPressed() {
//        if selectionBar.previousScope != "dish" {
//            self.searchResultsTableView.hidden = true
//            clearStates()
//            search(offset: 0, limit: LIMIT)
//        }
//        
//    }
//    
//    func listButtonPressed() {
//        if selectionBar.previousScope != "list" {
//            self.searchResultsTableView.hidden = true
//            clearStates()
//            search(offset: 0, limit: LIMIT)
//        }
//        
//    }
    
    func clearStates() {
        self.offset = 0
//        self.searchResultsTableView.hidden = true
        self.offset = 0
        self.resultsCount = 0
        self.footerView?.reset()
//        scrollToTop()
    }
    
    func scrollToTop() {
        self.searchResultsTableView.contentOffset = CGPointMake(0, 0 - self.searchResultsTableView.contentInset.top);
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        TrackingUtil.trackExpectedResultFound()
        let restaurant : Restaurant = self.restaurants[indexPath.row]
        self.searchResultsTableView.deselectRowAtIndexPath(indexPath, animated: true)
        let selectedCell : RestaurantSearchTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! RestaurantSearchTableViewCell
        self.selectedImageView = selectedCell.restaurantImageView
        self.selectedRestaurantName = selectedCell.nameLabel.text
        self.selectedRestaurantId = restaurant.id
        self.performSegueWithIdentifier("showRestaurant", sender: restaurant.id)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let restaurantController : RestaurantViewController = segue.destinationViewController as! RestaurantViewController
        self.animateTransition = true
        restaurantController.restaurantImage = self.selectedImageView?.image
        restaurantController.restaurantName = self.selectedRestaurantName
        restaurantController.restaurantId = self.selectedRestaurantId
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        clearStates()
        self.searchBar?.text = nil
        self.searchBar?.resignFirstResponder()
        self.searchBar?.setShowsCancelButton(false, animated: true)
        self.searchResultsTableView.hidden = true
        amplifierStackView.hidden = false
        loadingIndicator.stopAnimation()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar?.setShowsCancelButton(true, animated: true)
    }
    
    
    func needToLoadMore() -> Bool {
        if resultsCount == self.offset + LIMIT {
            return true
        } else {
            return false
        }
        
    }
    
    func loadMore() {
        isLoadingMore = true
        offset += LIMIT
        footerView?.activityIndicator.startAnimating()
        search(offset: offset, limit: LIMIT)
    }
    
    private func popupSigninAlert() {
        SCLAlertView().showWarning("请登录", subTitle: "登录享受更多便利")
    }
    
    private func dismissActionViewWithDelay() {
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(OldSearchViewController.dismissActionView), userInfo: nil, repeats: false)
    }
    
    @objc private func dismissActionView() {
        self.searchResultsTableView.setEditing(false, animated: true)
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(OldSearchViewController.reloadTable), userInfo: nil, repeats: false)
    }
    
    @objc private func reloadTable() {
        self.searchResultsTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        var favoriteCount = 0
        var likeCount = 0
        var neutralCount = 0
        var dislikeCount = 0
        var objectId : String = ""
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
        
        let addBookmarkAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: CellActionTitle.bookMark(favoriteCount), handler:{(action, indexpath) -> Void in
            if (!UserContext.isValidUser()) {
                self.popupSigninAlert()
            } else {
                favoriteCount += 1
                if self.restaurants[indexPath.row].favoriteCount == nil {
                    self.restaurants[indexPath.row].favoriteCount = 1
                } else {
                    self.restaurants[indexPath.row].favoriteCount! += 1
                }
                self.searchResultsTableView.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView(CellActionTitle.bookMark(favoriteCount), index: 0)
                self.addToFavorites(indexPath)
            }
            self.dismissActionViewWithDelay()
            
        });
        addBookmarkAction.backgroundColor = LightningColor.bookMarkYellow()
        
        let likeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: CellActionTitle.positive(likeCount), handler:{(action, indexpath) -> Void in
            
            if (UserContext.isRatingTooFrequent(objectId)) {
                SCLAlertView().showWarning("评价太频繁", subTitle: "")
            } else {
                likeCount += 1
                if self.restaurants[indexPath.row].likeCount == nil {
                    self.restaurants[indexPath.row].likeCount = 1
                } else {
                    self.restaurants[indexPath.row].likeCount! += 1
                }
                self.searchResultsTableView.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView(CellActionTitle.positive(likeCount), index: 3)
                
                self.rate(indexPath, ratingType: RatingTypeEnum.like)
            }
            self.dismissActionViewWithDelay()
        });
        likeAction.backgroundColor = LightningColor.likeBackground()
        
        let neutralAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: CellActionTitle.neutral(neutralCount), handler:{(action, indexpath) -> Void in
            if (UserContext.isRatingTooFrequent(objectId)) {
                SCLAlertView().showWarning("评价太频繁", subTitle: "")
            } else {
                neutralCount += 1
                if self.restaurants[indexPath.row].neutralCount == nil {
                    self.restaurants[indexPath.row].neutralCount = 1
                } else {
                    self.restaurants[indexPath.row].neutralCount! += 1
                }
                self.searchResultsTableView.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView(CellActionTitle.neutral(neutralCount), index: 2)
                self.rate(indexPath, ratingType: RatingTypeEnum.neutral)
            }
            self.dismissActionViewWithDelay()
        });
        neutralAction.backgroundColor = LightningColor.neutralOrange()
        
        let dislikeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: CellActionTitle.negative(dislikeCount), handler:{(action, indexpath) -> Void in
            if (UserContext.isRatingTooFrequent(objectId)) {
                SCLAlertView().showWarning("评价太频繁", subTitle: "")
            } else {
                dislikeCount += 1
                if self.restaurants[indexPath.row].dislikeCount == nil {
                    self.restaurants[indexPath.row].dislikeCount = 1
                } else {
                    self.restaurants[indexPath.row].dislikeCount! += 1
                }
                self.searchResultsTableView.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView(CellActionTitle.negative(dislikeCount), index: 1)
                self.rate(indexPath, ratingType: RatingTypeEnum.dislike)
            }
            self.dismissActionViewWithDelay()
        });
        dislikeAction.backgroundColor = LightningColor.negativeBlue()
        return [addBookmarkAction, dislikeAction, neutralAction, likeAction];
    }
    
    private func addToFavorites(indexPath: NSIndexPath){
        let restaurant = self.restaurants[indexPath.row]
        ratingAndBookmarkExecutor?.addToFavorites("restaurant", objectId: restaurant.id!, failureHandler: { (objectId) -> Void in
            if restaurant.favoriteCount != nil {
                restaurant.favoriteCount! -= 1
            }
        })
    }
    
    private func rate(indexPath: NSIndexPath, ratingType: RatingTypeEnum){
        if ratingType == RatingTypeEnum.like {
            let restaurant = self.restaurants[indexPath.row]
            ratingAndBookmarkExecutor?.like("restaurant", objectId: restaurant.id!, failureHandler: { (objectId) -> Void in
                if restaurant.likeCount != nil {
                    restaurant.likeCount! -= 1
                }
            })
        } else if ratingType == RatingTypeEnum.dislike {
            let restaurant = self.restaurants[indexPath.row]
            ratingAndBookmarkExecutor?.dislike("restaurant", objectId: restaurant.id!, failureHandler: { (objectId) -> Void in
                if restaurant.likeCount != nil {
                    restaurant.likeCount! -= 1
                }
            })
        } else if ratingType == RatingTypeEnum.neutral{
            let restaurant = self.restaurants[indexPath.row]
            ratingAndBookmarkExecutor?.neutral("restaurant", objectId: restaurant.id!, failureHandler: { (objectId) -> Void in
                if restaurant.likeCount != nil {
                    restaurant.likeCount! -= 1
                }
            })
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
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.isKindOfClass(UITableView.classForCoder()) && scrollView.contentOffset.y > 0.0 {
            let scrollPosition = scrollView.contentSize.height - CGRectGetHeight(scrollView.frame) - scrollView.contentOffset.y
            if scrollPosition < 30 && !self.isLoadingMore {
                if self.needToLoadMore() {
                    self.loadMore()
                } else {
                    footerView?.showFinishMessage()
                }
            } else {
                
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
        animateTransition = false
    }
    
//    func handleTransition() {
//        self.animateTransition = true
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let restaurantController = storyboard.instantiateViewControllerWithIdentifier("RestaurantViewController") as! RestaurantViewController
//        restaurantController.restaurantImage = self.selectedImageView?.image
//        restaurantController.restaurantName = self.selectedRestaurantName
//        restaurantController.restaurantId = self.selectedRestaurantId
//        self.navigationController?.pushViewController(restaurantController, animated: true)
//    }
    
    func usingAnimatedTransition() -> Bool {
        return animateTransition
    }
    
    func setSearchBarCursorColor() {
        let view: UIView = searchBar!.subviews[0]
        let subViewsArray = view.subviews
        
        for subView: UIView in subViewsArray {
            if subView.isKindOfClass(UITextField){
                subView.tintColor = UIColor.lightGrayColor()
            }
        }
    }

    
}


