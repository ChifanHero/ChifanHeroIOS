//
//  RestaurantAllDishViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 9/4/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class RestaurantAllDishViewController: UIViewController, SlideBarDelegate, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchControllerDelegate, ImageProgressiveTableViewDelegate {
    
    @IBOutlet weak var slideBar: SlideBar!
    
    @IBOutlet weak var dishTableView: ImageProgressiveTableView!
    
    var restaurantId : String?
    
    private var dishes : [Dish] = []
    private var menuItems : [MenuItem] = []
    private var menuNames : [String] = []
    private var dishToMenuDic : Dictionary<String, String> = Dictionary<String, String>()
    private var shouldChangeSlideBarState = true
    
    private var searchResults : [DishWrapper] = []
    
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
        loadTableData()
    }
    
    private func loadTableData() {
        if restaurantId != nil {
            let request : GetRestaurantMenuRequest = GetRestaurantMenuRequest(restaurantId: restaurantId!)
            DataAccessor(serviceConfiguration: ParseConfiguration()).getRestaurantMenu(request, responseHandler: { (response) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    self.menuItems = (response?.results)!
                    self.retriveMenuAndDishInformation()
                    self.dishTableView.hidden = false
                    self.fetchImageDetails()
                    self.dishTableView.reloadData()
                    self.slideBar.setUpScrollView(titles: self.menuNames, defaultSelection: nil)
                });
            })
        }
        
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
    
    private func changeSlideBarState() {
        if let indicesForVisibleRows : [NSIndexPath]? = self.dishTableView.indexPathsForVisibleRows {
            let indexForFirstVisibleRow : NSIndexPath = indicesForVisibleRows![0]
            let dishCell : NameOnlyDishTableViewCell = self.dishTableView.cellForRowAtIndexPath(indexForFirstVisibleRow) as! NameOnlyDishTableViewCell
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
        var cell : NameOnlyDishTableViewCell? = tableView.dequeueReusableCellWithIdentifier("nameOnlyDishCell") as? NameOnlyDishTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "NameOnlyDishCell", bundle: nil), forCellReuseIdentifier: "nameOnlyDishCell")
            cell = tableView.dequeueReusableCellWithIdentifier("nameOnlyDishCell") as? NameOnlyDishTableViewCell
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
