//
//  HomeViewController.swift
//  Lightning
//
//  Created by Shi Yan on 7/29/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import UIKit
import MapKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class HomeViewController: RefreshableViewController, ARNImageTransitionZoomable, ARNImageTransitionIdentifiable {
    
    @IBOutlet weak var homepageTable: UITableView!
    
    @IBOutlet weak var frontCoverImage: UIImageView!
    
    weak var selectedImageView: UIImageView?
    
    var selectedRestaurantName: String?
    
    var selectedRestaurantId: String?
    
    var selectedRestaurant: Restaurant?
    
    var animateTransition = false
    
    var askLocationAlertView: SCLAlertView?
    
    var homepageSections: [HomepageSection] = []
    
    var appDelegate: AppDelegate?
    
    var loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    var pullRefresher: UIRefreshControl!
    
    var currentLocationText: String?
    
    var autoRefresh = false
    
    var lastUsedLocation : Location?
    
    override func viewDidLoad() {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        NotificationCenter.default.post(name: Notification.Name(rawValue: "HomeVCLoaded"), object: nil)
        super.viewDidLoad()
        self.configLoadingIndicator()
        self.configureFrontCoverImage()
        self.clearTitleForBackBarButtonItem()
        self.configureNavigationController()
        self.configurePullToRefresh()
        addLocationSelectionToLeftCorner()
        addEnvironmentControlToRightCorner()
        initHomepageTable()
        
        homepageTable.delegate = self
        homepageTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
//        setTabBarVisible(true, animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pullRefresher.addTarget(self, action: #selector(RefreshableViewController.refreshData), for: .valueChanged)
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
        let distance : CLLocationDistance = currentCLLocation.distance(from: lastCLLocation)
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
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func configurePullToRefresh(){
        pullRefresher = UIRefreshControl()
        let attribute = [ NSForegroundColorAttributeName: UIColor.lightGray,
                          NSFontAttributeName: UIFont(name: "Arial", size: 14.0)!]
        pullRefresher.attributedTitle = NSAttributedString(string: "正在刷新", attributes: attribute)
        pullRefresher.tintColor = UIColor.lightGray
//        self.homepageTable.addSubview(pullRefresher)
        self.homepageTable.insertSubview(pullRefresher, at: 0)
    }
    
    fileprivate func configureFrontCoverImage(){
        let date = Date()
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.hour, from: date)
        let hour = components.hour
        if hour! >= 5 && hour! < 10 {
            frontCoverImage.image = UIImage(named: "Homepage_Breakfast")
        } else if hour! >= 10 && hour! < 12 {
            frontCoverImage.image = UIImage(named: "Homepage_Brunch")
        } else if hour! >= 12 && hour! < 14 {
            frontCoverImage.image = UIImage(named: "Homepage_Lunch")
        } else if hour! >= 14 && hour! < 17 {
            frontCoverImage.image = UIImage(named: "Homepage_Tea")
        } else if hour! >= 17 && hour! < 21 {
            frontCoverImage.image = UIImage(named: "Homepage_Dinner")
        } else if hour! >= 21 && hour! <= 24 {
            frontCoverImage.image = UIImage(named: "Homepage_Supper")
        } else if hour! >= 0 && hour! < 5 {
            frontCoverImage.image = UIImage(named: "Homepage_Supper")
        }
    }
    
    fileprivate func configLoadingIndicator() {
        loadingIndicator.color = UIColor.themeOrange()
        loadingIndicator.type = NVActivityIndicatorType.pacman
        loadingIndicator.center = (UIApplication.shared.keyWindow?.center)!
        self.view.addSubview(loadingIndicator)
    }
    
    // MARK: - add location selection button to top left corner
    func addLocationSelectionToLeftCorner() {
        let button: UIButton = UIButton.barButtonWithTextAndBorder("位置待定", size: CGRect(x: 0, y: 0, width: 200, height: 26))
        button.addTarget(self, action: #selector(HomeViewController.editLocation), for: UIControlEvents.touchUpInside)
        let selectionLocationButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = selectionLocationButton
    }
    
    func addEnvironmentControlToRightCorner() {
        #if DEBUG
            var title = ""
            let defaults = UserDefaults.standard
            if defaults.bool(forKey: "usingStaging") {
                title = "正在使用Staging"
            } else {
                title = "正在使用Production"
            }
            let button: UIButton = UIButton.barButtonWithTextAndBorder(title, size: CGRect(x: 0, y: 0, width: 150, height: 26))
            button.addTarget(self, action: #selector(HomeViewController.changeEnvironment), for: UIControlEvents.touchUpInside)
            let selectionLocationButton = UIBarButtonItem(customView: button)
            self.navigationItem.rightBarButtonItem = selectionLocationButton
        #endif
    }
        
    func changeEnvironment() {
        let defaults = UserDefaults.standard
        var afterChangeEnv = ""
        if defaults.bool(forKey: "usingStaging") {
            defaults.set(false, forKey: "usingStaging")
            afterChangeEnv = "Production"
            (self.navigationItem.rightBarButtonItem?.customView as! UIButton).setTitle("正在使用Production", for: UIControlState())
        } else {
            defaults.set(true, forKey: "usingStaging")
            afterChangeEnv = "Staging"
            (self.navigationItem.rightBarButtonItem?.customView as! UIButton).setTitle("正在使用Staging", for: UIControlState())
        }
        var appearance = SCLAlertView.SCLAppearance()
        appearance.showCloseButton = false
        appearance.showCircularIcon = true
        appearance.setkWindowHeight(40)
        let askLocationAlertView = SCLAlertView(appearance: appearance)
        let alertViewIcon = UIImage(named: "LogoWithBorder")
        askLocationAlertView.addButton("我知道了", backgroundColor: UIColor.themeOrange(), target:self, selector:#selector(HomeViewController.doNothing))
        askLocationAlertView.showInfo("正在使用\(afterChangeEnv)", subTitle: "\(ParseConfiguration().hostEndpoint())", colorStyle: UIColor.themeOrange().getColorCode(), circleIconImage: alertViewIcon)
        
    }
    
    func doNothing() {
        
    }
    
    func editLocation() {
        let selectLocationNavigationController: UINavigationController = UIStoryboard(name: "LocationSelection", bundle: nil).instantiateViewController(withIdentifier: "LocationNavigationController") as! UINavigationController
        let selectLocationController: SelectLocationViewController = selectLocationNavigationController.viewControllers[0] as! SelectLocationViewController
        selectLocationController.homeViewController = self
        self.present(selectLocationNavigationController, animated: true, completion: nil)
    }
    
    fileprivate func initHomepageTable(){
        homepageTable.separatorStyle = UITableViewCellSeparatorStyle.none
        loadingIndicator.startAnimation()
        let defaults = UserDefaults.standard
        if !defaults.bool(forKey: "usingCustomLocation") {
            NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.handleLocationChange), name:NSNotification.Name(rawValue: "DefaultCityChanged"), object: nil) // Refresh content whenever the user select a city
            NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.handleLocationChange), name:NSNotification.Name(rawValue: "UserLocationAvailable"), object: nil) // Refresh content the first time user real time location is available
        } else {
            // User restarted the app. Already have all the information we need. No need to observe anything
            let cityInUse = userLocationManager.getCityInUse()
            let cityText: String = cityInUse!.name! + ", " + cityInUse!.state! + ", " + cityInUse!.localizedCountryName!
            (self.navigationItem.leftBarButtonItem?.customView as! UIButton).setTitle(cityText, for: UIControlState())
            loadData(nil)
        }
        
    }
    
    @objc fileprivate func refresh(_ sender:AnyObject) {
        loadData(nil)
    }
    
    func handleLocationChange() {
        loadingIndicator.startAnimation()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "UserLocationAvailable"), object: nil) // only need this notification once. Already got it, so remove it.
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "usingCustomLocation") {
            let cityInUse = userLocationManager.getCityInUse()
            let cityText: String = cityInUse!.name! + ", " + cityInUse!.state! + ", " + cityInUse!.localizedCountryName!
            (self.navigationItem.leftBarButtonItem?.customView as! UIButton).setTitle(cityText, for: UIControlState())
        } else {
            currentLocationText = "实时位置"
            (self.navigationItem.leftBarButtonItem?.customView as! UIButton).setTitle(currentLocationText, for: UIControlState())
        }
        loadData(nil)
    }
    
    override func refreshData() {
        loadData(nil)
    }
    
    func prepareForDataRefresh() {
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "usingCustomLocation") {
            NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.handleLocationChange), name:NSNotification.Name(rawValue: "DefaultCityChanged"), object: nil)
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.handleLocationChange), name:NSNotification.Name(rawValue: "UserLocationAvailable"), object: nil)
        }
        autoRefresh = false
    }

    override func loadData(_ refreshHandler : ((_ success : Bool) -> Void)?) {
        let request = GetHomepageRequest()
        
        let location: Location? = userLocationManager.getLocationInUse()
        if (location == nil || location!.lat == nil || location!.lon == nil) {
            loadingIndicator.stopAnimation()
            return
        }
        request.userLocation = location
        DataAccessor(serviceConfiguration: ParseConfiguration()).getHomepage(request) { (response) -> Void in
            OperationQueue.main.addOperation({ () -> Void in
                if response == nil {
                    if refreshHandler != nil {
                        refreshHandler!(false)
                    }
                    self.loadingIndicator.stopAnimation()
                } else {
                    self.clearData()
                    self.homepageSections += response!.results
                    self.homepageSections.sort(by: {(sec1, sec2) -> Bool in
                        return sec1.placement < sec2.placement
                    })
                    self.pullRefresher.endRefreshing()
                    self.loadingIndicator.stopAnimation()
                    self.homepageTable.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                    self.homepageTable.isHidden = false
                    self.homepageTable.reloadData()
                    if refreshHandler != nil {
                        refreshHandler!(true)
                    }
                    
                }
                self.autoRefresh = true
                self.lastUsedLocation = request.userLocation
            });
        }
    }
    
    fileprivate func clearData(){
        homepageSections.removeAll()
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return homepageSections.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HomepageTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "homepageTableCell")
        cell.setUp(title: homepageSections[indexPath.row].title!, restaurants: homepageSections[indexPath.row].restaurants, parentVC: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: - ARNImageTransitionZoomable
    
    func createTransitionImageView() -> UIImageView {
        let imageView = UIImageView(image: self.selectedImageView!.image)
        imageView.contentMode = self.selectedImageView!.contentMode
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = false
        imageView.frame = PositionConverter.getViewAbsoluteFrame(self.selectedImageView!)
        
        return imageView
    }
    
    func presentationCompletionAction(_ completeTransition: Bool) {
        self.selectedImageView?.isHidden = true
    }
    
    func dismissalCompletionAction(_ completeTransition: Bool) {
        self.selectedImageView?.isHidden = false
        animateTransition = false
    }
    
    func handleTransition() {
        self.animateTransition = true
        let storyboard = UIStoryboard(name: "Restaurant", bundle: nil)
        let restaurantController = storyboard.instantiateViewController(withIdentifier: "RestaurantMainTableViewController") as! RestaurantMainTableViewController
        restaurantController.restaurantImage = self.selectedImageView?.image
        restaurantController.restaurantName = self.selectedRestaurantName
        restaurantController.distance = self.selectedRestaurant?.distance
        restaurantController.rating = self.selectedRestaurant?.rating
        restaurantController.address = self.selectedRestaurant?.address
        restaurantController.phone = self.selectedRestaurant?.phone
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

