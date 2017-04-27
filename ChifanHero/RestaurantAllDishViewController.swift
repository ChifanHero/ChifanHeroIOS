//
//  RestaurantAllDishViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 9/4/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

class RestaurantAllDishViewController: RefreshableViewController, SlideBarDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var slideBar: SlideBar!
    
    @IBOutlet weak var dishTableView: UITableView!
    
    var request : GetRestaurantMenuRequest?
    
    var restaurantId : String? {
        didSet {
            
        }
    }
    @IBOutlet weak var slideBarHeightConstraint: NSLayoutConstraint!
    
    fileprivate var dishes: [Dish] = []
    fileprivate var menuNames: [String] = []
    fileprivate var dishToMenuDic: Dictionary<String, String> = Dictionary<String, String>()
    fileprivate var shouldChangeSlideBarState = true
    
    var ratingAndFavoriteExecutor: RatingAndBookmarkExecutor?
    
    fileprivate var searchResults : [DishWrapper] = []
    
    @IBOutlet weak var waitingView: UIView!
    
    @IBOutlet weak var waitingIndicator: UIActivityIndicatorView!
    
//    var state : RestaurantAllDishViewControllerState = RestaurantAllDishViewControllerState.REGULAR
    
    var slideBarHidden = false
    
    var searching = false
    
    var searchBar : UISearchBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slideBar.delegate = self
        dishTableView.delegate = self
        dishTableView.dataSource = self
        dishTableView.isHidden = true
        dishTableView.allowsSelection = false
        
        ratingAndFavoriteExecutor = RatingAndBookmarkExecutor(baseVC: self)
        waitingView.isHidden = false
        waitingIndicator.startAnimating()
        loadData { (success) -> Void in
            if !success {
                self.noNetworkDefaultView.show()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar = UISearchBar()
        searchBar!.delegate = self
        searchBar!.sizeToFit()
        self.navigationItem.titleView = searchBar
        definesPresentationContext = true
        TrackingUtil.trackRestaurantAllDishView()
    }
    
    override func loadData(_ refreshHandler: ((_ success: Bool) -> Void)?) {
        
    }
    
    func clearStates() {
        self.dishes.removeAll()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        searchResults.removeAll()
        searching = true
        filterContentForSearchText(searchText)
        self.dishTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("")
        searching = false
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        showSlideBar()
        // clear search results
        searchResults.removeAll()
        dishTableView.reloadData()
    }

    
    fileprivate func retriveMenuAndDishInformation() {
        
    }
    
    func slideBar(_ slideBar : SlideBar, didSelectElementAtIndex index : Int) -> Void {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !searching {
            if shouldChangeSlideBarState {
                changeSlideBarState()
            }
        }
        
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        shouldChangeSlideBarState = true
    }
    
//    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
//        
//        let dish : Dish = getDishAtIndexPath(indexPath)!
//        var favoriteCount : Int = 0
//        var likeCount : Int = 0
//        var neutralCount : Int = 0
//        var dislikeCount : Int = 0
//        let objectId = dish.id!
//        
//        if dish.favoriteCount != nil {
//            favoriteCount = dish.favoriteCount!
//        }
//        if dish.likeCount != nil {
//            likeCount = dish.likeCount!
//        }
//        if dish.neutralCount != nil {
//            neutralCount = dish.neutralCount!
//        }
//        if dish.dislikeCount != nil {
//            dislikeCount = dish.dislikeCount!
//        }
//        
//        let bookmarkAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: CellActionTitle.bookMark(favoriteCount), handler:{(action, indexpath) -> Void in
//            if (!UserContext.isValidUser()) {
//                self.popupSigninAlert()
//            } else {
//                favoriteCount += 1
//                if dish.favoriteCount == nil {
//                    dish.favoriteCount = 1
//                } else {
//                    dish.favoriteCount! += 1
//                }
//                self.dishTableView.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView(CellActionTitle.bookMark(favoriteCount), index: 0)
//                self.addToFavorites(indexPath)
//            }
//            self.dismissActionViewWithDelay()
//        });
//        bookmarkAction.backgroundColor = LightningColor.bookMarkYellow()
//        
//        let likeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: CellActionTitle.positive(likeCount), handler:{(action, indexpath) -> Void in
//            if (UserContext.isRatingTooFrequent(objectId)) {
//                JSSAlertView().warning(self, title: "评价太频繁")
//            } else {
//                likeCount += 1
//                if dish.likeCount == nil {
//                    dish.likeCount = 1
//                } else {
//                    dish.likeCount! += 1
//                }
//                self.dishTableView.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView(CellActionTitle.positive(likeCount), index: 3)
//                self.rateDish(indexPath, ratingType: RatingTypeEnum.like)
//            }
//            self.dismissActionViewWithDelay()
//        });
//        likeAction.backgroundColor = LightningColor.likeBackground()
//        
//        let neutralAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: CellActionTitle.neutral(neutralCount), handler:{(action, indexpath) -> Void in
//            if (UserContext.isRatingTooFrequent(objectId)) {
//                JSSAlertView().warning(self, title: "评价太频繁")
//            } else {
//                neutralCount += 1
//                if dish.neutralCount == nil {
//                    dish.neutralCount = 1
//                } else {
//                    dish.neutralCount! += 1
//                }
//                action.title = "一般\n\(neutralCount)"
//                self.dishTableView.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView(CellActionTitle.neutral(neutralCount), index: 2)
//                self.rateDish(indexPath, ratingType: RatingTypeEnum.neutral)
//            }
//            self.dismissActionViewWithDelay()
//        });
//        neutralAction.backgroundColor = LightningColor.neutralOrange()
//        
//        let dislikeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: CellActionTitle.negative(dislikeCount), handler:{(action, indexpath) -> Void in
//            if (UserContext.isRatingTooFrequent(objectId)) {
//                JSSAlertView().warning(self, title: "评价太频繁")
//            } else {
//                dislikeCount += 1
//                if dish.dislikeCount == nil {
//                    dish.dislikeCount = 1
//                } else {
//                    dish.dislikeCount! += 1
//                }
//                self.dishTableView.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView(CellActionTitle.negative(dislikeCount), index: 1)
//                self.rateDish(indexPath, ratingType: RatingTypeEnum.dislike)
//            }
//            self.dismissActionViewWithDelay()
//        });
//        dislikeAction.backgroundColor = LightningColor.negativeBlue()
//        
//        return [bookmarkAction, dislikeAction, neutralAction, likeAction];
//    }
    
    fileprivate func addToFavorites(_ indexPath: IndexPath){
        let dish : Dish = getDishAtIndexPath(indexPath)!
        ratingAndFavoriteExecutor?.addToFavorites("dish", objectId: dish.id!, failureHandler: { (objectId) -> Void in
            for dish : Dish in self.dishes {
                if dish.id == objectId {
                    if dish.favoriteCount != nil {
                        dish.favoriteCount! -= 1
                    }
                }
            }
        })
    }
    
    fileprivate func rateDish(_ indexPath: IndexPath, ratingType: RatingTypeEnum){
        let objectId: String? = getDishAtIndexPath(indexPath)!.id
        let type = "dish"
        
        if ratingType == RatingTypeEnum.like {
            ratingAndFavoriteExecutor?.like(type, objectId: objectId!, failureHandler: { (objectId) -> Void in
                for dish : Dish in self.dishes {
                    if dish.id == objectId {
                        if dish.likeCount != nil {
                            dish.likeCount! -= 1
                        }
                    }
                }
            })
        } else if ratingType == RatingTypeEnum.dislike {
            ratingAndFavoriteExecutor?.dislike(type, objectId: objectId!,failureHandler: { (objectId) -> Void in
                for dish : Dish in self.dishes {
                    if dish.id == objectId {
                        if dish.dislikeCount != nil {
                            dish.dislikeCount! -= 1
                        }
                    }
                }
            })
        } else {
            ratingAndFavoriteExecutor?.neutral(type, objectId: objectId!,failureHandler: { (objectId) -> Void in
                for dish : Dish in self.dishes {
                    if dish.id == objectId {
                        if dish.neutralCount != nil {
                            dish.neutralCount! -= 1
                        }
                    }
                }
            })
        }
    }
    
    fileprivate func dismissActionViewWithDelay() {
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(RestaurantAllDishViewController.dismissActionView), userInfo: nil, repeats: false)
    }
    
    fileprivate func popupSigninAlert() {
        SCLAlertView().showWarning("请登录", subTitle: "登录享受更多便利")
    }
    
    @objc fileprivate func dismissActionView() {
        self.dishTableView.setEditing(false, animated: true)
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(RestaurantAllDishViewController.reloadTable), userInfo: nil, repeats: false)
    }
    
    @objc fileprivate func reloadTable() {
        self.dishTableView.reloadData()
    }
    
    fileprivate func changeSlideBarState() {
        if let indicesForVisibleRows = self.dishTableView.indexPathsForVisibleRows {
            let indexForFirstVisibleRow: IndexPath = indicesForVisibleRows[0]
            let dishCell : NameOnlyDishTableViewCell = self.dishTableView.cellForRow(at: indexForFirstVisibleRow) as! NameOnlyDishTableViewCell
            let menuName = dishToMenuDic[dishCell.nameLabel.text!]
            let position = menuNames.index(of: menuName!)
            self.slideBar.markElementAsSelected(atIndex: position!)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : NameOnlyDishTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "nameOnlyDishCell") as? NameOnlyDishTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "NameOnlyDishCell", bundle: nil), forCellReuseIdentifier: "nameOnlyDishCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "nameOnlyDishCell") as? NameOnlyDishTableViewCell
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 49
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if searching {
            return 1
        } else {
            return 1
        }
//        return menuItems.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    fileprivate func filterContentForSearchText(_ searchText : String) {
        for dish : Dish in dishes {
            let relevanceScore : Float = getRelevanceScore(dish.name, searchText: searchText)
            if relevanceScore > 0 {
                let wrapper : DishWrapper = DishWrapper(dish: dish)
                wrapper.relevanceScore = relevanceScore
                searchResults.append(wrapper)
            }
        }
        if searchResults.count > 0 {
            searchResults = searchResults.sorted{$0.relevanceScore > $1.relevanceScore}
        }
        for elem : DishWrapper in searchResults {
            print("\(elem.dish.name) score = \(elem.relevanceScore)")
        }
    }
    
    fileprivate func getRelevanceScore(_ str : String?, searchText : String?) -> Float {
        var score : Float =  StringUtil.getRelevanceScore(str, searchText: searchText)
        if str != nil && searchText != nil {
            if str!.range(of: searchText!) != nil || searchText!.range(of: str!) != nil {
                score += 1.0
            }
        }
        return score
    }
    
    fileprivate func hideSlideBar() {
        if !slideBarHidden {
            slideBarHeightConstraint.constant = 0
            UIView.animate(withDuration: 0, animations: { () -> Void in
                self.view.layoutIfNeeded()
                self.slideBarHidden = true
            }) 
        }
        
    }
    
    fileprivate func getDishAtIndexPath(_ indexPath : IndexPath) -> Dish?{
        return Dish()
    }
    
    fileprivate func showSlideBar() {
        if slideBarHidden {
            slideBarHeightConstraint.constant = 38
            UIView.animate(withDuration: 0, animations: { () -> Void in
                self.view.layoutIfNeeded()
                self.slideBarHidden = false
            }) 
        }
        
    }
    
    func updateSearchResultsForSearchController(_ searchController: UISearchController) {
        if !searchController.isActive {
            return
        }
        
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        hideSlideBar()
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
