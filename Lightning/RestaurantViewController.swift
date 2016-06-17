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
import ARNTransitionAnimator
import Flurry_iOS_SDK

class RestaurantViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HeaderViewDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ARNImageTransitionZoomable, ARNImageTransitionIdentifiable {
    
    var restaurantId : String? {
        didSet {
            request = GetRestaurantByIdRequest(id: restaurantId!)
        }
    }
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    var restaurantImage : UIImage?
    
    var restaurantName : String?
    
    var request : GetRestaurantByIdRequest?
    
    var restaurant : Restaurant?
    
    var animateTransition = true
    
    var parentVCName : String = ""

    @IBOutlet weak var messageView: NotAvailableMessageView!
    
    @IBOutlet weak var waitingView: UIView!
    @IBOutlet weak var containerScrollView: UIScrollView!
    
    let vcTitleLabel : UILabel = UILabel()
    
    @IBOutlet weak var infoTableView: UITableView!
    var info: [String : String] = [String : String]()
    
    var hotDishes : [Dish] = [Dish]()
    
    @IBOutlet weak var waitingIndicator: UIActivityIndicatorView!
    
    
    private let infoToResource : [String : String] = ["address" : "gps", "hours" : "clock", "phone" : "phone"]
    
    var localSearchResponse:MKLocalSearchResponse!

    @IBOutlet weak var hotDishesContainerView: UIView!
    @IBOutlet weak var topViewContainer: ViewItemTopUIView!
    
    @IBOutlet weak var hotDishesTableView: UITableView!
    var ratingAndFavoriteExecutor: RatingAndBookmarkExecutor?
    
    static let INFO_ROW_HEIGHT : CGFloat = 35
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        configVCTitle()
        hotDishesTableView.allowsSelection = false
        self.waitingView.hidden = false
        self.waitingIndicator.startAnimating()
        self.containerScrollView.delegate = self
        self.containerScrollView.showsVerticalScrollIndicator = false
        loadData { (success) -> Void in
            if !success {
//                self.noNetworkDefaultView.show()
            }
        }
        topViewContainer.baseVC = self
        self.backgroundImageView.image = restaurantImage
        topViewContainer.name = restaurantName
        self.waitingView.hidden = true
        ratingAndFavoriteExecutor = RatingAndBookmarkExecutor(baseVC: self)
        #if DEBUG
            let editBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(RestaurantViewController.addPhoto))
            editBarButton.tintColor = UIColor.whiteColor()
            self.navigationItem.rightBarButtonItem = editBarButton
        #else
        #endif
        
        // Do any additional setup after loading the view.
    }
    
//    override func refreshData() {
//        
//    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.translucent = false
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.animateTransition = true
        configVCTitle()
        TrackingUtil.trackRestaurantView()
    }
    
    func configVCTitle() {
        if self.navigationItem.titleView?.alpha == nil {
            vcTitleLabel.text = restaurantName
            vcTitleLabel.backgroundColor = UIColor.clearColor()
            vcTitleLabel.textColor = UIColor.whiteColor()
            vcTitleLabel.sizeToFit()
            vcTitleLabel.alpha = 1.0
            self.navigationItem.titleView = vcTitleLabel
            self.navigationItem.titleView?.alpha = 0.0
        }
        
    }
    
    func loadData(refreshHandler: ((success: Bool) -> Void)?) {
        if (request != nil) {
            DataAccessor(serviceConfiguration: ParseConfiguration()).getRestaurantById(request!) { (response) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    if response == nil {
                        if refreshHandler != nil {
                            refreshHandler!(success: false)
                        }
                    } else {
                        if response?.result != nil {
                            self.restaurant = (response?.result)!
                            if self.restaurant != nil {
                                self.topViewContainer.restaurantId = self.restaurant?.id
                                if self.topViewContainer.name != nil {
                                    self.topViewContainer.name = self.restaurant?.name
                                }
                                self.topViewContainer.englishName = self.restaurant?.englishName
                                if self.backgroundImageView.image == nil {
//                                    self.topViewContainer.backgroundImageURL = self.restaurant?.picture?.original
                                    let backgroundImage : UIImage?
                                    if let imageURL = self.restaurant?.picture?.original {
                                        
                                        let url = NSURL(string: imageURL)
                                        let data = NSData(contentsOfURL: url!)
                                        if data != nil {
                                            backgroundImage = UIImage(data: data!)
                                        } else {
                                            backgroundImage = UIImage(named: "restaurant_default_background")
                                        }
                                        
                                    } else {
                                        backgroundImage = UIImage(named: "restaurant_default_background")
                                    }
                                    self.backgroundImageView.image = backgroundImage
                                }
//
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
                                    self.hotDishes.removeAll()
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
//                                if self.restaurant?.picture != nil {
//                                    self.topViewContainer.backgroundImageURL = self.restaurant?.picture?.original
//                                }
                                self.infoTableView.reloadData()
                                self.hotDishesTableView.reloadData()
                                self.adjustUI()
                            }
                            
                        } else {
                            self.topViewContainer.hidden = true
                            self.infoTableView.hidden = true
                            self.hotDishesTableView.hidden = true
                        }
                        self.waitingIndicator.stopAnimating()
                        self.waitingView.hidden = true
                        if refreshHandler != nil {
                            refreshHandler!(success: true)
                        }
                        
                        
                    }
                    
                });
            }
        }
    }
    
    private func adjustUI() {
        adjustInfoTableViewHeight()
        adjustDishTableViewHeight()
        adjustContainerViewHeight()
    }
    
    func refresh() {
        
    }
    
    private func adjustInfoTableViewHeight() {
        let height : CGFloat = CGFloat(self.info.count) * RestaurantViewController.INFO_ROW_HEIGHT
        let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: self.infoTableView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute:NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: height);
        heightConstraint.priority = 1000
        self.infoTableView.addConstraint(heightConstraint);
        self.view.layoutIfNeeded()
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
//        var contentRect : CGRect = CGRectZero
//        for subView : UIView in self.containerScrollView.subviews {
//            if subView.hidden == false {
//                contentRect = CGRectUnion(contentRect, subView.frame)
//            }
//        }
//        self.containerScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 200 + self.infoTableView.frame.size.height + self.hotDishesTableView.frame.size.height + 44)
//        self.view.layoutIfNeeded()
        var contentRect : CGRect = CGRectZero
        for subView : UIView in self.containerScrollView.subviews {
            if subView.hidden == false {
                contentRect = CGRectUnion(contentRect, subView.frame)
            }
        }
        self.containerScrollView.contentSize = CGSizeMake(self.view.frame.size.width, contentRect.height)
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
            var cell : NameOnlyDishTableViewCell? = tableView.dequeueReusableCellWithIdentifier("nameOnlyDishCell") as? NameOnlyDishTableViewCell
            if cell == nil {
                tableView.registerNib(UINib(nibName: "NameOnlyDishCell", bundle: nil), forCellReuseIdentifier: "nameOnlyDishCell")
                cell = tableView.dequeueReusableCellWithIdentifier("nameOnlyDishCell") as? NameOnlyDishTableViewCell
            }
            let hotDish : Dish = (hotDishes[indexPath.row])
            cell?.setUp(dish: hotDish)
            return cell!
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == infoTableView {
            let currentCell = tableView.cellForRowAtIndexPath(indexPath) as! InfoTableViewCell
            if(currentCell.info == info["address"]){
                TrackingUtil.trackNavigationUsed()
                var localSearchRequest:MKLocalSearchRequest!
                var localSearch:MKLocalSearch!
                
                localSearchRequest = MKLocalSearchRequest()
                localSearchRequest.naturalLanguageQuery = info["address"]
                localSearch = MKLocalSearch(request: localSearchRequest)
                localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
                    
                    self.localSearchResponse = localSearchResponse
                    let alert = UIAlertController(title: "打开地图", message: "是否打开地图导航", preferredStyle: UIAlertControllerStyle.ActionSheet)
                    
                    let goWithAppleAction = UIAlertAction(title: "内置地图", style: .Default, handler: self.doUsingAppleMap)
                    let goWithGoogleAction = UIAlertAction(title: "谷歌地图", style: .Default, handler: self.doUsingGoogleMap)
                    let copyAction = UIAlertAction(title: "复制", style: .Default, handler: self.copyToClipBoard)
                    let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: self.cancelNavigation)
                    
                    alert.addAction(goWithAppleAction)
                    alert.addAction(goWithGoogleAction)
                    alert.addAction(copyAction)
                    alert.addAction(cancelAction)
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
            
            if currentCell.info == info["phone"] {
                TrackingUtil.trackPhoneCallUsed()
                let alert = UIAlertController(title: "呼叫", message: "呼叫\(currentCell.info!)", preferredStyle: UIAlertControllerStyle.ActionSheet)
                
                let goAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Destructive, handler: { (action) -> Void in
                    let phoneNumber = self.extractPhoneNumber(currentCell.info)
                    if let url = NSURL(string: "tel://\(phoneNumber)") {
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
        TrackingUtil.trackAppleMapUsed()
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
    
    func doUsingGoogleMap(alertAction: UIAlertAction!) -> Void {
        TrackingUtil.trackGoogleMapUsed()
        let address: String = info["address"]!.stringByReplacingOccurrencesOfString(" ", withString: "+")
        let requestString: String = "comgooglemaps://?q=" + address
        print(requestString)
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
            UIApplication.sharedApplication().openURL(NSURL(string:
                requestString)!)
        } else {
            print("Can't use comgooglemaps://");
        }
    }
    
    func copyToClipBoard(alertAction: UIAlertAction!) -> Void {
        UIPasteboard.generalPasteboard().string = self.info["address"]
    }
    
    func cancelNavigation(alertAction: UIAlertAction!) {
        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == infoTableView {
            if indexPath.row <= (info.count - 1) {
                return RestaurantViewController.INFO_ROW_HEIGHT
            } else {
                return 62
            }
        } else if tableView == hotDishesTableView {
            return 49
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
    
//    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
//        
//        let dish : Dish = self.hotDishes[indexPath.row]
//        var favoriteCount : Int = 0
//        var likeCount : Int = 0
//        var neutralCount : Int = 0
//        var dislikeCount : Int = 0
//        let objectId = dish.id!
//        
//        if dish.favoriteCount != nil {
//            favoriteCount = dish.favoriteCount!
//        }
//        if dish.likeCount != nil {
//            likeCount = dish.likeCount!
//        }
//        if dish.neutralCount != nil {
//            neutralCount = dish.neutralCount!
//        }
//        if dish.dislikeCount != nil {
//            dislikeCount = dish.dislikeCount!
//        }
//        
//        if tableView == hotDishesTableView{
//            let bookmarkAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: CellActionTitle.bookMark(favoriteCount), handler:{(action, indexpath) -> Void in
//                if (!UserContext.isValidUser()) {
//                    self.popupSigninAlert()
//                } else {
//                    favoriteCount += 1
//                    if dish.favoriteCount == nil {
//                        dish.favoriteCount = 1
//                    } else {
//                        dish.favoriteCount! += 1
//                    }
//                    self.hotDishesTableView.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView(CellActionTitle.bookMark(favoriteCount), index: 0)
//                    self.addToFavorites(indexPath)
//                }
//                self.dismissActionViewWithDelay()
//            });
//            bookmarkAction.backgroundColor = LightningColor.bookMarkYellow()
//            
//            let likeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: CellActionTitle.positive(likeCount), handler:{(action, indexpath) -> Void in
//                if (UserContext.isRatingTooFrequent(objectId)) {
//                    JSSAlertView().warning(self, title: "评价太频繁")
//                } else {
//                    likeCount += 1
//                    if dish.likeCount == nil {
//                        dish.likeCount = 1
//                    } else {
//                        dish.likeCount! += 1
//                    }
//                    self.hotDishesTableView.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView(CellActionTitle.positive(likeCount), index: 3)
//                    self.rateDish(indexPath, ratingType: RatingTypeEnum.like)
//                }
//                self.dismissActionViewWithDelay()
//            });
//            likeAction.backgroundColor = LightningColor.likeBackground()
//            
//            let neutralAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: CellActionTitle.neutral(neutralCount), handler:{(action, indexpath) -> Void in
//                if (UserContext.isRatingTooFrequent(objectId)) {
//                    JSSAlertView().warning(self, title: "评价太频繁")
//                } else {
//                    neutralCount += 1
//                    if dish.neutralCount == nil {
//                        dish.neutralCount = 1
//                    } else {
//                        dish.neutralCount! += 1
//                    }
//                    action.title = "一般\n\(neutralCount)"
//                    self.hotDishesTableView.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView(CellActionTitle.neutral(neutralCount), index: 2)
//                    self.rateDish(indexPath, ratingType: RatingTypeEnum.neutral)
//                }
//                self.dismissActionViewWithDelay()
//            });
//            neutralAction.backgroundColor = LightningColor.neutralOrange()
//            
//            let dislikeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: CellActionTitle.negative(dislikeCount), handler:{(action, indexpath) -> Void in
//                if (UserContext.isRatingTooFrequent(objectId)) {
//                    JSSAlertView().warning(self, title: "评价太频繁")
//                } else {
//                    dislikeCount += 1
//                    if dish.dislikeCount == nil {
//                        dish.dislikeCount = 1
//                    } else {
//                        dish.dislikeCount! += 1
//                    }
//                    self.hotDishesTableView.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView(CellActionTitle.negative(dislikeCount), index: 1)
//                    self.rateDish(indexPath, ratingType: RatingTypeEnum.dislike)
//                }
//                self.dismissActionViewWithDelay()
//            });
//            dislikeAction.backgroundColor = LightningColor.negativeBlue()
//            
//            return [bookmarkAction, dislikeAction, neutralAction, likeAction];
//        }
//        return [];
//    }
    
    private func addToFavorites(indexPath: NSIndexPath){
        let dish = self.hotDishes[indexPath.row]
        ratingAndFavoriteExecutor?.addToFavorites("dish", objectId: dish.id!, failureHandler: { (objectId) -> Void in
            for dish : Dish in self.hotDishes {
                if dish.id == objectId {
                    if dish.favoriteCount != nil {
                        dish.favoriteCount! -= 1
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
                            dish.likeCount! -= 1
                        }
                    }
                }
            })
        } else if ratingType == RatingTypeEnum.dislike {
            ratingAndFavoriteExecutor?.dislike(type, objectId: objectId!,failureHandler: { (objectId) -> Void in
                for dish : Dish in self.hotDishes {
                    if dish.id == objectId {
                        if dish.dislikeCount != nil {
                            dish.dislikeCount! -= 1
                        }
                    }
                }
            })
        } else {
            ratingAndFavoriteExecutor?.neutral(type, objectId: objectId!,failureHandler: { (objectId) -> Void in
                for dish : Dish in self.hotDishes {
                    if dish.id == objectId {
                        if dish.neutralCount != nil {
                            dish.neutralCount! -= 1
                        }
                    }
                }
            })
        }
    }
    
    private func popupSigninAlert() {
        SCLAlertView().showWarning("请登录", subTitle: "登录享受更多便利")
    }
    
    private func dismissActionViewWithDelay() {
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(RestaurantViewController.dismissActionView), userInfo: nil, repeats: false)
    }
    
    @objc private func dismissActionView() {
        self.hotDishesTableView.setEditing(false, animated: true)
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(RestaurantViewController.reloadTable), userInfo: nil, repeats: false)
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
            self.animateTransition = false
            let restaurantAllDishesController : RestaurantAllDishViewController = segue.destinationViewController as! RestaurantAllDishViewController
            restaurantAllDishesController.restaurantId = sender as? String
        }
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        adjustContainerViewHeight()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
//        print(scrollView.contentOffset.y)
        let offset = scrollView.contentOffset.y
        let nameLabelBottomY = self.topViewContainer.getNameLabelBottomY() + 200
        if offset > nameLabelBottomY{
//            self.topViewContainer.changeBackgroundImageBlurEffect(scrollView.contentOffset.y)
            let scale = (abs(offset) - abs(nameLabelBottomY)) / 40
            self.navigationItem.titleView?.alpha = scale
        } else {
            self.navigationItem.titleView?.alpha = 0.0
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
    
    func addPhoto() {
        popUpImageSourceOption()
    }
    
    private func popUpImageSourceOption(){
        let alert = UIAlertController(title: "更换头像", message: "选取图片来源", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let takePhotoAction = UIAlertAction(title: "相机", style: .Default, handler: self.takePhotoFromCamera)
        let chooseFromPhotosAction = UIAlertAction(title: "照片", style: .Default, handler: self.chooseFromPhotoRoll)
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: self.cancelChoosingImage)
        
        alert.addAction(takePhotoAction)
        alert.addAction(chooseFromPhotosAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func takePhotoFromCamera(alertAction: UIAlertAction!) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func chooseFromPhotoRoll(alertAction: UIAlertAction!) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func cancelChoosingImage(alertAction: UIAlertAction!) {
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil);
        
        let maxLength = 500000
        var imageData = UIImageJPEGRepresentation(image, 1.0) //1.0 is compression ratio
        if imageData?.length > maxLength {
            let compressionRatio: CGFloat = CGFloat(maxLength) / CGFloat((imageData?.length)!)
            imageData = UIImageJPEGRepresentation(image, compressionRatio)
        }
        
        let base64_code: String = (imageData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength))!
        let request : UploadPictureRequest = UploadPictureRequest(base64_code: base64_code)
        DataAccessor(serviceConfiguration: ParseConfiguration()).uploadPicture(request) { (response) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                
                if response?.result != nil{
//                    AccountManager(serviceConfiguration: ParseConfiguration()).updateInfo(nickName: nil, pictureId: response?.result?.id) { (success, user) -> Void in
//                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                            if success == true {
//                                print("Update profile picture succeed")
//                            } else {
//                                print("Update profile picture failed")
//                            }
//                        })
//                        
//                    }
                    let updateRestaurantRequest : UpdateRestaurantInfoRequest = UpdateRestaurantInfoRequest()
                    updateRestaurantRequest.restaurantId = self.restaurantId
                    updateRestaurantRequest.imageId = response?.result?.id
                    DataAccessor(serviceConfiguration: ParseConfiguration()).updateRestaurantInfo(updateRestaurantRequest, responseHandler: { (updateResponse) -> Void in
                        if updateResponse?.result != nil {
//                            self.topViewContainer.backgroundImageURL = updateResponse?.result?.picture?.original
                            let backgroundImage : UIImage?
                            if let imageURL = updateResponse?.result?.picture?.original {
                                
                                let url = NSURL(string: imageURL)
                                let data = NSData(contentsOfURL: url!)
                                if data != nil {
                                    backgroundImage = UIImage(data: data!)
                                } else {
                                    backgroundImage = UIImage(named: "restaurant_default_background")
                                }
                                
                            } else {
                                backgroundImage = UIImage(named: "restaurant_default_background")
                            }
                            self.backgroundImageView.image = backgroundImage
                        }
                    })
                }
                
            });
        }
    }
    
    func extractPhoneNumber(originalNumber : String?) -> String{
        if originalNumber == nil {
            return ""
        }
        let stringArray = originalNumber!.componentsSeparatedByCharactersInSet(
            NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        let newString = stringArray.joinWithSeparator("")
        return newString
    }
    
    // MARK: - ARNImageTransitionZoomable
    
    func createTransitionImageView() -> UIImageView {
        let imageView = UIImageView(image: self.backgroundImageView.image)
        imageView.contentMode = self.backgroundImageView.contentMode
        imageView.clipsToBounds = true
        imageView.userInteractionEnabled = false
//        imageView.frame = self.topViewContainer.backgroundImageView!.frame
        imageView.frame = backgroundImageView.superview!.convertRect(backgroundImageView.frame, toView: self.view)
//        imageView.frame = CGRectMake(0, 64, self.view.frame.size.width, 200)
//        imageView.frame = backgroundImageView.frame
        print(imageView.frame)
//        imageView.frame = CGRectMake(0, 44, self.view.frame.size.width, 177)
        return imageView
    }
    
    func presentationBeforeAction() {
        backgroundImageView.hidden = true
    }
    
    func presentationCompletionAction(completeTransition: Bool) {
        backgroundImageView.hidden = false
    }
    
    func dismissalBeforeAction() {
        backgroundImageView.hidden = true
    }
    
    func dismissalCompletionAction(completeTransition: Bool) {
        if !completeTransition {
            backgroundImageView.hidden = false
        }
    }
    
    func usingAnimatedTransition() -> Bool {
        return animateTransition
    }
    
    func getId() -> String {
        return "RestaurantViewController"
    }
    
    func getDirectAncestorId() -> String {
        return parentVCName
    }
    
    
    
}
