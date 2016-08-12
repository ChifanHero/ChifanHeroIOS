//
//  SearchViewController.swift
//  Lightning
//
//  Created by Shi Yan on 8/5/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, SearchHistoryCellDelegate {
    
    
    @IBOutlet weak var addressContainerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var addressBar: UITextField!
    
    @IBOutlet weak var searchBar: UITextField!
    
    @IBOutlet weak var suggestionTableView: UITableView!
    
    private var currentState : CurrentState?
    
    var keywordHistory : [String] = [String]()
    var addressHistory : [String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        addressBar.delegate = self
        addCancelButton()
        addSearchButton()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
        self.view.layoutIfNeeded()
        self.addressContainerHeight.constant = 37
        UIView.animateWithDuration(0.2, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
            self.view.layoutIfNeeded()
        }) { (success) in
            let defaults = NSUserDefaults.standardUserDefaults()
            if !defaults.boolForKey("usingCustomLocation") {
                self.addressBar.attributedText = self.getHighlightedCurrentLocationText()
            }

        }
    }
    
    private func getHighlightedCurrentLocationText() -> NSAttributedString{
        let text = "当前位置"
        let range = NSMakeRange(0, text.characters.count)
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: range)
        return attributedString
    }

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
        } else if textField == addressBar {
            currentState = CurrentState.ADDRESS
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
    
    func confirmSearch() {
        commitSearchEvent()
        goToResultsDisplayVC()
    }
    
    func commitSearchEvent() {
        let keyword = searchBar.text
        let address = addressBar.text
        searchContext.keyword = keyword
        if keyword != nil && keyword != "" {
            SearchHistory.saveKeyword(keyword!)
            searchContext.sort = SortOptions.BESTMATCH
            searchContext.rating = RatingFilter.NONE
        } else {
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
        } else {
            searchContext.address = nil
            let location: Location? = userLocationManager.getLocationInUse()
            searchContext.coordinates = location
        }
        searchContext.offSet = 0
        searchContext.distance = RangeFilter.AUTO
        
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
            return addressHistory.count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if currentState == CurrentState.KEYWORD {
            let keyword = keywordHistory[indexPath.row]
            searchBar.text = keyword
        } else {
            let address = addressHistory[indexPath.row]
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

}
