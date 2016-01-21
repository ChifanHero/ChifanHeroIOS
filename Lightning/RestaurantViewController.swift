//
//  RestaurantViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 8/22/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class RestaurantViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HeaderViewDelegate, ImageProgressiveTableViewDelegate {
    
    var restaurantId : String?
    
    var restaurant : Restaurant?
    
    var pendingOperations = PendingOperations()
    var images = [PhotoRecord]()
    @IBOutlet weak var messageView: UIView!
    
    @IBOutlet weak var waitingView: UIView!
    @IBOutlet weak var containerScrollView: UIScrollView!
    
    @IBOutlet weak var infoTableView: UITableView!
    var info : [String : String] = [String : String]()
    
    var hotDishes : [Dish] = [Dish]()
    
    private let infoToResource : [String : String] = ["address" : "gps", "hours" : "clock", "phone" : "phone"]
    
    var localSearchResponse:MKLocalSearchResponse!

    @IBOutlet weak var hotDishesContainerView: UIView!
    @IBOutlet weak var topViewContainer: ViewItemTopUIView!
    
    @IBOutlet weak var hotDishesTableView: ImageProgressiveTableView!
    @IBOutlet weak var message: UILabel!
    
    static let INFO_ROW_HEIGHT : CGFloat = 35
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hotDishesTableView.allowsSelection = false
        self.waitingView.hidden = false
        self.hotDishesTableView.imageDelegate = self
        loadData()
        topViewContainer.baseVC = self
        // Do any additional setup after loading the view.
    }
    
    func loadData() {
        if (restaurantId != nil) {
            let request : GetRestaurantByIdRequest = GetRestaurantByIdRequest(id: restaurantId!)
            DataAccessor(serviceConfiguration: ParseConfiguration()).getRestaurantById(request) { (response) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    if response?.result != nil {
                        self.restaurant = (response?.result)!
                        if self.restaurant != nil {
                            self.topViewContainer.restaurantId = self.restaurant?.id
                            self.topViewContainer.name = self.restaurant?.name
                            self.topViewContainer.englishName = self.restaurant?.englishName
                            self.topViewContainer.backgroundImageURL = self.restaurant?.picture?.original
                            if self.restaurant?.address != nil {
                                self.info["address"] = self.restaurant?.address
                            }
                            if self.restaurant?.hours != nil {
                                self.info["hours"] = self.restaurant?.hours
                            }
                            if self.restaurant?.phone != nil {
                                self.info["phone"] = self.restaurant?.phone
                            }
                            if self.restaurant != nil && self.restaurant!.hotDishes != nil {
                                self.hotDishes += (self.restaurant?.hotDishes)!
                            }
                            if self.hotDishes.count == 0 {
                                self.hotDishesTableView.hidden = true
                                self.messageView.hidden = false
                                self.message.text = "此餐厅还未开通菜单功能"
                                
                            } else {
                                self.hotDishesTableView.hidden = false
                            }
                            if self.restaurant?.likeCount != nil {
                                self.topViewContainer.likeCount = self.restaurant?.likeCount
                            }
                            if self.restaurant?.dislikeCount != nil {
                                self.topViewContainer.dislikeCount = self.restaurant?.dislikeCount
                            }
                            if self.restaurant?.neutralCount != nil {
                                self.topViewContainer.neutralCount = self.restaurant?.neutralCount
                            }
                            if self.restaurant?.favoriteCount != nil {
                                self.topViewContainer.bookmarkCount = self.restaurant?.favoriteCount
                            }
                            self.fetchImageDetails()
                        }
                        
                    }
                    
                    self.infoTableView.reloadData()
                    self.hotDishesTableView.reloadData()
                    self.adjustUI()
                    self.waitingView.hidden = true
                });
            }
        }
    }
    
    private func adjustUI() {
        adjustInfoTableViewHeight()
        adjustDishTableViewHeight()
        adjustContainerViewHeight()
    }
    
    private func adjustInfoTableViewHeight() {
        let height : CGFloat = CGFloat(self.info.count) * RestaurantViewController.INFO_ROW_HEIGHT
        let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: self.infoTableView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute:NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: height);
        heightConstraint.priority = 1000
        self.infoTableView.addConstraint(heightConstraint);
        self.view.layoutIfNeeded()
    }
    
    private func fetchImageDetails() {
        for dish : Dish in self.hotDishes {
            var url = dish.picture?.original
            if url == nil {
                url = ""
            }
            let record = PhotoRecord(name: "", url: NSURL(string: url!)!)
            self.images.append(record)
        }
    }
    
    private func adjustDishTableViewHeight() {
        if self.hotDishesTableView.hidden == false {
//            let originalFrame : CGRect = self.hotDishesTableView.frame
//            self.hotDishesTableView.frame = CGRectMake(originalFrame.origin.x, originalFrame.origin.y, originalFrame.size.width, self.hotDishesTableView.contentSize.height)
            let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: self.hotDishesTableView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute:NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.hotDishesTableView.contentSize.height);
            heightConstraint.priority = 1000
            self.hotDishesTableView.addConstraint(heightConstraint);
            self.view.layoutIfNeeded()

        }
        
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
            return info.count
        } else if tableView == hotDishesTableView {
            return hotDishes.count
        } else {
            return 0
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == infoTableView {
            var cell : InfoTableViewCell? = tableView.dequeueReusableCellWithIdentifier("infoCell") as? InfoTableViewCell
            if cell == nil {
                tableView.registerNib(UINib(nibName: "InfoCell", bundle: nil), forCellReuseIdentifier: "infoCell")
                cell = tableView.dequeueReusableCellWithIdentifier("infoCell") as? InfoTableViewCell
            }
            let key = Array(info.keys)[indexPath.row] as String
            cell!.info = info[key]
            cell!.iconResourceName = infoToResource[key]
            return cell!
//            else {
//                var cell : InfoCouponTableViewCell? = tableView.dequeueReusableCellWithIdentifier("infoCouponCell") as? InfoCouponTableViewCell
//                if cell == nil {
//                    tableView.registerNib(UINib(nibName: "InfoCouponCell", bundle: nil), forCellReuseIdentifier: "infoCouponCell")
//                    cell = tableView.dequeueReusableCellWithIdentifier("infoCouponCell") as? InfoCouponTableViewCell
//                }
//                return cell!
//            }
            
        } else if tableView == hotDishesTableView {
            var cell : NameOnlyDishTableViewCell? = tableView.dequeueReusableCellWithIdentifier("nameOnlyDishCell") as? NameOnlyDishTableViewCell
            if cell == nil {
                tableView.registerNib(UINib(nibName: "NameOnlyDishCell", bundle: nil), forCellReuseIdentifier: "nameOnlyDishCell")
                cell = tableView.dequeueReusableCellWithIdentifier("nameOnlyDishCell") as? NameOnlyDishTableViewCell
            }
            let hotDish : Dish = (hotDishes[indexPath.row])
            let imageDetails = imageForIndexPath(tableView: self.hotDishesTableView, indexPath: indexPath)
            cell?.setUp(dish: hotDish, image: imageDetails.image!)
            switch (imageDetails.state){
                case .New:
                    if (!tableView.dragging && !tableView.decelerating) {
                        self.hotDishesTableView.startOperationsForPhotoRecord(&pendingOperations, photoDetails: imageDetails,indexPath:indexPath)
                    }
                default: break
            }
            return cell!
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == infoTableView {
            let currentCell = tableView.cellForRowAtIndexPath(indexPath) as! InfoTableViewCell
            if(currentCell.info == info["address"]){
                var localSearchRequest:MKLocalSearchRequest!
                var localSearch:MKLocalSearch!
                
                localSearchRequest = MKLocalSearchRequest()
                localSearchRequest.naturalLanguageQuery = info["address"]
                localSearch = MKLocalSearch(request: localSearchRequest)
                localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
                    
                    self.localSearchResponse = localSearchResponse
                    let alert = UIAlertController(title: "打开地图", message: "是否打开地图导航", preferredStyle: UIAlertControllerStyle.ActionSheet)
                    
                    let goAction = UIAlertAction(title: "确定", style: .Destructive, handler: self.doUsingAppleMap)
                    let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: self.cancelUsingAppleMap)
                    
                    alert.addAction(goAction)
                    alert.addAction(cancelAction)
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
            
            if currentCell.info == info["phone"] {
                let alert = UIAlertController(title: "呼叫", message: "呼叫\(currentCell.info!)", preferredStyle: UIAlertControllerStyle.ActionSheet)
                
                let goAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Destructive, handler: { (action) -> Void in
                    if let url = NSURL(string: "tel://\(currentCell.info!)") {
                        UIApplication.sharedApplication().openURL(url)
                    }
                })
                let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
                
                alert.addAction(goAction)
                alert.addAction(cancelAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
            print(currentCell.info)
            print(info["phone"])
        
        self.infoTableView.deselectRowAtIndexPath(indexPath, animated: true)    
        }
        
    }
    
    func doUsingAppleMap(alertAction: UIAlertAction!) -> Void {
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
        
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.info["address"]
        mapItem.openInMapsWithLaunchOptions(options)
    }
    
    func cancelUsingAppleMap(alertAction: UIAlertAction!) {
        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == infoTableView {
            if indexPath.row <= (info.count - 1) {
                return RestaurantViewController.INFO_ROW_HEIGHT
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
            return 44
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
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        if tableView == hotDishesTableView{
            let bookmarkAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "收藏", handler:{(action, indexpath) -> Void in
                self.addToFavorites(indexPath)
                tableView.setEditing(false, animated: true)
            });
            bookmarkAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
            
            let likeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "好评", handler:{(action, indexpath) -> Void in
                self.rateDish(indexPath, ratingType: RatingTypeEnum.like)
                tableView.setEditing(false, animated: true)
            });
            likeAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
            
            let neutralAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "一般", handler:{(action, indexpath) -> Void in
                self.rateDish(indexPath, ratingType: RatingTypeEnum.neutral)
                tableView.setEditing(false, animated: true)
            });
            neutralAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
            
            let dislikeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "差评", handler:{(action, indexpath) -> Void in
                self.rateDish(indexPath, ratingType: RatingTypeEnum.dislike)
                tableView.setEditing(false, animated: true)
            });
            dislikeAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
            
            return [bookmarkAction, dislikeAction, neutralAction, likeAction];
        }
        return [];
    }
    
    private func addToFavorites(indexPath: NSIndexPath){
        
    }
    
    private func rateDish(indexPath: NSIndexPath, ratingType: RatingTypeEnum){
        
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
    
    func imageForIndexPath(tableView tableView : UITableView, indexPath : NSIndexPath) -> PhotoRecord {
        return self.images[indexPath.row]
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.hotDishesTableView.cancellImageLoadingForUnvisibleCells(&pendingOperations)
        self.hotDishesTableView.loadImageForVisibleCells(&pendingOperations)
        pendingOperations.downloadQueue.suspended = false
    }
    
    // As soon as the user starts scrolling, suspend all operations
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        pendingOperations.downloadQueue.suspended = true
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            if scrollView == self.hotDishesTableView {
                self.hotDishesTableView.cancellImageLoadingForUnvisibleCells(&pendingOperations)
                self.hotDishesTableView.loadImageForVisibleCells(&pendingOperations)
                pendingOperations.downloadQueue.suspended = false
            }
        }
    }
    
}
