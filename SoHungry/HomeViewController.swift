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
    
    var promotions : [Promotion] = []
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if promotions.count == 0 {
            return 0
        } else {
            return promotions.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let type = promotions[indexPath.row].type
        
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
//        let restaurantCell : RestaurantTableViewCell = cell as! RestaurantTableViewCell
//        let restaurant : Restaurant = Restaurant()
//        restaurant.name = "韶山冲"
//        restaurant.distance = "10.5 mi"
//        restaurant.address = "222 ddd lane, sss, ddd, 1234"
//        let picture : Picture = Picture()
//        picture.original = "http://files.parsetfss.com/c25308ff-6a43-40e0-a09a-2596427b692c/tfss-28c48a2f-70d1-42c4-83d0-4d57bb1b67e9-Shao%20mountain.jpeg"
//        restaurant.picture = picture
//        restaurantCell.model = restaurant
        var promotionCell : ModelTableViewCell = cell as! ModelTableViewCell
        let promotion = promotions[indexPath.row]
        if promotion.type == PromotionType.Restaurant {
            promotionCell.model = promotion.restaurant
        } else if promotion.type == PromotionType.Dish {
            promotionCell.model = promotion.dish
        } else if promotion.type == PromotionType.Coupon {
            promotionCell.model = promotion.coupon
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("home view did load")
        let getPromotionsRequest = GetPromotionsRequest()
        getPromotionsRequest.limit = 10
        getPromotionsRequest.offset = 0
        DataAccessor(serviceConfiguration: ParseConfiguration()).getPromotions(getPromotionsRequest) { (response) -> Void in
            //
            self.promotions = (response?.results)!
            dispatch_async(dispatch_get_main_queue(), {
                self.promotionsTable.reloadData()
            });
            Queue.MainQueue.perform({
                self.promotionsTable.reloadData()
            })
        }

    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }

}

