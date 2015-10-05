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
    
    var indicatorContainer : UIView?
    var indicator : UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIndicator()
        loadTableData()
    }
    
    func loadTableData() {
        self.showIndicator()
        if request != nil {
            DataAccessor(serviceConfiguration: ParseConfiguration()).getRestaurants(request!) { (response) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    self.restaurants = (response?.results)!
//                    self.dismissIndicator()
                    self.tableView.reloadData()
//                    self.tableView.hidden = false
                    //self.dismissIndicator()
                });
            }
        }
    }
    
    func setupIndicator() {
        indicatorContainer = UIView(frame: self.view.frame)
        indicatorContainer?.opaque = true
        indicatorContainer?.backgroundColor = UIColor.blackColor()
        indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        indicator?.center = self.view.center
        indicatorContainer?.addSubview(indicator!)
        
    }
    
    func showIndicator() {
        indicator?.startAnimating()
    }
    
    func dismissIndicator() {
        indicator?.stopAnimating()
        indicatorContainer?.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return RestaurantTableViewCell.height
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 10
        }
        
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let restaurantSelected : Restaurant = restaurants[indexPath.row]
        performSegueWithIdentifier("showRestaurant", sender: restaurantSelected.id)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRestaurant" {
            let restaurantController : RestaurantViewController = segue.destinationViewController as! RestaurantViewController
            restaurantController.restaurantId = sender as? String
        }
    }
    
    
}
