//
//  RestaurantAllDishViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 9/4/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class RestaurantAllDishViewController: RefreshableViewController, SlideBarDelegate, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchControllerDelegate, ImageProgressiveTableViewDelegate {
    
    @IBOutlet weak var slideBar: SlideBar!
    
    @IBOutlet weak var dishTableView: ImageProgressiveTableView!
    
    var request : GetRestaurantMenuRequest?
    
    var restaurantId : String? {
        didSet {
            
        }
    }
    
    private var dishes : [Dish] = []
    private var menuItems : [MenuItem] = []
    private var menuNames : [String] = []
    private var dishToMenuDic : Dictionary<String, String> = Dictionary<String, String>()
    private var shouldChangeSlideBarState = true
    
    var ratingAndFavoriteExecutor: RatingAndBookmarkExecutor?
    
    private var searchResults : [DishWrapper] = []
    
    @IBOutlet weak var waitingView: UIView!
    
    @IBOutlet weak var waitingIndicator: UIActivityIndicatorView!
    
    var pendingOperations = PendingOperations()
    var dishImages : [String : PhotoRecord] = [String : PhotoRecord]()
    
//    var state : RestaurantAllDishViewControllerState = RestaurantAllDishViewControllerState.REGULAR
    
    var slideBarHidden = false
    
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slideBar.delegate = self
        dishTableView.delegate = self
        dishTableView.dataSource = self
        dishTableView.hidden = true
        dishTableView.allowsSelection = false
        
        searchController = UISearchController(searchResultsController: nil)
        
        // The object responsible for updating the contents of the search results controller.
        searchController.searchResultsUpdater = self
        
        // Determines whether the underlying content is dimmed during a search.
        // if we are presenting the display results in the same view, this should be false
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.delegate = self
        
        // Make sure the that the search bar is visible within the navigation bar.
        searchController.searchBar.sizeToFit()
        self.navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
        ratingAndFavoriteExecutor = RatingAndBookmarkExecutor(baseVC: self)
        waitingView.hidden = false
        waitingIndicator.startAnimating()
        loadData(nil)
    }
    
    override func loadData(refreshHandler: ((success: Bool) -> Void)?) {
        if restaurantId != nil {
            let request : GetRestaurantMenuRequest = GetRestaurantMenuRequest(restaurantId: restaurantId!)
            DataAccessor(serviceConfiguration: ParseConfiguration()).getRestaurantMenu(request, responseHandler: { (response) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    if response == nil {
                        if refreshHandler != nil {
                            refreshHandler!(success: false)
                        }
                    } else {
                        if response!.results.count > 0 {
                            self.clearStates()
                            self.menuItems = (response!.results)
                            self.retriveMenuAndDishInformation()
                            self.dishTableView.hidden = false
                            self.fetchImageDetails()
                            self.dishTableView.reloadData()
                            self.slideBar.setUpScrollView(titles: self.menuNames, defaultSelection: nil)
                        }
                        if refreshHandler != nil {
                            refreshHandler!(success: true)
                        }
                    }
                    self.waitingView.hidden = true
                    self.waitingIndicator.stopAnimating()
                    
                });
            })
        }
    }
    
    func clearStates() {
        self.dishes.removeAll()
        self.dishImages.removeAll()
        self.menuItems.removeAll()
    }
    
    private func fetchImageDetails() {
        for dish : Dish in self.dishes {
            var url = dish.picture?.original
            if url == nil {
                url = ""
            }
            let record = PhotoRecord(name: "", url: NSURL(string: url!)!)
            self.dishImages[dish.id!] = record
        }
    }
    
    private func retriveMenuAndDishInformation() {
        for menuItem : MenuItem in menuItems {
            if menuItem.name != nil {
                menuNames.append(menuItem.name!)
                if (menuItem.dishes != nil) {
                    for dish : Dish in menuItem.dishes! {
                        dishToMenuDic[dish.name!] = menuItem.name
                    }
                    dishes += menuItem.dishes!
                }
            }
        }
    }
    
    func slideBar(slideBar : SlideBar, didSelectElementAtIndex index : Int) -> Void {
        // scroll table view
        shouldChangeSlideBarState = false
        if index >= 0 && index < menuItems.count {
            let indexPath : NSIndexPath = NSIndexPath(forRow: 0, inSection: index)
            self.dishTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
            
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if !searchController.active {
            if shouldChangeSlideBarState {
                changeSlideBarState()
            }
        }
        
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        shouldChangeSlideBarState = true
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let dish : Dish = getDishAtIndexPath(indexPath)!
        var favoriteCount : Int = 0
        var likeCount : Int = 0
        var neutralCount : Int = 0
        var dislikeCount : Int = 0
        let objectId = dish.id!
        
        if dish.favoriteCount != nil {
            favoriteCount = dish.favoriteCount!
        }
        if dish.likeCount != nil {
            likeCount = dish.likeCount!
        }
        if dish.neutralCount != nil {
            neutralCount = dish.neutralCount!
        }
        if dish.dislikeCount != nil {
            dislikeCount = dish.dislikeCount!
        }
        
        let bookmarkAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: CellActionTitle.bookMark(favoriteCount), handler:{(action, indexpath) -> Void in
            if (!UserContext.isValidUser()) {
                self.popupSigninAlert()
            } else {
                favoriteCount++
                if dish.favoriteCount == nil {
                    dish.favoriteCount = 1
                } else {
                    dish.favoriteCount!++
                }
                self.dishTableView.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView(CellActionTitle.bookMark(favoriteCount), index: 0)
                self.addToFavorites(indexPath)
            }
            self.dismissActionViewWithDelay()
        });
        bookmarkAction.backgroundColor = LightningColor.bookMarkYellow()
        
        let likeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: CellActionTitle.positive(likeCount), handler:{(action, indexpath) -> Void in
            if (UserContext.isRatingTooFrequent(objectId)) {
                JSSAlertView().warning(self, title: "评价太频繁")
            } else {
                likeCount++
                if dish.likeCount == nil {
                    dish.likeCount = 1
                } else {
                    dish.likeCount!++
                }
                self.dishTableView.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView(CellActionTitle.positive(likeCount), index: 3)
                self.rateDish(indexPath, ratingType: RatingTypeEnum.like)
            }
            self.dismissActionViewWithDelay()
        });
        likeAction.backgroundColor = LightningColor.themeRed()
        
        let neutralAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: CellActionTitle.neutral(neutralCount), handler:{(action, indexpath) -> Void in
            if (UserContext.isRatingTooFrequent(objectId)) {
                JSSAlertView().warning(self, title: "评价太频繁")
            } else {
                neutralCount++
                if dish.neutralCount == nil {
                    dish.neutralCount = 1
                } else {
                    dish.neutralCount!++
                }
                action.title = "一般\n\(neutralCount)"
                self.dishTableView.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView(CellActionTitle.neutral(neutralCount), index: 2)
                self.rateDish(indexPath, ratingType: RatingTypeEnum.neutral)
            }
            self.dismissActionViewWithDelay()
        });
        neutralAction.backgroundColor = LightningColor.neutralOrange()
        
        let dislikeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: CellActionTitle.negative(dislikeCount), handler:{(action, indexpath) -> Void in
            if (UserContext.isRatingTooFrequent(objectId)) {
                JSSAlertView().warning(self, title: "评价太频繁")
            } else {
                dislikeCount++
                if dish.dislikeCount == nil {
                    dish.dislikeCount = 1
                } else {
                    dish.dislikeCount!++
                }
                self.dishTableView.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView(CellActionTitle.negative(dislikeCount), index: 1)
                self.rateDish(indexPath, ratingType: RatingTypeEnum.dislike)
            }
            self.dismissActionViewWithDelay()
        });
        dislikeAction.backgroundColor = LightningColor.negativeBlue()
        
        return [bookmarkAction, dislikeAction, neutralAction, likeAction];
    }
    
    private func addToFavorites(indexPath: NSIndexPath){
        let dish : Dish = getDishAtIndexPath(indexPath)!
        ratingAndFavoriteExecutor?.addToFavorites("dish", objectId: dish.id!, failureHandler: { (objectId) -> Void in
            for dish : Dish in self.dishes {
                if dish.id == objectId {
                    if dish.favoriteCount != nil {
                        dish.favoriteCount!--
                    }
                }
            }
        })
    }
    
    private func rateDish(indexPath: NSIndexPath, ratingType: RatingTypeEnum){
        let objectId: String? = getDishAtIndexPath(indexPath)!.id
        let type = "dish"
        
        if ratingType == RatingTypeEnum.like {
            ratingAndFavoriteExecutor?.like(type, objectId: objectId!, failureHandler: { (objectId) -> Void in
                for dish : Dish in self.dishes {
                    if dish.id == objectId {
                        if dish.likeCount != nil {
                            dish.likeCount!--
                        }
                    }
                }
            })
        } else if ratingType == RatingTypeEnum.dislike {
            ratingAndFavoriteExecutor?.dislike(type, objectId: objectId!,failureHandler: { (objectId) -> Void in
                for dish : Dish in self.dishes {
                    if dish.id == objectId {
                        if dish.dislikeCount != nil {
                            dish.dislikeCount!--
                        }
                    }
                }
            })
        } else {
            ratingAndFavoriteExecutor?.neutral(type, objectId: objectId!,failureHandler: { (objectId) -> Void in
                for dish : Dish in self.dishes {
                    if dish.id == objectId {
                        if dish.neutralCount != nil {
                            dish.neutralCount!--
                        }
                    }
                }
            })
        }
    }
    
    private func dismissActionViewWithDelay() {
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("dismissActionView"), userInfo: nil, repeats: false)
    }
    
    private func popupSigninAlert() {
        let alertview = JSSAlertView().show(self, title: "请登录", text: nil, buttonText: "我知道了")
        alertview.setTextTheme(.Dark)
    }
    
    @objc private func dismissActionView() {
        self.dishTableView.setEditing(false, animated: true)
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("reloadTable"), userInfo: nil, repeats: false)
    }
    
    @objc private func reloadTable() {
        self.dishTableView.reloadData()
    }
    
    private func changeSlideBarState() {
        if let indicesForVisibleRows : [NSIndexPath]? = self.dishTableView.indexPathsForVisibleRows {
            let indexForFirstVisibleRow : NSIndexPath = indicesForVisibleRows![0]
            let dishCell : NameImageDishTableViewCell = self.dishTableView.cellForRowAtIndexPath(indexForFirstVisibleRow) as! NameImageDishTableViewCell
            let menuName = dishToMenuDic[dishCell.nameLabel.text!]
            let position = menuNames.indexOf(menuName!)
            self.slideBar.markElementAsSelected(atIndex: position!)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active {
            return searchResults.count
        } else {
            if section >= 0 && section < menuItems.count {
                let menuItem : MenuItem = self.menuItems[section]
                if menuItem.dishes != nil {
                    return menuItem.dishes!.count
                } else {
                    return 0
                }
            } else {
                return 0
            }
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : NameImageDishTableViewCell? = tableView.dequeueReusableCellWithIdentifier("nameImageDishCell") as? NameImageDishTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "NameImageDishCell", bundle: nil), forCellReuseIdentifier: "nameImageDishCell")
            cell = tableView.dequeueReusableCellWithIdentifier("nameImageDishCell") as? NameImageDishTableViewCell
        }
        let imageDetails = imageForIndexPath(tableView: self.dishTableView, indexPath: indexPath)
        let dish : Dish?
        if searchController.active == false {
            dish = menuItems[indexPath.section].dishes?[indexPath.row]
        } else {
            dish = self.searchResults[indexPath.row].dish
        }
        cell?.setUp(dish: dish!, image: imageDetails.image!)
        switch (imageDetails.state){
        case .New:
            if (!tableView.dragging && !tableView.decelerating) {
                self.dishTableView.startOperationsForPhotoRecord(&pendingOperations, photoDetails: imageDetails,indexPath:indexPath)
            }
        default: break
        }
        
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 82
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if searchController.active {
            return 1
        } else {
            return menuItems.count
        }
//        return menuItems.count
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    private func filterContentForSearchText(searchText : String) {
        for dish : Dish in dishes {
            let relevanceScore : Float = getRelevanceScore(dish.name, searchText: searchText)
            if relevanceScore > 0 {
                let wrapper : DishWrapper = DishWrapper(dish: dish)
                wrapper.relevanceScore = relevanceScore
                searchResults.append(wrapper)
            }
        }
        if searchResults.count > 0 {
            searchResults = searchResults.sort{$0.relevanceScore > $1.relevanceScore}
        }
        for elem : DishWrapper in searchResults {
            print("\(elem.dish.name) score = \(elem.relevanceScore)")
        }
    }
    
    private func getRelevanceScore(str : String?, searchText : String?) -> Float {
        var score : Float =  StringUtil.getRelevanceScore(str, searchText: searchText)
        if str != nil && searchText != nil {
            if str!.rangeOfString(searchText!) != nil || searchText!.rangeOfString(str!) != nil {
                score += 1.0
            }
        }
        return score
    }
    
    private func hideSlideBar() {
        if !slideBarHidden {
            let slideBarHeight : CGFloat = self.slideBar.frame.size.height
            UIView.animateWithDuration(0) { () -> Void in
                self.slideBar.frame.origin.y = self.slideBar.frame.origin.y - slideBarHeight
                self.dishTableView.frame.origin.y = self.dishTableView.frame.origin.y - slideBarHeight
                self.slideBarHidden = true
            }
        }
        
    }
    
    private func getDishAtIndexPath(indexPath : NSIndexPath) -> Dish?{
        if searchController.active == false {
            if menuItems[indexPath.section].dishes != nil && menuItems[indexPath.section].dishes?[indexPath.row] != nil{
                return (menuItems[indexPath.section].dishes?[indexPath.row])!
            } else {
                return nil
            }
            
        } else {
            return self.searchResults[indexPath.row].dish
        }
    }
    
    private func showSlideBar() {
        if slideBarHidden {
            let slideBarHeight : CGFloat = self.slideBar.frame.size.height
            UIView.animateWithDuration(0) { () -> Void in
                self.slideBar.frame.origin.y = self.slideBar.frame.origin.y + slideBarHeight
                self.dishTableView.frame.origin.y = self.dishTableView.frame.origin.y + slideBarHeight
                self.slideBarHidden = false
            }
        }
        
    }
    
    func imageForIndexPath(tableView tableView : UITableView, indexPath : NSIndexPath) -> PhotoRecord {
        let dish : Dish?
        if !searchController.active {
            dish = menuItems[indexPath.section].dishes?[indexPath.row]
        } else {
            dish = self.searchResults[indexPath.row].dish
        }
        return self.dishImages[(dish?.id)!]!
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if !searchController.active {
            return
        }
        print(searchController.searchBar.text)
        let searchText = searchController.searchBar.text
        searchResults.removeAll()
        if searchText != nil {
           filterContentForSearchText(searchText!)
        }
        self.dishTableView.reloadData()
    }
    
    func didPresentSearchController(searchController: UISearchController) {
        hideSlideBar()
        dishTableView.reloadData()
    }
    
    func didDismissSearchController(searchController: UISearchController) {
        showSlideBar()
        // clear search results
        searchResults.removeAll()
        dishTableView.reloadData()
    }
    
    class DishWrapper {
        
        var dish : Dish
        var relevanceScore : Float = 0
        
        init(dish : Dish) {
            self.dish = dish
        }
    }

}
