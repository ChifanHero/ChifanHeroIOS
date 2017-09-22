//
//  HomeViewController.swift
//  ChifanHero
//
//  Created by Shi Yan on 7/29/15.
//  Copyright © 2015 ChifanHero. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: AutoNetworkCheckViewController, ARNImageTransitionZoomable, ARNImageTransitionIdentifiable {
    
    @IBOutlet weak var homepageTable: UITableView!
    
    @IBOutlet weak var frontCoverImage: UIImageView!
    
    weak var selectedImageView: UIImageView!
    
    var selectedRestaurantName: String?
    
    var selectedRestaurantId: String?
    
    var selectedRestaurant: Restaurant?
    
    var animateTransition = false
    
    var homepageSections: [HomepageSection] = []
    
    var currentLocationText: String?
    
    var autoRefresh = false
    
    var lastUsedLocation: Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.post(name: Notification.Name(rawValue: HOME_VC_LOADED), object: nil)
        super.viewDidLoad()
        self.configureFrontCoverImage()
        self.clearTitleForBackBarButtonItem()
        self.configureNavigationController()
        self.configurePullToRefresh()
        self.addLocationSelectionToLeftCorner()
        self.addEnvironmentControlToRightCorner()
        self.initHomepageTable()
        
        homepageTable.delegate = self
        homepageTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarTranslucent(To: false)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TrackingUtil.trackRecommendationView()
        if autoRefresh && locationChangedSignificantly() {
            loadingIndicator.startAnimation()
            refreshData()
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
    
    private func configurePullToRefresh(){
        self.homepageTable.insertSubview(pullRefresher, at: 0)
        self.pullRefresher.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
    }
    
    private func configureFrontCoverImage(){
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
    
    // MARK: - add location selection button to top left corner
    private func addLocationSelectionToLeftCorner() {
        let button: UIButton = ButtonUtil.barButtonWithTextAndBorder("位置待定", size: CGRect(x: 0, y: 0, width: 200, height: 26))
        button.addTarget(self, action: #selector(self.editLocation), for: UIControlEvents.touchUpInside)
        let selectionLocationButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = selectionLocationButton
    }
    
    private func addEnvironmentControlToRightCorner() {
        #if DEBUG
            var title = ""
            let defaults = UserDefaults.standard
            if defaults.bool(forKey: "usingStaging") {
                title = "正在使用Staging"
            } else {
                title = "正在使用Production"
            }
            let button: UIButton = ButtonUtil.barButtonWithTextAndBorder(title, size: CGRect(x: 0, y: 0, width: 150, height: 26))
            button.addTarget(self, action: #selector(self.changeEnvironment), for: UIControlEvents.touchUpInside)
            let selectionLocationButton = UIBarButtonItem(customView: button)
            self.navigationItem.rightBarButtonItem = selectionLocationButton
        #endif
    }
        
    func changeEnvironment() {
        let defaults = UserDefaults.standard
        var afterChangeEnv: String
        if defaults.bool(forKey: "usingStaging") {
            defaults.set(false, forKey: "usingStaging")
            afterChangeEnv = "Production"
            (self.navigationItem.rightBarButtonItem?.customView as! UIButton).setTitle("正在使用Production", for: UIControlState())
        } else {
            defaults.set(true, forKey: "usingStaging")
            afterChangeEnv = "Staging"
            (self.navigationItem.rightBarButtonItem?.customView as! UIButton).setTitle("正在使用Staging", for: UIControlState())
        }
        AlertUtil.showAlertView(buttonText: "我知道了", infoTitle: "正在使用\(afterChangeEnv)", infoSubTitle: "\(ParseConfiguration().hostEndpoint())", target: self, buttonAction: #selector(doNothing))
    }

    func doNothing() {}
    
    func editLocation() {
        let selectLocationNavigationController: UINavigationController = UIStoryboard(name: "LocationSelection", bundle: nil).instantiateViewController(withIdentifier: "LocationNavigationController") as! UINavigationController
        let selectLocationController: SelectLocationViewController = selectLocationNavigationController.viewControllers[0] as! SelectLocationViewController
        selectLocationController.homeViewController = self
        self.present(selectLocationNavigationController, animated: true, completion: nil)
    }
    
    private func initHomepageTable(){
        homepageTable.separatorStyle = UITableViewCellSeparatorStyle.none
        loadingIndicator.startAnimation()
        let defaults = UserDefaults.standard
        if !defaults.bool(forKey: USING_NOT_AUTO_DETECTED_LOCATION) {
            NotificationCenter.default.addObserver(self, selector: #selector(self.handleLocationChange), name:NSNotification.Name(rawValue: DEFAULT_CITY_CHANGED), object: nil) // Refresh content whenever the user select a city
            NotificationCenter.default.addObserver(self, selector: #selector(self.handleLocationChange), name:NSNotification.Name(rawValue: USER_LOCATION_AVAILABLE), object: nil) // Refresh content when real-time location first time available
        } else {
            // User restarted the app. Already have all the information we need. No need to observe anything
            let cityInUse = userLocationManager.getCityInUse()
            let cityText: String = cityInUse!.name! + ", " + cityInUse!.state! + ", " + cityInUse!.localizedCountryName!
            (self.navigationItem.leftBarButtonItem?.customView as! UIButton).setTitle(cityText, for: UIControlState())
            refreshData()
        }
        
    }
    
    func handleLocationChange() {
        loadingIndicator.startAnimation()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: USER_LOCATION_AVAILABLE), object: nil) // only need this notification once
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: USING_NOT_AUTO_DETECTED_LOCATION) {
            let cityInUse = userLocationManager.getCityInUse()
            let cityText: String = cityInUse!.name! + ", " + cityInUse!.state! + ", " + cityInUse!.localizedCountryName!
            (self.navigationItem.leftBarButtonItem?.customView as! UIButton).setTitle(cityText, for: UIControlState())
        } else {
            currentLocationText = "实时位置"
            (self.navigationItem.leftBarButtonItem?.customView as! UIButton).setTitle(currentLocationText, for: UIControlState())
        }
        refreshData()
    }
    
    func prepareForDataRefresh() {
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: USING_NOT_AUTO_DETECTED_LOCATION) {
            NotificationCenter.default.addObserver(self, selector: #selector(self.handleLocationChange), name:NSNotification.Name(rawValue: DEFAULT_CITY_CHANGED), object: nil)
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(self.handleLocationChange), name:NSNotification.Name(rawValue: USER_LOCATION_AVAILABLE), object: nil)
        }
        autoRefresh = false
    }

    override func loadData() {
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
                    self.loadingIndicator.stopAnimation()
                } else {
                    self.clearData()
                    self.homepageSections += response!.results
                    self.homepageSections.sort(by: {(sec1, sec2) -> Bool in
                        return sec1.placement! < sec2.placement!
                    })
                    self.pullRefresher.endRefreshing()
                    self.loadingIndicator.stopAnimation()
                    self.homepageTable.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                    self.homepageTable.isHidden = false
                    self.homepageTable.reloadData()
                }
                self.autoRefresh = true
                self.lastUsedLocation = request.userLocation
            });
        }
    }
    
    private func clearData(){
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
        let imageView = UIImageView(image: self.selectedImageView.image)
        imageView.contentMode = self.selectedImageView.contentMode
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = false
        imageView.frame = PositionConverter.getViewAbsoluteFrame(self.selectedImageView)
        
        return imageView
    }
    
    func presentationCompletionAction(_ completeTransition: Bool) {
        self.selectedImageView.isHidden = true
    }
    
    func dismissalCompletionAction(_ completeTransition: Bool) {
        self.selectedImageView.isHidden = false
        animateTransition = false
    }
    
    func handleTransition() {
        self.animateTransition = true
        let storyboard = UIStoryboard(name: "Restaurant", bundle: nil)
        let restaurantController = storyboard.instantiateViewController(withIdentifier: "RestaurantMainTableViewController") as! RestaurantMainTableViewController
        restaurantController.restaurantImage = self.selectedImageView.image
        restaurantController.distance = self.selectedRestaurant?.distance
        restaurantController.restaurantId = self.selectedRestaurantId
        restaurantController.currentLocation = self.lastUsedLocation
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

