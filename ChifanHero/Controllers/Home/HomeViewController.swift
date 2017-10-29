//
//  HomeViewController.swift
//  ChifanHero
//
//  Created by Shi Yan on 7/29/15.
//  Copyright © 2015 ChifanHero. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: AutoNetworkCheckViewController, ARNImageTransitionZoomable, ARNImageTransitionIdentifiable, UITextFieldDelegate {
    
    @IBOutlet weak var homepageTable: UITableView!
    
    @IBOutlet weak var frontCoverImage: UIImageView!
    
    weak var selectedImageView: UIImageView!
    
    lazy var searchBar = UITextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.width / 10 * 7.5 - 10, height: 20))
    
    @IBOutlet weak var envControlButton: UIButton!
    
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
        self.addEnvironmentControl()
        self.addSearchBar()
        self.requestAppVersionInfo()
        self.initHomepageTable()
        
        homepageTable.delegate = self
        homepageTable.dataSource = self
        self.searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarTranslucent(To: false)
        self.tabBarController?.tabBar.isHidden = false
        self.selectedImageView?.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TrackingUtil.trackRecommendationView()
        if autoRefresh && locationChangedSignificantly() {
            loadingIndicator.startAnimation()
            refreshData()
        }
    }
    
    private func addSearchBar() {
        self.searchBar.backgroundColor = UIColor.white
        self.searchBar.placeholder = "搜索餐厅"
        self.searchBar.borderStyle = .roundedRect
        self.searchBar.textAlignment = .center
        self.searchBar.font = UIFont(name: "Arial", size: 14)
        let leftNavBarButton = UIBarButtonItem(customView: self.searchBar)
        self.navigationItem.rightBarButtonItem = leftNavBarButton
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
        let button: UIButton = ButtonUtil.barButtonWithTextAndBorder("NA", size: CGRect(x: 0, y: 0, width: self.view.frame.width / 10 * 1.5, height: 26))
        button.addTarget(self, action: #selector(self.editLocation), for: UIControlEvents.touchUpInside)
        let selectionLocationButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = selectionLocationButton
    }
    
    private func addEnvironmentControl() {
        envControlButton.isHidden = true
        #if DEBUG
            envControlButton.isHidden = false
            var title = ""
            let defaults = UserDefaults.standard
            if defaults.bool(forKey: "usingStaging") {
                title = "正在使用Staging"
            } else {
                title = "正在使用Production"
            }
            envControlButton.setTitle(title, for: .normal)
            envControlButton.addTarget(self, action: #selector(self.changeEnvironment), for: UIControlEvents.touchUpInside)
        #endif
    }
        
    func changeEnvironment() {
        let defaults = UserDefaults.standard
        var afterChangeEnv: String
        if defaults.bool(forKey: "usingStaging") {
            defaults.set(false, forKey: "usingStaging")
            afterChangeEnv = "Production"
            self.envControlButton.setTitle("正在使用Production", for: .normal)
        } else {
            defaults.set(true, forKey: "usingStaging")
            afterChangeEnv = "Staging"
            self.envControlButton.setTitle("正在使用Staging", for: .normal)
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
    
    private func requestAppVersionInfo() {
        let request = GetAppVersionInfoRequest(appVersionNumber: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
        DataAccessor(serviceConfiguration: ParseConfiguration()).getAppVersionInfo(request) { (response) -> Void in
            OperationQueue.main.addOperation({ () -> Void in
                guard response?.error == nil else {
                    return
                }
                guard let isMandatory = response?.isMandatory, let isLatestVersion = response?.isLatestVersion, let latestVersion = response?.latestVersion, let updateInfo = response?.updateInfo else {
                    return
                }
                if isMandatory {
                    AlertUtil.showAlertViewWithoutAutoDismiss(buttonText: "立即更新", infoTitle: "请立即更新", infoSubTitle: "请更新至最新版吃饭英雄", target: self, buttonAction: #selector(self.openAppStore))
                    return
                }
                if !isLatestVersion {
                    AlertUtil.showAlertViewWithTwoButtons(firstButtonText: "我知道了", secondButtonText: "立即更新", infoTitle: "吃饭英雄\(latestVersion)已上线", infoSubTitle: "\(updateInfo)", target: self, firstButtonAction: #selector(self.doNothing), secondButtonAction: #selector(self.openAppStore))
                }
            });
        }
    }
    
    func openAppStore() {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id1095530432"),
            UIApplication.shared.canOpenURL(url)
        {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
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
//            let cityText: String = cityInUse!.name! + ", " + cityInUse!.state! + ", " + cityInUse!.localizedCountryName!
            let cityText: String = getLocationAbbreviation(locationName: cityInUse!.name!)
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
            let cityText: String = getLocationAbbreviation(locationName: cityInUse!.name!)
            (self.navigationItem.leftBarButtonItem?.customView as! UIButton).setTitle(cityText, for: UIControlState())
        } else {
            currentLocationText = "GPS"
            (self.navigationItem.leftBarButtonItem?.customView as! UIButton).setTitle(currentLocationText, for: UIControlState())
        }
        refreshData()
    }
    
    func getLocationAbbreviation(locationName: String)-> String {
        let locationNameComponents = locationName.components(separatedBy: " ")
        if locationNameComponents.count > 1 {
            var abbreviation = ""
            for component in locationNameComponents {
                abbreviation.append(String(component.characters.prefix(1)))
            }
            return abbreviation
        } else {
            if locationName.characters.count > 7 {
                return String(locationName.characters.prefix(4)) + "..."
            } else {
                return locationName
            }
        }
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
    
    // MARK - TextField methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        performSegue(withIdentifier: "search", sender: nil)
        return false
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

