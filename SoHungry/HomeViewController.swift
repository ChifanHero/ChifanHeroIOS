//
//  FirstViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 7/29/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var promotionsTable: UITableView!
    
    @IBAction func showHottestRestaurants(sender: AnyObject) {
        self.performSegueWithIdentifier("showRestaurants", sender: "hottest")
    }
    
    @IBAction func showNearstRestaurants(sender: AnyObject) {
        self.performSegueWithIdentifier("showRestaurants", sender: "nearest")
    }
    
    var promotions : [Promotion] = []
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return promotions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let type = promotions[indexPath.section].type
        
        if type == PromotionType.Restaurant {
            var cell : RestaurantTableViewCell? = tableView.dequeueReusableCellWithIdentifier("restaurantCell") as? RestaurantTableViewCell
            if cell == nil {
                tableView.registerNib(UINib(nibName: "RestaurantCell", bundle: nil), forCellReuseIdentifier: "restaurantCell")
                cell = tableView.dequeueReusableCellWithIdentifier("restaurantCell") as? RestaurantTableViewCell
            }
            return cell!
        } else if type == PromotionType.Dish {
            var cell : DishTableViewCell? = tableView.dequeueReusableCellWithIdentifier("dishCell") as? DishTableViewCell
            if cell == nil {
                tableView.registerNib(UINib(nibName: "DishCell", bundle: nil), forCellReuseIdentifier: "dishCell")
                cell = tableView.dequeueReusableCellWithIdentifier("dishCell") as? DishTableViewCell
            }
            return cell!
        } else if type == PromotionType.Coupon {
            var cell : CouponTableViewCell? = tableView.dequeueReusableCellWithIdentifier("couponCell") as? CouponTableViewCell
            if cell == nil {
                tableView.registerNib(UINib(nibName: "CouponCell", bundle: nil), forCellReuseIdentifier: "couponCell")
                cell = tableView.dequeueReusableCellWithIdentifier("couponCell") as? CouponTableViewCell
            }
            return cell!
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        var promotionCell : ModelTableViewCell = cell as! ModelTableViewCell
        let promotion = promotions[indexPath.section]
        if promotion.type == PromotionType.Restaurant {
            promotionCell.model = promotion.restaurant
        } else if promotion.type == PromotionType.Dish {
            promotionCell.model = promotion.dish
        } else if promotion.type == PromotionType.Coupon {
            promotionCell.model = promotion.coupon
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

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTableData()
    }
    
    func loadTableData() {
        let getPromotionsRequest = GetPromotionsRequest()
        getPromotionsRequest.limit = 10
        getPromotionsRequest.offset = 0
        DataAccessor(serviceConfiguration: ParseConfiguration()).getPromotions(getPromotionsRequest) { (response) -> Void in
            //
            self.promotions = (response?.results)!
//            Queue.MainQueue.perform({
//                
//            })
            dispatch_async(dispatch_get_main_queue(), {
                self.promotionsTable.reloadData()
            });
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRestaurants" {
            let restaurantsController : RestaurantsTableViewController = segue.destinationViewController as! RestaurantsTableViewController
            if let s = sender as? String {
                if s == "hottest" {
                    restaurantsController.sortParameter = SortParameter.Hotness
                    restaurantsController.sortOrder = SortOrder.Decrease
                } else if s == "nearest" {
                    restaurantsController.sortParameter = SortParameter.Distance
                    restaurantsController.sortOrder = SortOrder.Increase
                }
            }
        }
    }

}

