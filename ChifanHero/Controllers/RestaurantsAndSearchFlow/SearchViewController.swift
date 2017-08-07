//
//  SearchViewController.swift
//  Lightning
//
//  Created by Shi Yan on 8/5/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit
import GooglePlaces

class SearchViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, SearchHistoryCellDelegate {
    
    @IBOutlet weak var addressContainerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var addressBar: UITextField!
    
    @IBOutlet weak var searchBar: UITextField!
    
    @IBOutlet weak var suggestionTableView: UITableView!
    
    fileprivate var currentState: CurrentState?
    
    var keywordHistory: [String] = [String]()
    var addressHistory: [String] = [String]()
    var addressAutoCompletion: [NSAttributedString] = [NSAttributedString]()
    
    var pullRefresher: UIRefreshControl!
    
    var bounds: GMSCoordinateBounds?

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        addressBar.delegate = self
        addressBar.addTarget(self, action: #selector(SearchViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        addCancelButton()
        addSearchButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TrackingUtil.trackSearchView()
        searchBar.text = searchContext.keyword
        searchBar.becomeFirstResponder()
        searchBar.selectAll(nil)
        self.view.layoutIfNeeded()
        self.addressContainerHeight.constant = 37
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            if searchContext.address != nil && searchContext.address != "" {
                self.addressBar.text = searchContext.address
            }
            let defaults = UserDefaults.standard
            if !defaults.bool(forKey: USING_NOT_AUTO_DETECTED_LOCATION) {
                self.addressBar.placeholder = "当前位置"
            } else {
                let cityInUse = userLocationManager.getCityInUse()
                if cityInUse != nil && cityInUse?.name != nil && cityInUse?.state != nil {
                    let fullCityName = cityInUse!.name! + ", " + cityInUse!.state!
                    self.addressBar.placeholder = fullCityName
                }
            }
        }
    }
    
    func addCancelButton() {
        let button: UIButton = ButtonUtil.barButtonWithTextAndBorder("取消", size: CGRect(x: 0, y: 0, width: 80, height: 26))
        button.addTarget(self, action: #selector(SearchViewController.cancel(_:)), for: UIControlEvents.touchUpInside)
        let cancelButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    func addSearchButton() {
        let button: UIButton = ButtonUtil.barButtonWithTextAndBorder("搜索", size: CGRect(x: 0, y: 0, width: 80, height: 26))
        button.addTarget(self, action: #selector(SearchViewController.confirmSearch), for: UIControlEvents.touchUpInside)
        let cancelButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = cancelButton
    }
    
    func cancel(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: false)
    }

    
    // Mark : TextField delegate method
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == searchBar {
            currentState = CurrentState.keyword
            if keywordHistory.count == 0 {
                keywordHistory.append(contentsOf: loadKeywordHistory())
            }
            addressAutoCompletion.removeAll()
        } else if textField == addressBar {
            currentState = CurrentState.address
            if addressBar.text?.characters.count ?? 0 > 0 {
                addressAutoComplete()
            }
            if addressHistory.count == 0 {
                addressHistory.append(contentsOf: loadAddressHistory())
            }
        }
        suggestionTableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        confirmSearch()
        return true
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        if textField.text?.characters.count ?? 0 > 0 {
            addressAutoComplete()
        } else {
            addressAutoCompletion.removeAll()
            suggestionTableView.reloadData()
        }
        
    }
    
    
    func confirmSearch() {
        commitSearchEvent()
        goToResultsDisplayVC()
    }
    
    func commitSearchEvent() {
        let keyword = searchBar.text
        let address = addressBar.text
        if keyword != nil && keyword != "" {
            searchContext.keyword = keyword
            SearchHistory.saveKeyword(keyword!)
            searchContext.sort = SortOptions.bestmatch
            searchContext.rating = RatingFilter.none
        } else {
            searchContext.keyword = nil
            searchContext.sort = SortOptions.hotness
        }
        if address != nil && address != "" {
            if address == "当前位置" {
                searchContext.address = nil
                searchContext.coordinates = userLocationManager.getLocationInUse()
            } else {
                searchContext.address = address
                SearchHistory.saveAddress(address!)
            }
            searchContext.distance = RangeFilter.twenty
        } else {
            searchContext.address = nil
            let location: Location? = userLocationManager.getLocationInUse()
            searchContext.coordinates = location
            searchContext.distance = RangeFilter.auto
        }
    }
    
    func goToResultsDisplayVC() {
        let tabBarController = self.tabBarController
        let selectedIndex = tabBarController!.selectedIndex
        if selectedIndex == 1 {
            self.navigationController?.popViewController(animated: false)
        } else {
            tabBarController!.selectedIndex = 1
        }
    }
    
    // Mark : TableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentState == CurrentState.keyword {
            return keywordHistory.count
        } else {
            if addressAutoCompletion.count > 0 {
                return addressAutoCompletion.count + 1
            } else {
                return addressHistory.count
            }
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if addressAutoCompletion.count > 0 {
            if indexPath.row <= addressAutoCompletion.count - 1 { // Auto completion cell
                var cell: AddressAutoCompletionTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "autoCompletionCell") as? AddressAutoCompletionTableViewCell
                if cell == nil {
                    tableView.register(UINib(nibName: "AddressAutoCompletionCell", bundle: nil), forCellReuseIdentifier: "autoCompletionCell")
                    cell = tableView.dequeueReusableCell(withIdentifier: "autoCompletionCell") as? AddressAutoCompletionTableViewCell
                }
                cell!.suggestionLabel.attributedText = addressAutoCompletion[indexPath.row]
                return cell!
            } else { // google logo cell
                var cell: GoogleLogoTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "googleLogoCell") as? GoogleLogoTableViewCell
                if cell == nil {
                    tableView.register(UINib(nibName: "GoogleLogoCell", bundle: nil), forCellReuseIdentifier: "googleLogoCell")
                    cell = tableView.dequeueReusableCell(withIdentifier: "googleLogoCell") as? GoogleLogoTableViewCell
                }
                return cell!
            }
        } else { // history cell
            var cell: SearchHistoryTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "historyCell") as? SearchHistoryTableViewCell
            if cell == nil {
                tableView.register(UINib(nibName: "SearchHistoryCell", bundle: nil), forCellReuseIdentifier: "historyCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as? SearchHistoryTableViewCell
            }
            cell?.delegate = self
            if currentState == CurrentState.keyword {
                cell?.history = keywordHistory[indexPath.row]
            } else {
                cell?.history = addressHistory[indexPath.row]
            }
            return cell!
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentState == CurrentState.keyword {
            let keyword = keywordHistory[indexPath.row]
            searchBar.text = keyword
        } else {
            var address : String = ""
            if addressAutoCompletion.count > indexPath.row {
                address = addressAutoCompletion[indexPath.row].string
            } else {
                if addressHistory.count > indexPath.row {
                    address = addressHistory[indexPath.row]
                }
            }
            addressBar.text = address
        }
        suggestionTableView.deselectRow(at: indexPath, animated: false)
    }
    
    // Mark : history data
    func loadKeywordHistory() -> [String]{
        return SearchHistory.getRecentKeywords(10)
    }
    
    func loadAddressHistory() -> [String]{
        return SearchHistory.getRecentAddress(10)
    }
    
    fileprivate enum CurrentState {
        case keyword
        case address
    }
    
    // Mark : SearchHistoryCellDelegate
    func deleteHistory(_ cell: SearchHistoryTableViewCell) {
        let indexPath :IndexPath = self.suggestionTableView.indexPath(for: cell)!
        if currentState == CurrentState.keyword {
            keywordHistory.remove(at: indexPath.row)
            SearchHistory.removeKeywordFromHistory(cell.history!)
        } else {
            addressHistory.remove(at: indexPath.row)
            SearchHistory.removeAddressFromHistory(cell.history!)
        }
        self.suggestionTableView.reloadData()
    }
    
    // Mark : Google Places API Address autocomplete
    func addressAutoComplete() {
        let regularFont = UIFont.systemFont(ofSize: 15.0)
        let boldFont = UIFont.boldSystemFont(ofSize: 15.0)
        let filter = GMSAutocompleteFilter()
        let placesClient = GMSPlacesClient()
        filter.type = .noFilter
        filter.country = "us"
        if bounds == nil {
            let boundingBox : BoundingBox = BoundingBox.getBoundingBox(userLocationManager.getLocationInUse()!, radiusInKm: 50)
            let neBoundsCorner = CLLocationCoordinate2D(latitude: boundingBox.maxPoint!.lat!, longitude: boundingBox.maxPoint!.lon!)
            let swBoundsCorner = CLLocationCoordinate2D(latitude: boundingBox.minPoint!.lat!, longitude: boundingBox.minPoint!.lon!)
            bounds = GMSCoordinateBounds(coordinate: neBoundsCorner, coordinate: swBoundsCorner)
        }
        
        placesClient.autocompleteQuery(addressBar.text!, bounds: bounds, filter: filter, callback: { (results, error) -> Void in
            guard error == nil else {
                print("Autocomplete error \(String(describing: error))")
                return
            }
            
            self.addressAutoCompletion.removeAll()
            for result in results! {
                let bolded = result.attributedFullText.mutableCopy() as! NSMutableAttributedString
                
                bolded.enumerateAttribute(kGMSAutocompleteMatchAttribute, in: NSMakeRange(0, bolded.length), options: NSAttributedString.EnumerationOptions.longestEffectiveRangeNotRequired) { (value, range: NSRange, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                    let font = (value == nil) ? regularFont : boldFont
                    bolded.addAttribute(NSFontAttributeName, value: font, range: range)
                }
                self.addressAutoCompletion.append(bolded)
            }
            self.suggestionTableView.reloadData()
        })
    }

}
