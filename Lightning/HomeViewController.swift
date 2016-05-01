//
//  HomeViewController.swift
//  Lightning
//
//  Created by Shi Yan on 7/29/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import UIKit

class HomeViewController: RefreshableViewController, UINavigationControllerDelegate ,UIViewControllerAnimatedTransitioning {
    
    @IBOutlet weak var promotionsTable: UITableView!
    
    @IBOutlet weak var topContainerView: UIView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var imageViewOfSelectedCell : UIImageView?
    
    var navigationOperation: UINavigationControllerOperation?
    
    var interactivePopTransition: UIPercentDrivenInteractiveTransition!
    
    @IBAction func showHottestRestaurants(sender: AnyObject) {
        self.performSegueWithIdentifier("showRestaurants", sender: "hottest")
    }
    
    @IBAction func showNearstRestaurants(sender: AnyObject) {
        self.performSegueWithIdentifier("showRestaurants", sender: "nearest")
    }
    
    @IBAction func showDishLists(sender: AnyObject) {
        self.performSegueWithIdentifier("showLists", sender: self)
    }
    
    @IBOutlet weak var bannerView: UIView!
    
    
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
        super.viewDidLoad()
        self.navigationController?.delegate = self
        self.navigationController!.view.backgroundColor = UIColor.whiteColor()
        let popRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(HomeViewController.handlePopRecognizer(_:)))
        popRecognizer.edges = UIRectEdge.Left
        self.navigationController!.view.addGestureRecognizer(popRecognizer)
        clearTitleForBackBarButtonItem()
        configureNavigationController()
        loadingIndicator.hidden = true
        self.promotionsTable.separatorStyle = UITableViewCellSeparatorStyle.None
        appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        appDelegate!.startGettingLocation()
        appDelegate!.registerForPushNotifications()
        configurePullRefresh()
        initPromotionsTable()
        ratingAndBookmarkExecutor = RatingAndBookmarkExecutor(baseVC: self)
        generateNavigationItemTitle()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        if segue.identifier == "showRestaurants" {
            let restaurantsController : RestaurantsViewController = segue.destinationViewController as! RestaurantsViewController
            if let s = sender as? String {
                restaurantsController.sortBy = s
            }
        } else if segue.identifier == "showRestaurant" {
            let restaurantController : RestaurantViewController = segue.destinationViewController as! RestaurantViewController
            restaurantController.restaurantImage = self.imageViewOfSelectedCell?.image
            restaurantController.restaurantId = sender as? String
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
        imageViewOfSelectedCell = selectedCell.restaurantImageView
        if promotion.restaurant != nil {
            let restaurant : Restaurant = promotions[indexPath.row].restaurant!
            self.performSegueWithIdentifier("showRestaurant", sender: restaurant.id)
        }
        
        self.promotionsTable.deselectRowAtIndexPath(indexPath, animated: true)
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
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.4
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        var detailVC: RestaurantViewController!
        var fromView: UIView!
        var alpha: CGFloat = 1.0
        var destTransform: CGAffineTransform!
        
        var snapshotImageView: UIView!
        //获取到当前选择的Button
        let originalView = self.imageViewOfSelectedCell
        print(originalView?.frame)
        
        if navigationOperation == UINavigationControllerOperation.Push {
            containerView.insertSubview(toViewController.view, aboveSubview: fromViewController.view)
            snapshotImageView = originalView?.snapshotViewAfterScreenUpdates(false)
            detailVC = toViewController as! RestaurantViewController
            fromView = fromViewController.view
            alpha = 0
            detailVC.view.transform = CGAffineTransformMakeScale(0.1, 0.1)
            destTransform = CGAffineTransformMakeScale(1, 1)
            snapshotImageView.frame = PositionConverter.getViewAbsoluteFrame(originalView!)
        } else if navigationOperation == UINavigationControllerOperation.Pop {
            containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
            detailVC = fromViewController as! RestaurantViewController
            snapshotImageView = detailVC.topViewContainer.backgroundImageView.snapshotViewAfterScreenUpdates(false)
            fromView = toViewController.view
            // 如果IDE是Xcode6 Beta4+iOS8SDK，那么在此处设置为0，动画将会不被执行(不确定是哪里的Bug)
            destTransform = CGAffineTransformMakeScale(0.1, 0.1)
            snapshotImageView.frame = PositionConverter.getViewAbsoluteFrame(detailVC.topViewContainer.backgroundImageView)
        }
        originalView?.hidden = true
        detailVC.topViewContainer.backgroundImageView.hidden = true
        
        containerView.addSubview(snapshotImageView)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            detailVC.view.transform = destTransform
            fromView.alpha = alpha
            if self.navigationOperation == UINavigationControllerOperation.Push {
                snapshotImageView.frame = PositionConverter.getViewAbsoluteFrame(detailVC.topViewContainer.backgroundImageView)
            } else if self.navigationOperation == UINavigationControllerOperation.Pop {
                snapshotImageView.frame = PositionConverter.getViewAbsoluteFrame(originalView!)
            }
            }, completion: ({completed in
                originalView?.hidden = false
                detailVC.topViewContainer.backgroundImageView.hidden = false
                snapshotImageView.removeFromSuperview()
                //告诉系统你的动画过程已经结束，这是非常重要的方法，必须调用。
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            }))
    }
    
    func handlePopRecognizer(popRecognizer: UIScreenEdgePanGestureRecognizer) {
        var progress = popRecognizer.translationInView(navigationController!.view).x / navigationController!.view.bounds.size.width
        progress = min(1.0, max(0.0, progress))
        
        print("\(progress)")
        if popRecognizer.state == UIGestureRecognizerState.Began {
            print("Began")
            self.interactivePopTransition = UIPercentDrivenInteractiveTransition()
            self.navigationController!.popViewControllerAnimated(true)
        } else if popRecognizer.state == UIGestureRecognizerState.Changed {
            self.interactivePopTransition!.updateInteractiveTransition(progress)
            print("Changed")
        } else if popRecognizer.state == UIGestureRecognizerState.Ended || popRecognizer.state == UIGestureRecognizerState.Cancelled {
            if progress > 0.5 {
                self.interactivePopTransition!.finishInteractiveTransition()
            } else {
                self.interactivePopTransition!.cancelInteractiveTransition()
            }
            //            finishBy(progress < 0.5)
            print("Ended || Cancelled")
            self.interactivePopTransition = nil
        }
    }
    
    // UINavigationControllerDelegate
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        navigationOperation = operation
        return self
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if self.interactivePopTransition == nil {
            return nil
        }
        return self.interactivePopTransition
    }
    
    private func popupSigninAlert() {
        let alertview = JSSAlertView().show(self, title: "请登录", text: nil, buttonText: "我知道了")
        alertview.setTextTheme(.Dark)
    }
    
    
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        adjustUI()
    }
}

