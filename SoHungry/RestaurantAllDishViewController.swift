//
//  RestaurantAllDishViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 9/4/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class RestaurantAllDishViewController: UIViewController, SlideBarDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate {
    
    @IBOutlet weak var slideBar: SlideBar!
    
    @IBOutlet weak var dishTableView: UITableView!
    
    var restaurantId : String?
    
    private var dishes : [Dish] = []
    private var menuItems : [MenuItem] = []
    private var menuNames : [String] = []
    private var dishToMenuDic : Dictionary<String, String> = Dictionary<String, String>()
    private var shouldChangeSlideBarState = true
    
    private var searchResults : [DishWrapper] = []
    
    var state : RestaurantAllDishViewControllerState = RestaurantAllDishViewControllerState.REGULAR
    
    var slideBarHidden = false
    
    
    override func viewDidLoad() {
        self.navigationItem.titleView = UISearchBar()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: nil)
        super.viewDidLoad()
        slideBar.delegate = self
        dishTableView.delegate = self
        dishTableView.dataSource = self
        dishTableView.hidden = true
        
        let searchBar : UISearchBar = UISearchBar()
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
    }
    
    private func loadTableData() {
        if restaurantId != nil {
            let request : GetRestaurantMenuRequest = GetRestaurantMenuRequest(restaurantId: restaurantId!)
            DataAccessor(serviceConfiguration: ParseConfiguration()).getRestaurantMenu(request, responseHandler: { (response) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    self.menuItems = (response?.results)!
                    self.retriveMenuAndDishInformation()
                    self.dishTableView.hidden = false
                    self.dishTableView.reloadData()
                    self.slideBar.setUpScrollView(titles: self.menuNames, defaultSelection: nil)
                });
            })
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
    
    override func viewDidAppear(animated: Bool) {
//        slideBar.setUpScrollView(titles: ["精美凉菜","主厨推荐","韶山经典","铁板干锅","石锅煲仔","私房蒸菜","特色小炒","健康美食","滋补汤羹","主食甜点"], defaultSelection: nil)
        loadTableData()
        
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
//        if shouldChangeSlideBarState {
//            changeSlideBarState()
//        }
        if state == RestaurantAllDishViewControllerState.REGULAR {
            if shouldChangeSlideBarState {
                changeSlideBarState()
            }
        }
        
    }
    
    private func changeSlideBarState() {
        if let indicesForVisibleRows : [NSIndexPath]? = self.dishTableView.indexPathsForVisibleRows {
            let indexForFirstVisibleRow : NSIndexPath = indicesForVisibleRows![0]
            let dishCell : NameOnlyDishTableViewCell = self.dishTableView.cellForRowAtIndexPath(indexForFirstVisibleRow) as! NameOnlyDishTableViewCell
            let dish : Dish = dishCell.model as! Dish
            let menuName = dishToMenuDic[dish.name!]
            let position = menuNames.indexOf(menuName!)
            self.slideBar.markElementAsSelected(atIndex: position!)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
//        if !shouldChangeSlideBarState {
//            shouldChangeSlideBarState = true
//        }
        if state == RestaurantAllDishViewControllerState.REGULAR {
            if !shouldChangeSlideBarState {
                shouldChangeSlideBarState = true
            }
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if state == RestaurantAllDishViewControllerState.SEARCHING {
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
//        if section >= 0 && section < menuItems.count {
//            let menuItem : MenuItem = self.menuItems[section]
//            if menuItem.dishes != nil {
//                return menuItem.dishes!.count
//            } else {
//                return 0
//            }
//        } else {
//            return 0
//        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : NameOnlyDishTableViewCell? = tableView.dequeueReusableCellWithIdentifier("nameOnlyDishCell") as? NameOnlyDishTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "NameOnlyDishCell", bundle: nil), forCellReuseIdentifier: "nameOnlyDishCell")
            cell = tableView.dequeueReusableCellWithIdentifier("nameOnlyDishCell") as? NameOnlyDishTableViewCell
        }
        if state == RestaurantAllDishViewControllerState.SEARCHING {
            cell?.model = searchResults[indexPath.row].dish
        } else {
            cell?.model = menuItems[indexPath.section].dishes?[indexPath.row]
        }
//        cell?.dishName = menuItems[indexPath.section].dishes?[indexPath.row].name
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 82
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if state == RestaurantAllDishViewControllerState.SEARCHING {
            return 1
        } else {
            return menuItems.count
        }
//        return menuItems.count
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        print("cancel button clicked")
        state = RestaurantAllDishViewControllerState.REGULAR
        self.dishTableView.reloadData()
        showSlideBar()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            state = RestaurantAllDishViewControllerState.REGULAR
            self.dishTableView.reloadData()
            showSlideBar()
        } else {
            state = RestaurantAllDishViewControllerState.SEARCHING
            searchResults.removeAll()
            filterContentForSearchText(searchText)
            self.dishTableView.reloadData()
            hideSlideBar()
        }
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
    
    enum RestaurantAllDishViewControllerState {
        case REGULAR
        case SEARCHING
    }
    
    class DishWrapper {
        
        var dish : Dish
        var relevanceScore : Float = 0
        
        init(dish : Dish) {
            self.dish = dish
        }
    }

    
    

}
