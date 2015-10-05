//
//  RestaurantViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 8/22/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class RestaurantViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HeaderViewDelegate{
    
    var restaurantId : String?
    
    var restaurant : Restaurant?
    
    @IBOutlet weak var containerScrollView: UIScrollView!
    
    @IBOutlet weak var infoTableView: UITableView!
    var info : [String : String] = [String : String]()
    
    var hotDishes : [Dish]?
    
    private let infoToResource : [String : String] = ["address" : "gps", "hours" : "clock", "phone" : "phone"]

    @IBOutlet weak var topViewContainer: ViewItemTopUIView!
    
    
    
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
                    self.adjustUI()
                });
            }
        }
    }
    
    private func adjustUI() {
        adjustDishTableViewHeight()
        adjustContainerViewHeight()
    }
    
    private func adjustDishTableViewHeight() {
        let originalFrame : CGRect = self.hotDishesTableView.frame
        self.hotDishesTableView.frame = CGRectMake(originalFrame.origin.x, originalFrame.origin.y, originalFrame.size.width, self.hotDishesTableView.contentSize.height)
    }
    
    private func adjustContainerViewHeight() {
        var contentRect : CGRect = CGRectZero
        for subView : UIView in self.containerScrollView.subviews {
            contentRect = CGRectUnion(contentRect, subView.frame)
        }
        self.containerScrollView.contentSize = CGSizeMake(contentRect.width, contentRect.height - (self.navigationController?.navigationBar.frame.size.height)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView == infoTableView {
            return info.count + 1
        } else if tableView == hotDishesTableView {
            return 1
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
            if hotDishes != nil {
               return (hotDishes?.count)!
            } else {
                return 0
            }
            
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == infoTableView {
            if indexPath.row <= (info.count - 1) {
                var cell : InfoTableViewCell? = tableView.dequeueReusableCellWithIdentifier("infoCell") as? InfoTableViewCell
                if cell == nil {
                    tableView.registerNib(UINib(nibName: "InfoCell", bundle: nil), forCellReuseIdentifier: "infoCell")
                    cell = tableView.dequeueReusableCellWithIdentifier("infoCell") as? InfoTableViewCell
                }
                let key = Array(info.keys)[indexPath.row] as String
                cell!.info = info[key]
                cell!.iconResourceName = infoToResource[key]
                return cell!
            } else {
                var cell : InfoCouponTableViewCell? = tableView.dequeueReusableCellWithIdentifier("infoCouponCell") as? InfoCouponTableViewCell
                if cell == nil {
                    tableView.registerNib(UINib(nibName: "InfoCouponCell", bundle: nil), forCellReuseIdentifier: "infoCouponCell")
                    cell = tableView.dequeueReusableCellWithIdentifier("infoCouponCell") as? InfoCouponTableViewCell
                }
                return cell!
            }
            
        } else if tableView == hotDishesTableView {
            var cell : NameOnlyDishTableViewCell? = tableView.dequeueReusableCellWithIdentifier("nameOnlyDishCell") as? NameOnlyDishTableViewCell
            if cell == nil {
                tableView.registerNib(UINib(nibName: "NameOnlyDishCell", bundle: nil), forCellReuseIdentifier: "nameOnlyDishCell")
                cell = tableView.dequeueReusableCellWithIdentifier("nameOnlyDishCell") as? NameOnlyDishTableViewCell
            }
            let hotDish : Dish = (hotDishes![indexPath.section])
            cell?.model = hotDish
            return cell!
        } else {
            return UITableViewCell()
        }
    }
    
//    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        if tableView == infoTableView {
//            if indexPath.row <= (info.count - 1) {
//                let key = Array(info.keys)[indexPath.row] as String
//                let infoCell : InfoTableViewCell = cell as! InfoTableViewCell
//                infoCell.info = info[key]
//                infoCell.iconResourceName = iconResource[indexPath.row]
//            }
//        } else if tableView == hotDishesTableView {
//            if hotDishes != nil {
//                let dishCell : NameOnlyDishTableViewCell = cell as! NameOnlyDishTableViewCell
//                let hotDish : Dish = (hotDishes![indexPath.row])
//                dishCell.model = hotDish
//            }
//            cell.addSubview(getSeperatorView(forCell: cell))
//        }
//        
//    }
    
//    func getSeperatorView(forCell cell : UITableViewCell) -> UIView {
//        let seperatorView = UIView(frame: CGRectMake(0, 0, cell.frame.size.width, 10))
//        seperatorView.backgroundColor = UIColor.groupTableViewBackgroundColor()
//        return seperatorView
//    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == infoTableView {
            if indexPath.row <= (info.count - 1) {
                return 35
            } else {
                return 62
            }
        } else if tableView == hotDishesTableView {
            return 82
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == infoTableView {
            return 0
        } else if tableView == hotDishesTableView {
            if section == 0 {
                return 44
            } else {
                return 0
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == hotDishesTableView {
            let headerView = AllDishesHeaderView(frame: CGRectMake(0, 0, self.hotDishesTableView.frame.size.width, 44))
            headerView.delegate = self
            return headerView
        } else {
            return nil
        }
    }
    
    func headerViewActionButtonPressed() {
        self.performSegueWithIdentifier("showAllDishes", sender: self.restaurantId)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showAllDishes" {
            let restaurantAllDishesController : RestaurantAllDishViewController = segue.destinationViewController as! RestaurantAllDishViewController
            restaurantAllDishesController.restaurantId = sender as? String
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
