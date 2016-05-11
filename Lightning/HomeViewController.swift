//
//  HomeViewController.swift
//  Lightning
//
//  Created by Shi Yan on 7/29/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import UIKit
import ARNTransitionAnimator
import SCLAlertView

class HomeViewController: RefreshableViewController, ARNImageTransitionZoomable {
    
    @IBOutlet weak var promotionsTable: UITableView!
    
    @IBOutlet weak var topContainerView: UIView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    weak var selectedImageView : UIImageView?
    
    var selectedRestaurantName : String?
    
    var selectedRestaurantId : String?
    
//    var navigationOperation: UINavigationControllerOperation?
//    
//    var interactivePopTransition: UIPercentDrivenInteractiveTransition!
    
    @IBAction func showHottestRestaurants(sender: AnyObject) {
        self.performSegueWithIdentifier("showRestaurants", sender: "hottest")
    }
    
    @IBAction func showNearstRestaurants(sender: AnyObject) {
        self.performSegueWithIdentifier("showRestaurants", sender: "nearest")
    }
    
    @IBAction func showDishLists(sender: AnyObject) {
        //self.performSegueWithIdentifier("showSelectedCollections", sender: self)
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("selectedCollection") as! SelectedCollectionsTableViewController
        presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBOutlet weak var bannerView: UIView!
    
    var segueType : String?
    
    var animateTransition = false
    
    var askLocationAlertView : SCLAlertView?
    
    
    let PROMOTIONS_LIMIT = 10
    let PROMOTIONS_OFFSET = 0
    let RESTAURANTS_LIMIT = 10
    let RESTAURANTS_OFFSET = 0
    let LISTS_LIMIT = 10
    let LISTS_OFFSET = 0

    let refreshControl = Respinner(spinningView: UIImageView(image: UIImage(named: "Pull_Refresh")))

    var promotions: [Promotion] = []
    
    var ratingAndBookmarkExecutor: RatingAndBookmarkExecutor?
    
    var appDelegate : AppDelegate?
    
    override func viewDidLoad() {
        print(LightningColor.themeRed().getColorCode())
        super.viewDidLoad()
        self.navigationController!.view.backgroundColor = UIColor.whiteColor()
        self.extendedLayoutIncludesOpaqueBars = false
        clearTitleForBackBarButtonItem()
        configureNavigationController()
        loadingIndicator.hidden = true
        self.promotionsTable.separatorStyle = UITableViewCellSeparatorStyle.None
        addLocationSelectionToLeftCorner()
        handleFirstLaunch()
        appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        appDelegate!.startGettingLocation()
        configurePullRefresh()
        initPromotionsTable()
        ratingAndBookmarkExecutor = RatingAndBookmarkExecutor(baseVC: self)
        generateNavigationItemTitle()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - First launch
    func handleFirstLaunch() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if !defaults.boolForKey("hasLaunchedOnce") {
            askForLocationPermit()
            defaults.setBool(true, forKey: "hasLaunchedOnce")
            defaults.synchronize()
        }
    }
    
    func askForLocationPermit() {
        let appearance = SCLAlertView.SCLAppearance(kWindowWidth: self.view.frame.size.width - 120, showCloseButton: false, showCircularIcon: false, kTitleHeight : 0)
        askLocationAlertView = SCLAlertView(appearance: appearance)
        askLocationAlertView!.addButton("同意", backgroundColor: LightningColor.themeRed(), target:self, selector:#selector(HomeViewController.startGettingLocation))
        askLocationAlertView!.addButton("拒绝", backgroundColor: LightningColor.themeRed(), target:self, selector:#selector(HomeViewController.informUserLocationSettings))
        askLocationAlertView!.showInfo("", subTitle: "\n\n您的地理位置信息可以帮助吃饭英雄更精确地搜索附近的餐厅信息\n\n", closeButtonTitle: "", duration: 0.0, colorStyle: LightningColor.themeRed().getColorCode(), colorTextButton: 0xFFFFFF, circleIconImage: nil)
    }
    
    func startGettingLocation() {
        appDelegate!.requestLocationAuthorization()
        self.allowSystemAlerts()
    }
    
    func informUserLocationSettings() {
        let appearance = SCLAlertView.SCLAppearance(kWindowWidth: self.view.frame.size.width - 120, showCloseButton: false, showCircularIcon: false, kTitleHeight : 0)
        askLocationAlertView = SCLAlertView(appearance: appearance)
        askLocationAlertView?.addButton("我知道了", backgroundColor: LightningColor.themeRed(), textColor: nil, showDurationStatus: false, action: {
            self.allowSystemAlerts()
        })
        askLocationAlertView!.showInfo("", subTitle: "\n\n您的默认城市已被设置为 San Jose, CA。您可以随时在主页左上角更改位置设置，或者去系统\"设置\"里打开位置共享。\n\n", closeButtonTitle: "", duration: 0.0, colorStyle: LightningColor.themeRed().getColorCode(), colorTextButton: 0xFFFFFF, circleIconImage: nil)
        
    }
    
    func allowSystemAlerts() {
        registerPushNotifications()
    }
    
    func registerPushNotifications() {
        appDelegate!.registerForPushNotifications()
    }
    
    
    
    // MARK: - Configure navigation bar
    private func generateNavigationItemTitle() {
        let logo = UIImage(named: "Lightning_Title.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }
    
    func configureNavigationController() {
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    private func clearTitleForBackBarButtonItem(){
        let barButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = barButtonItem
    }
    
    
    // MARK: - add location selection button to top left corner
    func addLocationSelectionToLeftCorner() {
        let selectionLocationButton = UIBarButtonItem(title: "位置", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(HomeViewController.editLocation))
        selectionLocationButton.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = selectionLocationButton
    }
    
    func editLocation() {
        self.performSegueWithIdentifier("editLocation", sender: nil)
    }
    
    
    
    private func configurePullRefresh(){
        self.refreshControl.addTarget(self, action: #selector(HomeViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.promotionsTable.addSubview(refreshControl)
    }
    
    private func initPromotionsTable(){
        loadingIndicator.hidden = false
        loadingIndicator.startAnimating()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RefreshableViewController.refreshData), name:"UserLocationAvailable", object: nil)
        
    }
    
    @objc private func refresh(sender:AnyObject) {
        loadData(nil)
    }
    
    override func refreshData() {
        loadData(nil)
    }
    
    override func loadData(refreshHandler : ((success : Bool) -> Void)?) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "UserLocationAvailable", object: nil)
        let getPromotionsRequest = GetPromotionsRequest()
        
        let location = appDelegate!.currentLocation
        if (location.lat == nil || location.lon == nil) {
            loadingIndicator.hidden = true
            loadingIndicator.stopAnimating()
            return
        }
        getPromotionsRequest.userLocation = location
        getPromotionsRequest.limit = PROMOTIONS_LIMIT
        getPromotionsRequest.skip = PROMOTIONS_OFFSET
        print(getPromotionsRequest.getRequestBody())
        DataAccessor(serviceConfiguration: ParseConfiguration()).getPromotions(getPromotionsRequest) { (response) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                if response == nil {
                    if refreshHandler != nil {
                        refreshHandler!(success: false)
                    }
                } else {
                    self.promotions.removeAll()
                    self.loadResults(response!.results)
                    
                    if self.promotions.count > 0 {
                        self.promotionsTable.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
                    }
                    self.promotionsTable.reloadData()
                    self.adjustUI()
                    if refreshHandler != nil {
                        refreshHandler!(success: true)
                    }
                }
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.hidden = true
                self.refreshControl.endRefreshing()
                
                
            });
        }
    }
    
    private func loadResults(results : [Promotion]?) {
        if results != nil {
            for promotion : Promotion in results! {
                if promotion.restaurant == nil && promotion.dish == nil {
                    continue;
                }
                if promotion.restaurant != nil && promotion.dish != nil {
                    continue;
                }
                self.promotions.append(promotion)
            }
        }
    }
    
    private func adjustUI() {
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        segueType = ""
        if segue.identifier == "showRestaurants" {
            self.animateTransition = false
            let restaurantsController : RestaurantsViewController = segue.destinationViewController as! RestaurantsViewController
            if let s = sender as? String {
                restaurantsController.sortBy = s
            }
        } else if segue.identifier == "showRestaurant" {
//            let restaurantController : RestaurantViewController = segue.destinationViewController as! RestaurantViewController
//            restaurantController.restaurantImage = self.selectedImageView?.image
//            restaurantController.restaurantName = self.nameOfSelectedCell
//            restaurantController.restaurantId = sender as? String
//            segueType = "showRestaurant"
        }
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return promotions.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if promotions.isEmpty {
            return 0
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let promotion: Promotion = self.promotions[indexPath.row]
        
        if promotion.restaurant != nil {
            var cell: RestaurantTableViewCell? = tableView.dequeueReusableCellWithIdentifier("restaurantCell") as? RestaurantTableViewCell
            if cell == nil {
                tableView.registerNib(UINib(nibName: "RestaurantCell", bundle: nil), forCellReuseIdentifier: "restaurantCell")
                cell = tableView.dequeueReusableCellWithIdentifier("restaurantCell") as? RestaurantTableViewCell
            }
            cell?.setUp(restaurant: promotions[indexPath.row].restaurant!)
            return cell!
        } else if promotion.dish != nil {
            var cell : DishTableViewCell? = tableView.dequeueReusableCellWithIdentifier("dishCell") as? DishTableViewCell
            if cell == nil {
                tableView.registerNib(UINib(nibName: "DishCell", bundle: nil), forCellReuseIdentifier: "dishCell")
                cell = tableView.dequeueReusableCellWithIdentifier("dishCell") as? DishTableViewCell
            }
            cell?.setUp(dish: promotions[indexPath.row].dish!)
            return cell!
        } else {
            return UITableViewCell()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        self.animateTransition = false
        let selectedCellIndexPath : NSIndexPath? = self.promotionsTable.indexPathForSelectedRow
        if selectedCellIndexPath != nil {
            self.promotionsTable.deselectRowAtIndexPath(selectedCellIndexPath!, animated: false)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let promotion: Promotion = self.promotions[indexPath.row]
        if promotion.restaurant != nil {
            return RestaurantTableViewCell.height
        } else if promotion.dish != nil {
            return DishTableViewCell.height
        }
        return 200
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let promotion : Promotion = self.promotions[indexPath.row]
        let selectedCell : RestaurantTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! RestaurantTableViewCell
        self.selectedImageView = selectedCell.restaurantImageView
        selectedRestaurantName = selectedCell.nameLabel.text
        
        if promotion.restaurant != nil {
            let restaurant : Restaurant = promotions[indexPath.row].restaurant!
//            self.performSegueWithIdentifier("showRestaurant", sender: restaurant.id)
            selectedRestaurantId = restaurant.id
        }
        
        self.promotionsTable.deselectRowAtIndexPath(indexPath, animated: true)
        self.handleTransition()
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) ->
        [UITableViewRowAction]? {
            
        let promotion : Promotion = self.promotions[indexPath.row]
        var favoriteCount : Int = 0
        var likeCount : Int = 0
        var neutralCount : Int = 0
        var dislikeCount : Int = 0
        var objectId = ""
        if promotion.dish != nil {
            objectId = promotion.dish!.id!
            if promotion.dish!.favoriteCount != nil {
                favoriteCount = promotion.dish!.favoriteCount!
            }
            if promotion.dish!.likeCount != nil {
                likeCount = promotion.dish!.likeCount!
            }
            if promotion.dish!.neutralCount != nil {
                neutralCount = promotion.dish!.neutralCount!
            }
            if promotion.dish!.dislikeCount != nil {
                dislikeCount = promotion.dish!.dislikeCount!
            }
            
        } else if promotion.restaurant != nil {
            objectId = promotion.restaurant!.id!
            if promotion.restaurant!.favoriteCount != nil {
                favoriteCount = promotion.restaurant!.favoriteCount!
            }
            if promotion.restaurant!.likeCount != nil {
                likeCount = promotion.restaurant!.likeCount!
            }
            if promotion.restaurant!.neutralCount != nil {
                neutralCount = promotion.restaurant!.neutralCount!
            }
            if promotion.restaurant!.dislikeCount != nil {
                dislikeCount = promotion.restaurant!.dislikeCount!
            }
        }
            
        let addBookmarkAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: CellActionTitle.bookMark(favoriteCount), handler:{(action, indexpath) -> Void in
            if (!UserContext.isValidUser()) {
                self.popupSigninAlert()
            } else {
                favoriteCount += 1
                if promotion.dish != nil {
                    if promotion.dish?.favoriteCount == nil {
                        promotion.dish?.favoriteCount = 1
                    } else {
                        promotion.dish?.favoriteCount! += 1
                    }
                } else {
                    if promotion.restaurant?.favoriteCount == nil {
                        promotion.restaurant?.favoriteCount = 1
                    } else {
                        promotion.restaurant?.favoriteCount! += 1
                    }
                }
                self.promotionsTable.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView(CellActionTitle.bookMark(favoriteCount), index: 0)
                self.addToFavorites(indexPath)
            }
            self.dismissActionViewWithDelay()
            
        });
        addBookmarkAction.backgroundColor = LightningColor.bookMarkYellow()
        
            let likeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: CellActionTitle.positive(likeCount), handler:{(action, indexpath) -> Void in
            if (UserContext.isRatingTooFrequent(objectId)) {
                JSSAlertView().warning(self, title: "评价太频繁")
            } else {
                likeCount += 1
                if promotion.dish != nil {
                    if promotion.dish?.likeCount == nil {
                        promotion.dish?.likeCount = 1
                    } else {
                        promotion.dish?.likeCount! += 1
                    }
                } else {
                    if promotion.restaurant?.likeCount == nil {
                        promotion.restaurant?.likeCount = 1
                    } else {
                        promotion.restaurant?.likeCount! += 1
                    }
                }
                
                self.promotionsTable.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView(CellActionTitle.positive(likeCount), index: 3)
                
                self.ratePromotion(indexPath, ratingType: RatingTypeEnum.like)
            }
            self.dismissActionViewWithDelay()
        });
        likeAction.backgroundColor = LightningColor.likeBackground()
        
        let neutralAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: CellActionTitle.neutral(neutralCount), handler:{(action, indexpath) -> Void in
            if (UserContext.isRatingTooFrequent(objectId)) {
                JSSAlertView().warning(self, title: "评价太频繁")
            } else {
                neutralCount += 1
                if promotion.dish != nil {
                    if promotion.dish?.neutralCount == nil {
                        promotion.dish?.neutralCount = 1
                    } else {
                        promotion.dish?.neutralCount! += 1
                    }
                } else {
                    if promotion.restaurant?.neutralCount == nil {
                        promotion.restaurant?.neutralCount = 1
                    } else {
                        promotion.restaurant?.neutralCount! += 1
                    }
                }
                self.promotionsTable.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView(CellActionTitle.neutral(neutralCount), index: 2)
                self.ratePromotion(indexPath, ratingType: RatingTypeEnum.neutral)
            }
            self.dismissActionViewWithDelay()
        });
        neutralAction.backgroundColor = LightningColor.neutralOrange()
        
        let dislikeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: CellActionTitle.negative(dislikeCount), handler:{(action, indexpath) -> Void in
            if (UserContext.isRatingTooFrequent(objectId)) {
                JSSAlertView().warning(self, title: "评价太频繁")
            } else {
                dislikeCount += 1
                if promotion.dish != nil {
                    if promotion.dish?.dislikeCount == nil {
                        promotion.dish?.dislikeCount = 1
                    } else {
                        promotion.dish?.dislikeCount! += 1
                    }
                } else {
                    if promotion.restaurant?.dislikeCount == nil {
                        promotion.restaurant?.dislikeCount = 1
                    } else {
                        promotion.restaurant?.dislikeCount! += 1
                    }
                }
                self.promotionsTable.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView(CellActionTitle.negative(dislikeCount), index: 1)
                self.ratePromotion(indexPath, ratingType: RatingTypeEnum.dislike)
            }
            self.dismissActionViewWithDelay()
        });
        dislikeAction.backgroundColor = LightningColor.negativeBlue()
        
        
        return [addBookmarkAction, dislikeAction, neutralAction, likeAction];
    }
    
    private func dismissActionViewWithDelay() {
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(HomeViewController.dismissActionView), userInfo: nil, repeats: false)
    }
    
    @objc private func dismissActionView() {
        self.promotionsTable.setEditing(false, animated: true)
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(HomeViewController.reloadTable), userInfo: nil, repeats: false)
    }
    
    @objc private func reloadTable() {
        self.promotionsTable.reloadData()
    }
    
    private func addToFavorites(indexPath: NSIndexPath){
        
        let promotion : Promotion = self.promotions[indexPath.row]
        if promotion.dish != nil {
            ratingAndBookmarkExecutor?.addToFavorites("dish", objectId: (promotion.dish?.id)!, failureHandler: { (objectId) -> Void in
                for promotion : Promotion in self.promotions {
                    if promotion.dish?.id == objectId {
                        if promotion.dish?.favoriteCount != nil {
                            promotion.dish?.favoriteCount! -= 1
                        }
                    }
                }
            })
        } else if promotion.restaurant != nil {
            ratingAndBookmarkExecutor?.addToFavorites("restaurant", objectId: (promotion.restaurant?.id)!, failureHandler: { (objectId) -> Void in
                for promotion : Promotion in self.promotions {
                    if promotion.restaurant?.id == objectId {
                        if promotion.restaurant?.favoriteCount != nil {
                            promotion.restaurant?.favoriteCount! -= 1
                        }
                    }
                }
            })
        }
        
    }
    
    private func ratePromotion(indexPath: NSIndexPath, ratingType: RatingTypeEnum){
        var type: String?
        var objectId: String?
        
        let promotion : Promotion = self.promotions[indexPath.row]
        if promotion.dish != nil {
            type = "dish"
            objectId = promotion.dish?.id
        } else if promotion.restaurant != nil {
            type = "restaurant"
            objectId = promotion.restaurant?.id
        }
        
        if ratingType == RatingTypeEnum.like {
            ratingAndBookmarkExecutor?.like(type!, objectId: objectId!, failureHandler: { (objectId) -> Void in
                for promotion : Promotion in self.promotions {
                    if promotion.dish?.id == objectId {
                        if promotion.dish?.likeCount != nil {
                            promotion.dish?.likeCount! -= 1
                        }
                    } else if promotion.restaurant?.id == objectId {
                        if promotion.restaurant?.likeCount != nil {
                            promotion.restaurant?.likeCount! -= 1
                        }
                    }
                }
            })
        } else if ratingType == RatingTypeEnum.dislike {
            ratingAndBookmarkExecutor?.dislike(type!, objectId: objectId!,failureHandler: { (objectId) -> Void in
                for promotion : Promotion in self.promotions {
                    if promotion.dish?.id == objectId {
                        if promotion.dish?.dislikeCount != nil {
                            promotion.dish?.dislikeCount! -= 1
                        }
                    } else if promotion.restaurant?.id == objectId {
                        if promotion.restaurant?.dislikeCount != nil {
                            promotion.restaurant?.dislikeCount! -= 1
                        }
                    }
                }
            })
        } else {
            ratingAndBookmarkExecutor?.neutral(type!, objectId: objectId!,failureHandler: { (objectId) -> Void in
                for promotion : Promotion in self.promotions {
                    if promotion.dish?.id == objectId {
                        if promotion.dish?.neutralCount != nil {
                            promotion.dish?.neutralCount! -= 1
                        }
                    } else if promotion.restaurant?.id == objectId {
                        if promotion.restaurant?.neutralCount != nil {
                            promotion.restaurant?.neutralCount! -= 1
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

    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        adjustUI()
    }
    
    // MARK: - ARNImageTransitionZoomable
    
    func createTransitionImageView() -> UIImageView {
        let imageView = UIImageView(image: self.selectedImageView!.image)
        imageView.contentMode = self.selectedImageView!.contentMode
        imageView.clipsToBounds = true
        imageView.userInteractionEnabled = false
//        imageView.frame = self.selectedImageView!.convertRect(self.selectedImageView!.frame, toView: self.view)
        imageView.frame = PositionConverter.getViewAbsoluteFrame(self.selectedImageView!)
        
        return imageView
    }
    
    func presentationCompletionAction(completeTransition: Bool) {
        self.selectedImageView?.hidden = true
    }
    
    func dismissalCompletionAction(completeTransition: Bool) {
        self.selectedImageView?.hidden = false
        animateTransition = false
    }
    
    func handleTransition() {
        self.animateTransition = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let restaurantController = storyboard.instantiateViewControllerWithIdentifier("RestaurantViewController") as! RestaurantViewController
        restaurantController.restaurantImage = self.selectedImageView?.image
        restaurantController.restaurantName = self.selectedRestaurantName
        restaurantController.restaurantId = self.selectedRestaurantId
        self.navigationController?.pushViewController(restaurantController, animated: true)
    }
    
    func usingAnimatedTransition() -> Bool {
        return animateTransition
    }
}

