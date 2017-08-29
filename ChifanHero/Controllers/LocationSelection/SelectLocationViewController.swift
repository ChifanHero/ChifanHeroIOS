//
//  SelectLocationViewController.swift
//  ChifanHero
//
//  Created by Shi Yan on 5/8/16.
//  Copyright © 2016 ChifanHero. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

class SelectLocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var locationTable: UITableView!
    
    var searchResults: [City] = []
    var hotCities: [City] = []
    var currentSelection: City?
    var history: [City] = []
    
    var searching = false
    
    var rowOfRealTimeLocationCell = -1
    
    var homeViewController: HomeViewController?
    
    
    struct Sections {
        static let CurrentSelection = 0
        static let HotCities = 1
        static let History = 2
    }
    
    var appDelegate : AppDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        addCancelButton()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDataAndConfigTable()
        locationTable.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TrackingUtil.trackSelectLocationView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addCancelButton() {
        let button: UIButton = ButtonUtil.barButtonWithTextAndBorder("取消", size: CGRect(x: 0, y: 0, width: 80, height: 26))
        button.addTarget(self, action: #selector(self.cancel(_:)), for: UIControlEvents.touchUpInside)
        let cancelButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    // MARK: - table configuration
    func fetchDataAndConfigTable() {
        getCurrentSelection()
        loadHotCities()
        loadHistory()
    }
    
    func getCurrentSelection() {
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: USING_NOT_AUTO_DETECTED_LOCATION) {
            currentSelection = LocationHelper.getDefaultCityFromCoreData()
            if currentSelection == nil {
                currentSelection = LocationHelper.getDefaultCity()
            }
        } 
    }
    
    func loadHotCities() {
        hotCities.removeAll()
        hotCities += LocationHelper.getHotCities(5)
    }
    
    func loadHistory() {
        history.removeAll()
        history += LocationHelper.getEverUsedCities(5)
    }

    @IBAction func cancel(_ sender: AnyObject) {
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchResults.count
        } else {
            if section == Sections.CurrentSelection {
                if (currentSelection == nil) {
                    rowOfRealTimeLocationCell = 0
                    return 1
                } else {
                    rowOfRealTimeLocationCell = 1
                    return 2
                }
            } else if section == Sections.HotCities {
                return hotCities.count
            } else if section == Sections.History {
                return history.count
            } else {
                return 10
            }
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if searching {
            return 1
        } else {
            var sections = 1
            if hotCities.count > 0 {
                sections = sections + 1
            }
            if history.count > 0 {
                sections = sections + 1
            }
            return sections
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: CityTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cityCell") as? CityTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "CityCell", bundle: nil), forCellReuseIdentifier: "cityCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "cityCell") as? CityTableViewCell
        }
        if (!searching) {
            if (indexPath.section == Sections.CurrentSelection && indexPath.row == 0) {
                cell?.accessoryType = UITableViewCellAccessoryType.checkmark
            } else {
                cell?.accessoryType = UITableViewCellAccessoryType.none
            }
        } else {
            cell?.accessoryType = UITableViewCellAccessoryType.none
        }
        
        if searching {
            let city = searchResults[indexPath.row]
            var activated = true
            if city.activated == nil || city.activated! == false {
                activated = false
            }
            var cityName = ""
            if city.name != nil {
                cityName += city.name!
                cityName += ", "
            }
            if city.state != nil {
                cityName += city.state!
                cityName += ", "
            }
            if city.localizedCountryName != nil {
                cityName += city.localizedCountryName!
            }
            if !activated {
                cityName += "(暂未开通)"
                cell?.activated = false
            } else {
                cell?.activated = true
            }
            cell?.cityName = cityName
            
        } else {
            let section = indexPath.section
            if section == Sections.CurrentSelection {
                let row = indexPath.row
                if currentSelection != nil && row == 0 {
                    let city = currentSelection
                    var cityName = ""
                    if city!.name != nil {
                        cityName += city!.name!
                        cityName += ", "
                    }
                    if city!.state != nil {
                        cityName += city!.state!
                        cityName += ", "
                    }
                    if city!.localizedCountryName != nil {
                        cityName += city!.localizedCountryName!
                    }
                    cell?.cityName = cityName
                } else if currentSelection != nil && row == 1 {
                    cell?.cityName = "使用我的实时位置"
                } else if currentSelection == nil {
                    cell?.cityName = "正在使用实时位置"
                }
                
            } else if section == Sections.History {
                let city = history[indexPath.row]
                var cityName = ""
                if city.name != nil {
                    cityName += city.name!
                    cityName += ", "
                }
                if city.state != nil {
                    cityName += city.state!
                    cityName += ", "
                }
                if city.localizedCountryName != nil {
                    cityName += city.localizedCountryName!
                }
                cell?.cityName = cityName
            } else if section == Sections.HotCities {
                let city = hotCities[indexPath.row]
                var cityName = ""
                if city.name != nil {
                    cityName += city.name!
                    cityName += ", "
                }
                if city.state != nil {
                    cityName += city.state!
                    cityName += ", "
                }
                if city.localizedCountryName != nil {
                    cityName += city.localizedCountryName!
                }
                cell?.cityName = cityName
            }
            cell?.activated = true

        }
        
        return cell!
    }
    
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = LocationHeaderView()
        if searching {
            headerView.title = "请选择城市"
        } else {
            if section == Sections.CurrentSelection {
                headerView.title = "当前城市"
            } else if section == Sections.History {
                headerView.title = "最近选择城市"
            } else if section == Sections.HotCities {
                headerView.title = "热门城市"
            }
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.groupTableViewBackground
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        homeViewController?.currentLocationText = (self.locationTable.cellForRow(at: indexPath) as! CityTableViewCell).cityNameLabel.text
        self.locationTable.deselectRow(at: indexPath, animated: true)
        var city : City? = nil
        if searching {
            searching = false
            city = searchResults[indexPath.row]
        } else {
            if indexPath.section == Sections.CurrentSelection && indexPath.row == rowOfRealTimeLocationCell{
                tryToUseUserRealLocation()
            } else {
                if indexPath.section == Sections.History {
                    city = history[indexPath.row]
                } else if indexPath.section == Sections.HotCities {
                    city = hotCities[indexPath.row]
                }
            }
        }
        if city != nil {
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: USING_NOT_AUTO_DETECTED_LOCATION)
            TrackingUtil.trackUserUsingCity()
            if homeViewController != nil {
                homeViewController!.prepareForDataRefresh()
            }
            userLocationManager.saveCityInUse(city!)
            currentSelection = city
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if searching {
            let city = searchResults[indexPath.row]
            if city.activated == nil || city.activated == false {
                return nil
            }
        } else {
            if indexPath.section == Sections.CurrentSelection && indexPath.row == 0 {
                return nil
            }
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if searching {
            let city = searchResults[indexPath.row]
            if city.activated == nil || city.activated == false {
                return false
            }
        } else {
            if indexPath.section == Sections.CurrentSelection && indexPath.row == 0 {
                return false
            }
        }
        
        return true
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        clearStates()
        self.searchBar?.text = nil
        self.searchBar?.resignFirstResponder()
        self.searchBar?.setShowsCancelButton(false, animated: true)
        searching = false
        locationTable.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar?.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count < 3 {
            if searching == true {
                searching = false
                locationTable.reloadData()
            }
        } else {
            searching = true
            search(searchText)
        }
    }
    
    
    // MARK: - Search
    func search(_ prefix : String) {
        
        let request : GetCitiesRequest = GetCitiesRequest()
        request.prefix = StringUtil.capitalizeString(prefix)
        DataAccessor(serviceConfiguration: ParseConfiguration()).getCities(request) { (searchResponse) in
            OperationQueue.main.addOperation({
                if let results = searchResponse?.results {
                    self.searchResults.removeAll()
                    self.searchResults += results
                    self.locationTable.reloadData()
                }
            })
        }
        
    }
    
    func clearStates() {
        searching = false
        searchResults.removeAll()
    }
    
    
    // MARK: - User real time location handling
    func tryToUseUserRealLocation() {
        appDelegate?.locationManager.startUpdatingLocation()
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleUserLocationDenied), name:NSNotification.Name(rawValue: FAIL_TO_GET_USER_LOCATION), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleUserLocationAllowed), name:NSNotification.Name(rawValue: USER_LOCATION_AVAILABLE), object: nil)
    }
    
    func handleUserLocationDenied() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: FAIL_TO_GET_USER_LOCATION), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: USER_LOCATION_AVAILABLE), object: nil)
        remindUserToAuthorize()
    }
    
    func handleUserLocationAllowed() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: FAIL_TO_GET_USER_LOCATION), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: USER_LOCATION_AVAILABLE), object: nil)
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: NEED_TO_INFORM_USER_LOCATION_CHANGED)
        defaults.set(false, forKey: LOCATION_PERMISSION_DENIED)
        defaults.set(false, forKey: USING_NOT_AUTO_DETECTED_LOCATION)
        if homeViewController != nil {
            homeViewController!.prepareForDataRefresh()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func remindUserToAuthorize() {
        let appearance = SCLAlertView.SCLAppearance(kTitleHeight : 0, kWindowWidth: self.view.frame.size.width - 120, showCloseButton: false, showCircularIcon: true)
        let askLocationAlertView : SCLAlertView? = SCLAlertView(appearance: appearance)
        askLocationAlertView!.addButton("打开设置", backgroundColor: UIColor.themeOrange(), target:self, selector:#selector(self.openLocationSettings))
        askLocationAlertView!.addButton("我知道了", backgroundColor: UIColor.themeOrange(), target:self, selector:#selector(self.dontOpenSettings))
        askLocationAlertView?.showInfo("", subTitle: "\n\n请打开设置\n\n")
    }
    
    func openLocationSettings() {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        }
    }
    
    func dontOpenSettings() {
        locationTable.reloadData()
    }
    
}
