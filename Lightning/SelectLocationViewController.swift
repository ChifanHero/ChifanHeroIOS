//
//  SelectLocationViewController.swift
//  Lightning
//
//  Created by Shi Yan on 5/8/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

class SelectLocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var locationTable: UITableView!
    
    var searchResults : [City] = [City]()
    var hotCities : [City] = [City]()
    var currentSelection : City?
    var history : [City] = [City]()
    
    var searching = false
    
    struct Sections {
        static let CurrentSelection = 0
        static let HotCities = 1
        static let History = 2
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        cancelButton.tintColor = UIColor.whiteColor()
        doneButton.tintColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchDataAndConfigTable()
        locationTable.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        Flurry.logEvent("LocationChangeView")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - table configuration
    func fetchDataAndConfigTable() {
        getCurrentSelection()
        loadHotCities()
        loadHistory()
    }
    
    func getCurrentSelection() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.boolForKey("locationPermissionDenied") {
            currentSelection = LocationHelper.getDefaultCityFromCoreData()
            if currentSelection == nil {
                currentSelection = LocationHelper.getDefaultCity()
            }
        } 
    }
    
    func loadHotCities() {
        hotCities.removeAll()
        hotCities.appendContentsOf(LocationHelper.getHotCities(5))
    }
    
    func loadHistory() {
        history.removeAll()
        history.appendContentsOf(LocationHelper.getEverUsedCities(5))
    }

    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func done(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchResults.count
        } else {
            if section == Sections.CurrentSelection {
                if (currentSelection == nil) {
                    return 1
                } else {
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if searching {
            return 1
        } else {
            var sections = 1
            if hotCities.count > 0 {
                sections = sections + 1
            }
            if history.count > 1 {
                sections = sections + 1
            }
            return sections
        }
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : CityTableViewCell? = tableView.dequeueReusableCellWithIdentifier("cityCell") as? CityTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "CityCell", bundle: nil), forCellReuseIdentifier: "cityCell")
            cell = tableView.dequeueReusableCellWithIdentifier("cityCell") as? CityTableViewCell
        }
        if searching {
            let city = searchResults[indexPath.row]
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
                    cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
                } else if currentSelection != nil && row == 1 {
                    cell?.cityName = "使用我的实时位置"
                } else if currentSelection == nil {
                    cell?.cityName = "正在使用实时位置"
                    cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
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

        }
        
        return cell!
    }
    
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        return footerView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        <#code#>
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        clearStates()
        self.searchBar?.text = nil
        self.searchBar?.resignFirstResponder()
        self.searchBar?.setShowsCancelButton(false, animated: true)
        searching = false
        locationTable.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar?.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
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
    func search(prefix : String) {
        
        let request : GetCitiesRequest = GetCitiesRequest()
        request.prefix = StringUtil.capitalizeString(prefix)
        DataAccessor(serviceConfiguration: ParseConfiguration()).getCities(request) { (searchResponse) in
            NSOperationQueue.mainQueue().addOperationWithBlock({
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
    
}
