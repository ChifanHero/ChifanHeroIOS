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
    
    private var currentState : CurrentState?
    
    var keywordHistory : [String] = [String]()
    var addressHistory : [String] = [String]()
    var addressAutoCompletion : [NSAttributedString] = [NSAttributedString]()
    
    var pullRefresher: UIRefreshControl!
    
    var bounds : GMSCoordinateBounds?

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        addressBar.delegate = self
        addressBar.addTarget(self, action: #selector(SearchViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        addCancelButton()
        addSearchButton()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        TrackingUtil.trackSearchView()
        searchBar.text = searchContext.keyword
        searchBar.becomeFirstResponder()
        searchBar.selectAll(nil)
        self.view.layoutIfNeeded()
        self.addressContainerHeight.constant = 37
        UIView.animateWithDuration(0.2, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            if searchContext.address != nil && searchContext.address != "" {
                self.addressBar.text = searchContext.address
            }
            let defaults = NSUserDefaults.standardUserDefaults()
            if !defaults.boolForKey("usingCustomLocation") {
                //                self.addressBar.attributedText = self.getHighlightedCurrentLocationText()
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
    
//    private func getHighlightedCurrentLocationText() -> NSAttributedString{
//        let text = "当前位置"
//        let range = NSMakeRange(0, text.characters.count)
//        let attributedString = NSMutableAttributedString(string: text)
//        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: range)
//        return attributedString
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addCancelButton() {
        let button: UIButton = UIButton.barButtonWithTextAndBorder("取消", size: CGRectMake(0, 0, 80, 26))
        button.addTarget(self, action: #selector(SearchViewController.cancel(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let cancelButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    func addSearchButton() {
        let button: UIButton = UIButton.barButtonWithTextAndBorder("搜索", size: CGRectMake(0, 0, 80, 26))
        button.addTarget(self, action: #selector(SearchViewController.confirmSearch), forControlEvents: UIControlEvents.TouchUpInside)
        let cancelButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = cancelButton
    }
    
    func cancel(sender: AnyObject) {
//        let tabBarController = self.tabBarController
        self.navigationController?.popViewControllerAnimated(false)
//        searchContext.keyword = "iphone"
//        let tabBarController = self.tabBarController
//        let selectedIndex = tabBarController!.selectedIndex
//        print(selectedIndex)
        
//        self.dismissViewControllerAnimated(false, completion: nil)
//        let storyboard = UIStoryboard(name: "RestaurantsAndSearch", bundle: nil)
        
        
    }

    
    // Mark : TextField delegate method
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == searchBar {
            currentState = CurrentState.KEYWORD
            if keywordHistory.count == 0 {
                keywordHistory.appendContentsOf(loadKeywordHistory())
            }
            addressAutoCompletion.removeAll()
        } else if textField == addressBar {
            currentState = CurrentState.ADDRESS
            if addressBar.text?.characters.count > 0 {
                addressAutoComplete()
            }
            if addressHistory.count == 0 {
                addressHistory.appendContentsOf(loadAddressHistory())
            }
        }
        suggestionTableView.reloadData()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        confirmSearch()
        return true
    }
    
    func textFieldDidChange(textField: UITextField) {
        if textField.text?.characters.count > 0 {
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
            searchContext.sort = SortOptions.BESTMATCH
            searchContext.rating = RatingFilter.NONE
        } else {
            searchContext.keyword = nil
            searchContext.sort = SortOptions.HOTNESS
//            searchContext.rating = RatingFilter.FOUR
        }
        if address != nil && address != "" {
            if address == "当前位置" {
                searchContext.address = nil
                searchContext.coordinates = userLocationManager.getLocationInUse()
            } else {
                searchContext.address = address
                SearchHistory.saveAddress(address!)
            }
            searchContext.distance = RangeFilter.TWENTY
        } else {
            searchContext.address = nil
            let location: Location? = userLocationManager.getLocationInUse()
            searchContext.coordinates = location
            searchContext.distance = RangeFilter.AUTO
        }
        searchContext.offSet = 0
        
        
    }
    
    func goToResultsDisplayVC() {
        let tabBarController = self.tabBarController
        let selectedIndex = tabBarController!.selectedIndex
        if selectedIndex == 1 {
            self.navigationController?.popViewControllerAnimated(false)
        } else {
            tabBarController!.selectedIndex = 1
        }
    }
    
    // Mark : TableView methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentState == CurrentState.KEYWORD {
            return keywordHistory.count
        } else {
            if addressAutoCompletion.count > 0 {
                return addressAutoCompletion.count + 1
            } else {
                return addressHistory.count
            }
            
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if addressAutoCompletion.count > 0 {
            if indexPath.row <= addressAutoCompletion.count - 1 { // Auto completion cell
                var cell: AddressAutoCompletionTableViewCell? = tableView.dequeueReusableCellWithIdentifier("autoCompletionCell") as? AddressAutoCompletionTableViewCell
                if cell == nil {
                    tableView.registerNib(UINib(nibName: "AddressAutoCompletionCell", bundle: nil), forCellReuseIdentifier: "autoCompletionCell")
                    cell = tableView.dequeueReusableCellWithIdentifier("autoCompletionCell") as? AddressAutoCompletionTableViewCell
                }
                cell!.suggestionLabel.attributedText = addressAutoCompletion[indexPath.row]
                return cell!
            } else { // google logo cell
                var cell: GoogleLogoTableViewCell? = tableView.dequeueReusableCellWithIdentifier("googleLogoCell") as? GoogleLogoTableViewCell
                if cell == nil {
                    tableView.registerNib(UINib(nibName: "GoogleLogoCell", bundle: nil), forCellReuseIdentifier: "googleLogoCell")
                    cell = tableView.dequeueReusableCellWithIdentifier("googleLogoCell") as? GoogleLogoTableViewCell
                }
                return cell!
            }
        } else { // history cell
            var cell: SearchHistoryTableViewCell? = tableView.dequeueReusableCellWithIdentifier("historyCell") as? SearchHistoryTableViewCell
            if cell == nil {
                tableView.registerNib(UINib(nibName: "SearchHistoryCell", bundle: nil), forCellReuseIdentifier: "historyCell")
                cell = tableView.dequeueReusableCellWithIdentifier("historyCell") as? SearchHistoryTableViewCell
            }
            cell?.delegate = self
            if currentState == CurrentState.KEYWORD {
                cell?.history = keywordHistory[indexPath.row]
            } else {
                cell?.history = addressHistory[indexPath.row]
            }
            return cell!
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if currentState == CurrentState.KEYWORD {
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
        suggestionTableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    // Mark : history data
    func loadKeywordHistory() -> [String]{
        return SearchHistory.getRecentKeywords(10)
    }
    
    func loadAddressHistory() -> [String]{
        return SearchHistory.getRecentAddress(10)
    }
    
    private enum CurrentState {
        case KEYWORD
        case ADDRESS
    }
    
    // Mark : SearchHistoryCellDelegate
    func deleteHistory(cell: SearchHistoryTableViewCell) {
        let indexPath :NSIndexPath = self.suggestionTableView.indexPathForCell(cell)!
        if currentState == CurrentState.KEYWORD {
            keywordHistory.removeAtIndex(indexPath.row)
            SearchHistory.removeKeywordFromHistory(cell.history!)
        } else {
            addressHistory.removeAtIndex(indexPath.row)
            SearchHistory.removeAddressFromHistory(cell.history!)
        }
        self.suggestionTableView.reloadData()
    }
    
    // Mark : Google Places API Address autocomplete
    func addressAutoComplete() {
        let regularFont = UIFont.systemFontOfSize(15.0)
        let boldFont = UIFont.boldSystemFontOfSize(15.0)
        let filter = GMSAutocompleteFilter()
        let placesClient = GMSPlacesClient()
        filter.type = .NoFilter
        filter.country = "us"
        if bounds == nil {
            let boundingBox : BoundingBox = BoundingBox.getBoundingBox(userLocationManager.getLocationInUse()!, radiusInKm: 50)
            let neBoundsCorner = CLLocationCoordinate2D(latitude: boundingBox.maxPoint!.lat!, longitude: boundingBox.maxPoint!.lon!)
            let swBoundsCorner = CLLocationCoordinate2D(latitude: boundingBox.minPoint!.lat!, longitude: boundingBox.minPoint!.lon!)
            bounds = GMSCoordinateBounds(coordinate: neBoundsCorner, coordinate: swBoundsCorner)
            print(neBoundsCorner)
            print(swBoundsCorner)
        }
        
        
        placesClient.autocompleteQuery(addressBar.text!, bounds: bounds, filter: filter, callback: { (results, error: NSError?) -> Void in
            guard error == nil else {
                print("Autocomplete error \(error)")
                return
            }
            
            self.addressAutoCompletion.removeAll()
            for result in results! {
                let bolded = result.attributedFullText.mutableCopy() as! NSMutableAttributedString
                
                bolded.enumerateAttribute(kGMSAutocompleteMatchAttribute, inRange: NSMakeRange(0, bolded.length), options: NSAttributedStringEnumerationOptions.LongestEffectiveRangeNotRequired) { (value, range: NSRange, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                    let font = (value == nil) ? regularFont : boldFont
                    bolded.addAttribute(NSFontAttributeName, value: font, range: range)
                }
                self.addressAutoCompletion.append(bolded)
//                print("Result \(result.attributedFullText) with placeID \(result.placeID)")
            }
            self.suggestionTableView.reloadData()
        })
    }

}
