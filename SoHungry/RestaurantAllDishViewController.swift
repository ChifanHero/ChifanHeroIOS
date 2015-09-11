//
//  RestaurantAllDishViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 9/4/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class RestaurantAllDishViewController: UIViewController, SlideBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var slideBar: SlideBar!
    
    @IBOutlet weak var dishTableView: UITableView!
    
    var restaurantId : String?
    
//    private var dishes : [Dish] = []
    private var menuItems : [MenuItem] = []
    private var menuNames : [String] = []
    private var dishToMenuDic : Dictionary<String, String> = Dictionary<String, String>()
    
    private var slideBarClicked = false
    
    
    override func viewDidLoad() {
        self.navigationItem.titleView = UISearchBar()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: nil)
        super.viewDidLoad()
        slideBar.delegate = self
        dishTableView.delegate = self
        dishTableView.dataSource = self
        dishTableView.hidden = true
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
        slideBarClicked = true
        if index >= 0 && index < menuItems.count {
            let indexPath : NSIndexPath = NSIndexPath(forRow: 0, inSection: index)
            self.dishTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
        
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if slideBarClicked == false {
            if let indicesForVisibleRows : [NSIndexPath]? = self.dishTableView.indexPathsForVisibleRows {
                let indexForFirstVisibleRow : NSIndexPath = indicesForVisibleRows![0]
                let dishCell : SimpleDishTableViewCell = self.dishTableView.cellForRowAtIndexPath(indexForFirstVisibleRow) as! SimpleDishTableViewCell
                let menuName = dishToMenuDic[dishCell.dishName!]
                let position = menuNames.indexOf(menuName!)
                self.slideBar.markElementAsSelected(atIndex: position!)
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        if slideBarClicked {
            slideBarClicked = false
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : SimpleDishTableViewCell? = tableView.dequeueReusableCellWithIdentifier("simpleDishCell") as? SimpleDishTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "SimpleDishCell", bundle: nil), forCellReuseIdentifier: "simpleDishCell")
            cell = tableView.dequeueReusableCellWithIdentifier("simpleDishCell") as? SimpleDishTableViewCell
        }
        cell?.dishName = menuItems[indexPath.section].dishes?[indexPath.row].name
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return menuItems.count
    }
    
    

}
