//
//  RestaurantsTableViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 8/20/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class RestaurantsTableViewController: UITableViewController {
    
    var request : GetRestaurantsRequest?
    
    var restaurants : [Restaurant] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTableData()
    }
    
    func loadTableData() {
        if request != nil {
            DataAccessor(serviceConfiguration: ParseConfiguration()).getRestaurants(request!) { (response) -> Void in
                self.restaurants = (response?.results)!
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                });
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        return headerView
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return restaurants.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : RestaurantTableViewCell? = tableView.dequeueReusableCellWithIdentifier("restaurantCell") as? RestaurantTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "RestaurantCell", bundle: nil), forCellReuseIdentifier: "restaurantCell")
            cell = tableView.dequeueReusableCellWithIdentifier("restaurantCell") as? RestaurantTableViewCell
        }
        return cell!
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let restaurantCell : RestaurantTableViewCell = cell as! RestaurantTableViewCell
        restaurantCell.model = restaurants[indexPath.section]
    }
    
    
}
