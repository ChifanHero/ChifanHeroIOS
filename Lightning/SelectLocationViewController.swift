//
//  SelectLocationViewController.swift
//  Lightning
//
//  Created by Shi Yan on 5/8/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class SelectLocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var locationTable: UITableView!
    
    var searchResults : [City] = [City]()
    
    var searching = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        cancelButton.tintColor = UIColor.whiteColor()
        doneButton.tintColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
            if section == 0 {
                return 2
            } else if section == 1 {
                return 10
            } else {
                return 10
            }
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if searching {
            return 1
        } else {
            return 2
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
            cell?.cityName = "San Jose, CA, USA"
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
            if section == 0 {
                headerView.title = "当前城市"
            } else if section == 1 {
                headerView.title = "最近选择城市"
            }
        }
        return headerView
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        return footerView
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
