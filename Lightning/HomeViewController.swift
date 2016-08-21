//
//  HomeViewController.swift
//  Lightning
//
//  Created by Shi Yan on 7/29/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import UIKit
import ARNTransitionAnimator
import MapKit

class HomeViewController: RefreshableViewController, ARNImageTransitionZoomable, ARNImageTransitionIdentifiable {
    
    @IBOutlet weak var homepageTable: UITableView!
    
    @IBOutlet weak var frontCoverImage: UIImageView!
    
    weak var selectedImageView: UIImageView?
    
    var selectedRestaurantName: String?
    
    var selectedRestaurantId: String?
    
    var animateTransition = false
    
    var askLocationAlertView: SCLAlertView?
    
    var homepageSections: [HomepageSection] = []
    
    var appDelegate: AppDelegate?
    
    var loadingIndicator = NVActivityIndicatorView(frame: CGRectMake(0, 0, 40, 40))
    
    var pullRefresher: UIRefreshControl!
    
    var currentLocationText: String?
    
    var autoRefresh = false
    
    var lastUsedLocation : Location?
    
    override func viewDidLoad() {
        appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        NSNotificationCenter.defaultCenter().postNotificationName("HomeVCLoaded", object: nil)
        super.viewDidLoad()
        self.configLoadingIndicator()
        self.configureFrontCoverImage()
        self.clearTitleForBackBarButtonItem()
        self.configureNavigationController()
        self.configurePullToRefresh()
        addLocationSelectionToLeftCorner()
        initHomepageTable()
        
        homepageTable.delegate = self
        homepageTable.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.translucent = false
//        setTabBarVisible(true, animated: true)
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        pullRefresher.addTarget(self, action: #selector(RefreshableViewController.refreshData), forControlEvents: .ValueChanged)
        TrackingUtil.trackRecommendationView()
        if autoRefresh && locationChangedSignificantly() {
            loadingIndicator.startAnimation()
            loadData(nil)
        }
    }
    
    func locationChangedSignificantly() -> Bool {
        let currentLocation = userLocationManager.getLocationInUse()
        if lastUsedLocation == nil || currentLocation == nil {
            return false
        }
        let currentCLLocation = CLLocation(latitude: (currentLocation?.lat)!, longitude: (currentLocation?.lon)!)
        let lastCLLocation = CLLocation(latitude: lastUsedLocation!.lat!, longitude: lastUsedLocation!.lon!)
        let distance : CLLocationDistance = currentCLLocation.distanceFromLocation(lastCLLocation)
        print(distance)
        if distance >= 1600 {
            return true
        } else {
            return false
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private func configurePullToRefresh(){
        pullRefresher = UIRefreshControl()
        let attribute = [ NSForegroundColorAttributeName: UIColor.lightGrayColor(),
                          NSFontAttributeName: UIFont(name: "Arial", size: 14.0)!]
        pullRefresher.attributedTitle = NSAttributedString(string: "正在刷新", attributes: attribute)
        pullRefresher.tintColor = UIColor.lightGrayColor()
//        self.homepageTable.addSubview(pullRefresher)
        self.homepageTable.insertSubview(pullRefresher, atIndex: 0)
    }
    
    private func configureFrontCoverImage(){
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Hour, fromDate: date)
        let hour = components.hour
        if hour >= 5 && hour < 10 {
            frontCoverImage.image = UIImage(named: "Homepage_Breakfast")
        } else if hour >= 10 && hour < 12 {
            frontCoverImage.image = UIImage(named: "Homepage_Brunch")
        } else if hour >= 12 && hour < 14 {
            frontCoverImage.image = UIImage(named: "Homepage_Lunch")
        } else if hour >= 14 && hour < 17 {
            frontCoverImage.image = UIImage(named: "Homepage_Tea")
        } else if hour >= 17 && hour < 21 {
            frontCoverImage.image = UIImage(named: "Homepage_Dinner")
        } else if hour >= 21 && hour <= 24 {
            frontCoverImage.image = UIImage(named: "Homepage_Supper")
        } else if hour >= 0 && hour < 5 {
            frontCoverImage.image = UIImage(named: "Homepage_Supper")
        }
    }
    
    private func configLoadingIndicator() {
        loadingIndicator.color = UIColor.themeOrange()
        loadingIndicator.type = NVActivityIndicatorType.Pacman
        loadingIndicator.center = (UIApplication.sharedApplication().keyWindow?.center)!
        self.view.addSubview(loadingIndicator)
    }
    
    // MARK: - add location selection button to top left corner
    func addLocationSelectionToLeftCorner() {
        let button: UIButton = UIButton.barButtonWithTextAndBorder("位置待定", size: CGRectMake(0, 0, 200, 26))
        button.addTarget(self, action: #selector(HomeViewController.editLocation), forControlEvents: UIControlEvents.TouchUpInside)
        let selectionLocationButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = selectionLocationButton
    }
    
    func editLocation() {
        self.performSegueWithIdentifier("editLocation", sender: nil)
    }
    
    private func initHomepageTable(){
        homepageTable.separatorStyle = UITableViewCellSeparatorStyle.None
        loadingIndicator.startAnimation()
        let defaults = NSUserDefaults.standardUserDefaults()
        if !defaults.boolForKey("usingCustomLocation") {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.handleLocationChange), name:"DefaultCityChanged", object: nil) // Refresh content whenever the user select a city
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.handleLocationChange), name:"UserLocationAvailable", object: nil) // Refresh content the first time user real time location is available
        } else {
            // User restarted the app. Already have all the information we need. No need to observe anything
            let cityInUse = userLocationManager.getCityInUse()
            let cityText: String = cityInUse!.name! + ", " + cityInUse!.state! + ", " + cityInUse!.localizedCountryName!
            (self.navigationItem.leftBarButtonItem?.customView as! UIButton).setTitle(cityText, forState: .Normal)
            loadData(nil)
        }
        
    }
    
    @objc private func refresh(sender:AnyObject) {
        loadData(nil)
    }
    
    func handleLocationChange() {
        loadingIndicator.startAnimation()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "UserLocationAvailable", object: nil) // only need this notification once. Already got it, so remove it.
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.boolForKey("usingCustomLocation") {
            let cityInUse = userLocationManager.getCityInUse()
            let cityText: String = cityInUse!.name! + ", " + cityInUse!.state! + ", " + cityInUse!.localizedCountryName!
            (self.navigationItem.leftBarButtonItem?.customView as! UIButton).setTitle(cityText, forState: .Normal)
        } else {
            currentLocationText = "实时位置"
            (self.navigationItem.leftBarButtonItem?.customView as! UIButton).setTitle(currentLocationText, forState: .Normal)
        }
        loadData(nil)
    }
    
    override func refreshData() {
        loadData(nil)
    }
    
    func prepareForDataRefresh() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.boolForKey("usingCustomLocation") {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.handleLocationChange), name:"DefaultCityChanged", object: nil)
        } else {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.handleLocationChange), name:"UserLocationAvailable", object: nil)
        }
        autoRefresh = false
    }

    override func loadData(refreshHandler : ((success : Bool) -> Void)?) {
        let request = GetHomepageRequest()
        
        let location: Location? = userLocationManager.getLocationInUse()
        if (location == nil || location!.lat == nil || location!.lon == nil) {
            loadingIndicator.stopAnimation()
            return
        }
        request.userLocation = location
        DataAccessor(serviceConfiguration: ParseConfiguration()).getHomepage(request) { (response) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                if response == nil {
                    if refreshHandler != nil {
                        refreshHandler!(success: false)
                    }
                    self.loadingIndicator.stopAnimation()
                } else {
                    self.clearData()
                    self.homepageSections += response!.results
                    self.homepageSections.sortInPlace({(sec1, sec2) -> Bool in
                        return sec1.placement < sec2.placement
                    })
                    self.pullRefresher.endRefreshing()
                    self.loadingIndicator.stopAnimation()
                    self.homepageTable.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
                    self.homepageTable.hidden = false
                    self.homepageTable.reloadData()
                    if refreshHandler != nil {
                        refreshHandler!(success: true)
                    }
                    
                }
                self.autoRefresh = true
                self.lastUsedLocation = request.userLocation
            });
        }
    }
    
    private func clearData(){
        homepageSections.removeAll()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editLocation" {
            let selectLocationNavigationController: UINavigationController = segue.destinationViewController
            as! UINavigationController
            let selectLocationController: SelectLocationViewController = selectLocationNavigationController.viewControllers[0] as! SelectLocationViewController
            selectLocationController.homeViewController = self
        }
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return homepageSections.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = HomepageTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "homepageTableCell")
        cell.setUp(title: homepageSections[indexPath.row].title!, restaurants: homepageSections[indexPath.row].restaurants, parentVC: self)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 350
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // MARK: - ARNImageTransitionZoomable
    
    func createTransitionImageView() -> UIImageView {
        let imageView = UIImageView(image: self.selectedImageView!.image)
        imageView.contentMode = self.selectedImageView!.contentMode
        imageView.clipsToBounds = true
        imageView.userInteractionEnabled = false
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
        let restaurantController = storyboard.instantiateViewControllerWithIdentifier("RestaurantMainTableViewController") as! RestaurantMainTableViewController
        restaurantController.restaurantImage = self.selectedImageView?.image
        restaurantController.restaurantName = self.selectedRestaurantName
        restaurantController.restaurantId = self.selectedRestaurantId
        restaurantController.parentVCName = self.getId()
        self.navigationController?.pushViewController(restaurantController, animated: true)
    }
    
    func usingAnimatedTransition() -> Bool {
        return animateTransition
    }
    
    func getId() -> String {
        return "HomeViewController"
    }
    
    func getDirectAncestorId() -> String {
        return ""
    }
}

