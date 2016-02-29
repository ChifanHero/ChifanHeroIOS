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

class RestaurantViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HeaderViewDelegate, ImageProgressiveTableViewDelegate, UIScrollViewDelegate {
    
    var restaurantId : String?
    
    var restaurant : Restaurant?
    
    var pendingOperations = PendingOperations()
    var images = [PhotoRecord]()

    @IBOutlet weak var messageView: NotAvailableMessageView!
    
    @IBOutlet weak var waitingView: UIView!
    @IBOutlet weak var containerScrollView: UIScrollView!
    
    @IBOutlet weak var infoTableView: UITableView!
    var info : [String : String] = [String : String]()
    
    var hotDishes : [Dish] = [Dish]()
    
    @IBOutlet weak var waitingIndicator: UIActivityIndicatorView!
    
    
    private let infoToResource : [String : String] = ["address" : "gps", "hours" : "clock", "phone" : "phone"]
    
    var localSearchResponse:MKLocalSearchResponse!

    @IBOutlet weak var hotDishesContainerView: UIView!
    @IBOutlet weak var topViewContainer: ViewItemTopUIView!
    
    @IBOutlet weak var hotDishesTableView: ImageProgressiveTableView!
    var ratingAndFavoriteExecutor: RatingAndBookmarkExecutor?
    
    static let INFO_ROW_HEIGHT : CGFloat = 35
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hotDishesTableView.allowsSelection = false
        self.waitingView.hidden = false
        self.waitingIndicator.startAnimating()
        self.hotDishesTableView.imageDelegate = self
        self.containerScrollView.delegate = self
        self.containerScrollView.showsVerticalScrollIndicator = false
        loadData()
        topViewContainer.baseVC = self
        ratingAndFavoriteExecutor = RatingAndBookmarkExecutor(baseVC: self)
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
                                self.messageView.votes = self.restaurant?.votes
                                self.messageView.restaurantId = self.restaurant?.id
                                
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
                            if self.restaurant?.picture != nil {
                                self.topViewContainer.backgroundImageURL = self.restaurant?.picture?.original
                            }
                            self.fetchImageDetails()
                        }
                        
                    }
                    
                    self.infoTableView.reloadData()
                    self.hotDishesTableView.reloadData()
                    self.adjustUI()
                    self.waitingIndicator.stopAnimating()
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
            let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: self.hotDishesTableView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute:NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.hotDishesTableView.contentSize.height);
            heightConstraint.priority = 1000
            self.hotDishesTableView.addConstraint(heightConstraint);
            self.view.layoutIfNeeded()

        }
        
    }
    
    private func adjustContainerViewHeight() {
        var contentRect : CGRect = CGRectZero
        for subView : UIView in self.containerScrollView.subviews {
            if subView.hidden == false {
                contentRect = CGRectUnion(contentRect, subView.frame)
            }
        }
        self.containerScrollView.contentSize = CGSizeMake(contentRect.width, contentRect.height - (self.navigationController?.navigationBar.frame.size.height)!)
        self.view.layoutIfNeeded()
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
            
        } else if tableView == hotDishesTableView {
            var cell : NameImageDishTableViewCell? = tableView.dequeueReusableCellWithIdentifier("nameImageDishCell") as? NameImageDishTableViewCell
            if cell == nil {
                tableView.registerNib(UINib(nibName: "NameImageDishCell", bundle: nil), forCellReuseIdentifier: "nameImageDishCell")
                cell = tableView.dequeueReusableCellWithIdentifier("nameImageDishCell") as? NameImageDishTableViewCell
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
        
        let dish : Dish = self.hotDishes[indexPath.row]
        var favoriteCount : Int = 0
        var likeCount : Int = 0
        var neutralCount : Int = 0
        var dislikeCount : Int = 0
        let objectId = dish.id!
        
        if dish.favoriteCount != nil {
            favoriteCount = dish.favoriteCount!
        }
        if dish.likeCount != nil {
            likeCount = dish.likeCount!
        }
        if dish.neutralCount != nil {
            neutralCount = dish.neutralCount!
        }
        if dish.dislikeCount != nil {
            dislikeCount = dish.dislikeCount!
        }
        
        if tableView == hotDishesTableView{
            let bookmarkAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "收藏\n\(favoriteCount)", handler:{(action, indexpath) -> Void in
                if (!UserContext.isValidUser()) {
                    self.popupSigninAlert()
                } else {
                    favoriteCount++
                    if dish.favoriteCount == nil {
                        dish.favoriteCount = 1
                    } else {
                        dish.favoriteCount!++
                    }
                    self.hotDishesTableView.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView("收藏\n\(favoriteCount)", index: 0)
                    self.addToFavorites(indexPath)
                }
                self.dismissActionViewWithDelay()
            });
            bookmarkAction.backgroundColor = UIColor(red: 0, green: 0.749, blue: 1, alpha: 1.0)
            
            let likeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "好吃\n\(likeCount)", handler:{(action, indexpath) -> Void in
                if (UserContext.isRatingTooFrequent(objectId)) {
                    JSSAlertView().warning(self, title: "评价太频繁")
                } else {
                    likeCount++
                    if dish.likeCount == nil {
                        dish.likeCount = 1
                    } else {
                        dish.likeCount!++
                    }
                    self.hotDishesTableView.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView("好吃\n\(likeCount)", index: 3)
                    self.rateDish(indexPath, ratingType: RatingTypeEnum.like)
                }
                self.dismissActionViewWithDelay()
            });
            likeAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0)
            
            let neutralAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "一般\n\(neutralCount)", handler:{(action, indexpath) -> Void in
                if (UserContext.isRatingTooFrequent(objectId)) {
                    JSSAlertView().warning(self, title: "评价太频繁")
                } else {
                    neutralCount++
                    if dish.neutralCount == nil {
                        dish.neutralCount = 1
                    } else {
                        dish.neutralCount!++
                    }
                    action.title = "一般\n\(neutralCount)"
                    self.hotDishesTableView.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView("一般\n\(neutralCount)", index: 2)
                    self.rateDish(indexPath, ratingType: RatingTypeEnum.neutral)
                }
                self.dismissActionViewWithDelay()
            });
            neutralAction.backgroundColor = UIColor(red: 1, green: 0.501, blue: 0, alpha: 1.0)
            
            let dislikeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "难吃\n\(dislikeCount)", handler:{(action, indexpath) -> Void in
                if (UserContext.isRatingTooFrequent(objectId)) {
                    JSSAlertView().warning(self, title: "评价太频繁")
                } else {
                    dislikeCount++
                    if dish.dislikeCount == nil {
                        dish.dislikeCount = 1
                    } else {
                        dish.dislikeCount!++
                    }
                    self.hotDishesTableView.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView("难吃\n\(dislikeCount)", index: 1)
                    self.rateDish(indexPath, ratingType: RatingTypeEnum.dislike)
                }
                self.dismissActionViewWithDelay()
            });
            dislikeAction.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 1.0)
            
            return [bookmarkAction, dislikeAction, neutralAction, likeAction];
        }
        return [];
    }
    
    private func addToFavorites(indexPath: NSIndexPath){
        let dish = self.hotDishes[indexPath.row]
        ratingAndFavoriteExecutor?.addToFavorites("dish", objectId: dish.id!, failureHandler: { (objectId) -> Void in
            for dish : Dish in self.hotDishes {
                if dish.id == objectId {
                    if dish.favoriteCount != nil {
                        dish.favoriteCount!--
                    }
                }
            }
        })
    }
    
    private func rateDish(indexPath: NSIndexPath, ratingType: RatingTypeEnum){
        let objectId: String? = self.hotDishes[indexPath.row].id
        let type = "dish"
        
        if ratingType == RatingTypeEnum.like {
            ratingAndFavoriteExecutor?.like(type, objectId: objectId!, failureHandler: { (objectId) -> Void in
                for dish : Dish in self.hotDishes {
                    if dish.id == objectId {
                        if dish.likeCount != nil {
                            dish.likeCount!--
                        }
                    }
                }
            })
        } else if ratingType == RatingTypeEnum.dislike {
            ratingAndFavoriteExecutor?.dislike(type, objectId: objectId!,failureHandler: { (objectId) -> Void in
                for dish : Dish in self.hotDishes {
                    if dish.id == objectId {
                        if dish.dislikeCount != nil {
                            dish.dislikeCount!--
                        }
                    }
                }
            })
        } else {
            ratingAndFavoriteExecutor?.neutral(type, objectId: objectId!,failureHandler: { (objectId) -> Void in
                for dish : Dish in self.hotDishes {
                    if dish.id == objectId {
                        if dish.neutralCount != nil {
                            dish.neutralCount!--
                        }
                    }
                }
            })
        }
    }
    
    private func popupSigninAlert() {
        let alertview = JSSAlertView().show(self, title: "请登录", text: nil, buttonText: "我知道了")
        alertview.setTextTheme(.Dark)
    }
    
    private func dismissActionViewWithDelay() {
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("dismissActionView"), userInfo: nil, repeats: false)
    }
    
    @objc private func dismissActionView() {
        self.hotDishesTableView.setEditing(false, animated: true)
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("reloadTable"), userInfo: nil, repeats: false)
    }
    
    @objc private func reloadTable() {
        self.hotDishesTableView.reloadData()
    }
    
    func headerViewActionButtonPressed() {
        self.performSegueWithIdentifier("showAllDishes", sender: self.restaurantId)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let barButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = barButtonItem
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
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        adjustContainerViewHeight()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        let offset = scrollView.contentOffset.y
        if offset < 0 {
            self.topViewContainer.changeBackgroundImageBlurEffect(scrollView.contentOffset.y)
        }
//        if offset > -100 {
//            self.topViewContainer.applyBlurEffectToBackgroundImage()
//        } else {
//            self.topViewContainer.clearBlurEffectToBackgroundImage()
//        }
        
        
    }

    
//    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
//        
//    }
    
}
