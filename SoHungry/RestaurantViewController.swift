//
//  RestaurantViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 8/22/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class RestaurantViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var restaurantId : String?
    
    var restaurant : Restaurant?
    
    var info : [String : String] = [String : String]()
    
    var hotDishes : [Dish]?

    @IBOutlet weak var topViewContainer: ViewItemTopUIView!
    
    @IBOutlet weak var infoTableView: UITableView!
    
    @IBOutlet weak var hotDishesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        restaurantId = "sbXAe8QCye"
        loadData()
        // Do any additional setup after loading the view.
    }
    
    func loadData() {
        if (restaurantId != nil) {
            let request : GetRestaurantByIdRequest = GetRestaurantByIdRequest(id: restaurantId!)
            DataAccessor(serviceConfiguration: ParseConfiguration()).getRestaurantById(request) { (response) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    self.restaurant = (response?.result)!
                    if self.restaurant != nil {
                        self.topViewContainer.name = self.restaurant?.name
                        self.topViewContainer.englishName = self.restaurant?.englishName
                        self.topViewContainer.backgroundImageURL = self.restaurant?.picture?.original
                    }
                    self.info["address"] = self.restaurant?.address
                    self.info["hours"] = self.restaurant?.hours
                    self.info["phone"] = self.restaurant?.phone
                    self.hotDishes = self.restaurant?.hotDishes
                    self.infoTableView.reloadData()
                    self.hotDishesTableView.reloadData()
                });
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView == infoTableView {
            return info.count + 1
        } else if tableView == hotDishesTableView {
            if hotDishes != nil {
                return hotDishes!.count
            } else {
                return 0
            }
        } else {
            return 0
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView == infoTableView {
            if info.count > 0 {
                return 1
            }
        } else {
            return 1
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == infoTableView {
            if indexPath.row <= (info.count - 1) {
                var cell : IconInfoCellTableViewCell? = tableView.dequeueReusableCellWithIdentifier("iconInfoCell") as? IconInfoCellTableViewCell
                if cell == nil {
                    tableView.registerNib(UINib(nibName: "IconInfoCell", bundle: nil), forCellReuseIdentifier: "iconInfoCell")
                    cell = tableView.dequeueReusableCellWithIdentifier("iconInfoCell") as? IconInfoCellTableViewCell
                }
                return cell!
            } else {
                var cell : SimpleCouponTableViewCell? = tableView.dequeueReusableCellWithIdentifier("simpleCouponCell") as? SimpleCouponTableViewCell
                if cell == nil {
                    tableView.registerNib(UINib(nibName: "SimpleCouponCell", bundle: nil), forCellReuseIdentifier: "simpleCouponCell")
                    cell = tableView.dequeueReusableCellWithIdentifier("simpleCouponCell") as? SimpleCouponTableViewCell
                }
                return cell!
            }
            
        } else if tableView == hotDishesTableView {
            var cell : NameOnlyDishTableViewCell? = tableView.dequeueReusableCellWithIdentifier("nameOnlyDishCell") as? NameOnlyDishTableViewCell
            if cell == nil {
                tableView.registerNib(UINib(nibName: "NameOnlyDishCell", bundle: nil), forCellReuseIdentifier: "nameOnlyDishCell")
                cell = tableView.dequeueReusableCellWithIdentifier("nameOnlyDishCell") as? NameOnlyDishTableViewCell
            }
            return cell!
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == infoTableView {
            if indexPath.row <= (info.count - 1) {
                let key = info.keys.array[indexPath.row] as String
                let infoCell : IconInfoCellTableViewCell = cell as! IconInfoCellTableViewCell
                infoCell.info = info[key]
            }
        } else if tableView == hotDishesTableView {
            if hotDishes != nil {
                let dishCell : NameOnlyDishTableViewCell = cell as! NameOnlyDishTableViewCell
                let hotDish : Dish = (hotDishes![indexPath.row])
                dishCell.model = hotDish
            }
            cell.addSubview(getSeperatorView(forCell: cell))
        }
        
    }
    
    func getSeperatorView(forCell cell : UITableViewCell) -> UIView {
        let seperatorView = UIView(frame: CGRectMake(0, 0, cell.frame.size.width, 10))
        seperatorView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        return seperatorView
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == infoTableView {
            if indexPath.row <= (info.count - 1) {
                return 30
            } else {
                return 48
            }
        } else if tableView == hotDishesTableView {
            return DishTableViewCell.height + 10
        } else {
            return 100
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == infoTableView {
            return 0
        } else {
            return 26
        }
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == hotDishesTableView {
            let headerView = AllDishesHeaderView()
//            headerView.backgroundColor = UIColor.groupTableViewBackgroundColor()
            return headerView
        } else {
            return UIView()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
