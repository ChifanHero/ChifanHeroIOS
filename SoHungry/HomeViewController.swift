//
//  FirstViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 7/29/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var promotionsTable: UITableView!
    
    @IBOutlet weak var containerView: UIScrollView!
    
    @IBOutlet weak var topContainerView: UIView!
    
    @IBAction func showHottestRestaurants(sender: AnyObject) {
        self.performSegueWithIdentifier("showRestaurants", sender: "hottest")
    }
    
    @IBAction func showNearstRestaurants(sender: AnyObject) {
        self.performSegueWithIdentifier("showRestaurants", sender: "nearest")
    }
    
    @IBAction func showDishLists(sender: AnyObject) {
        self.performSegueWithIdentifier("showLists", sender: self)
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
            cell?.model = promotions[indexPath.section].restaurant
            return cell!
        } else if type == PromotionType.Dish {
            var cell : DishTableViewCell? = tableView.dequeueReusableCellWithIdentifier("dishCell") as? DishTableViewCell
            if cell == nil {
                tableView.registerNib(UINib(nibName: "DishCell", bundle: nil), forCellReuseIdentifier: "dishCell")
                cell = tableView.dequeueReusableCellWithIdentifier("dishCell") as? DishTableViewCell
            }
            cell?.model = promotions[indexPath.section].dish
            return cell!
        } else if type == PromotionType.Coupon {
            var cell : CouponTableViewCell? = tableView.dequeueReusableCellWithIdentifier("couponCell") as? CouponTableViewCell
            if cell == nil {
                tableView.registerNib(UINib(nibName: "CouponCell", bundle: nil), forCellReuseIdentifier: "couponCell")
                cell = tableView.dequeueReusableCellWithIdentifier("couponCell") as? CouponTableViewCell
            }
            cell?.model = promotions[indexPath.section].coupon
            return cell!
        } else {
            return UITableViewCell()
        }
    }
    
//    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        var promotionCell : ModelTableViewCell = cell as! ModelTableViewCell
//        let promotion = promotions[indexPath.section]
//        if promotion.type == PromotionType.Restaurant {
//            promotionCell.model = promotion.restaurant
//        } else if promotion.type == PromotionType.Dish {
//            promotionCell.model = promotion.dish
//        } else if promotion.type == PromotionType.Coupon {
//            promotionCell.model = promotion.coupon
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.promotionsTable.separatorStyle = UITableViewCellSeparatorStyle.None
        loadTableData()
    }
    
    private func adjustUI() {
        adjustPromotionTableHeight()
        adjustContainerViewHeight()
    }
    
    private func adjustPromotionTableHeight() {
        let originalFrame : CGRect = self.promotionsTable.frame
        self.promotionsTable.frame = CGRectMake(originalFrame.origin.x, originalFrame.origin.y, originalFrame.size.width, self.promotionsTable.contentSize.height)
    }
    
    private func adjustContainerViewHeight() {
        var contentRect : CGRect = CGRectZero
        for subView : UIView in self.containerView.subviews {
            contentRect = CGRectUnion(contentRect, subView.frame)
        }
        self.containerView.contentSize = CGSizeMake(contentRect.width, contentRect.height)
    }
    
    override func viewWillAppear(animated: Bool) {
        let selectedCellIndexPath : NSIndexPath? = self.promotionsTable.indexPathForSelectedRow
        if selectedCellIndexPath != nil {
            self.promotionsTable.deselectRowAtIndexPath(selectedCellIndexPath!, animated: false)
        }
    }
    
    func loadTableData() {
        let getPromotionsRequest = GetPromotionsRequest()
        getPromotionsRequest.limit = 10
        getPromotionsRequest.offset = 0
        DataAccessor(serviceConfiguration: ParseConfiguration()).getPromotions(getPromotionsRequest) { (response) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                self.promotions = (response?.results)!
                self.promotionsTable.reloadData()
                self.adjustUI()
            });
        }
    }
    
    private func getContainerViewSize() -> CGFloat {
        return topContainerView.frame.size.height + 15 + self.promotionsTable.contentSize.height
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if promotions[indexPath.section].type == PromotionType.Restaurant {
            return RestaurantTableViewCell.height
        } else if promotions[indexPath.section].type == PromotionType.Dish {
            return DishTableViewCell.height
        } else if promotions[indexPath.section].type == PromotionType.Coupon {
            return CouponTableViewCell.height
        }
        return 200
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let type = promotions[indexPath.section].type
        if type == PromotionType.Restaurant {
            let restaurant : Restaurant = promotions[indexPath.section].restaurant!
            self.performSegueWithIdentifier("showRestaurant", sender: restaurant.id)
        } else if type == PromotionType.Dish {
            let dish : Dish = promotions[indexPath.section].dish!
            self.performSegueWithIdentifier("showDish", sender: dish.id)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRestaurants" {
            let restaurantsController : RestaurantsTableViewController = segue.destinationViewController as! RestaurantsTableViewController
            let getRestaurantsRequest = GetRestaurantsRequest()
            getRestaurantsRequest.limit = 10
            getRestaurantsRequest.offset = 0
            if let s = sender as? String {
                if s == "hottest" {
                    getRestaurantsRequest.sortParameter = SortParameter.Hotness
                    getRestaurantsRequest.sortOrder = SortOrder.Decrease
                    restaurantsController.request = getRestaurantsRequest
                } else if s == "nearest" {
                    getRestaurantsRequest.sortParameter = SortParameter.Distance
                    getRestaurantsRequest.sortOrder = SortOrder.Increase
                    restaurantsController.request = getRestaurantsRequest
                }
            }
        } else if segue.identifier == "showLists" {
            let getListsRequest = GetListsRequest()
            getListsRequest.limit = 10
            getListsRequest.offset = 0
            let listsController : ListsTableViewController = segue.destinationViewController as! ListsTableViewController
            listsController.request = getListsRequest
        } else if segue.identifier == "showRestaurant" {
            let restaurantController : RestaurantViewController = segue.destinationViewController as! RestaurantViewController
            restaurantController.restaurantId = sender as? String
        } else if segue.identifier == "showDish" {
            let dishController : DishViewController = segue.destinationViewController as! DishViewController
            dishController.dishId = sender as? String
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let bookmarkAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "收藏", handler:{action, indexpath in
            print("MORE•ACTION");
            tableView.setEditing(false, animated: true)
            
        });
        bookmarkAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        return [bookmarkAction];
    }

}

