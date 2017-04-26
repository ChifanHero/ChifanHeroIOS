//
//  ListsTableViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 8/20/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK
import MapKit

class SelectedCollectionsTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    var selectedCollections: [SelectedCollection] = []
    
    var isFromBookMark = false
    
    var request: GetSelectedCollectionsByLatAndLonRequest = GetSelectedCollectionsByLatAndLonRequest()
    
    var ratingAndBookmarkExecutor: RatingAndBookmarkExecutor?
    
    var selectedCellFrame = CGRect.zero
    
    var selectedIndexPath: IndexPath?
    
    let transition = ExpandingCellTransition()
    
    var loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
//    let refresher = PullToMakeSoup()
    var pullRefresher: UIRefreshControl!
    
    var lastUsedLocation : Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addImageForBackBarButtonItem()
        self.clearTitleForBackBarButtonItem()
        self.configPullToRefresh()
        ratingAndBookmarkExecutor = RatingAndBookmarkExecutor(baseVC: self)
        initialLoadData()
        self.tableView.contentInset = UIEdgeInsetsMake(-65, 0, 0, 0);
        configLoadingIndicator()
        self.configureNavigationController()
        loadingIndicator.startAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let selectedCellIndexPath: IndexPath? = self.tableView.indexPathForSelectedRow
        if selectedCellIndexPath != nil {
            self.tableView.deselectRow(at: selectedCellIndexPath!, animated: false)
        }
        self.setNavigationBarTranslucent(To: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if self.tableView.pullToRefresh == nil {
//            self.tableView.addPullToRefresh(refresher, action: {self.refreshData()})
//        }
        TrackingUtil.trackCollectionsView()
        if !isFromBookMark && locationChangedSignificantly() {
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
        print(distance)
        if distance >= 1600 {
            return true
        } else {
            return false
        }
        
    }
    
    func configPullToRefresh() {
        pullRefresher = UIRefreshControl()
        let attribute = [ NSForegroundColorAttributeName: UIColor.lightGray,
                          NSFontAttributeName: UIFont(name: "Arial", size: 14.0)!]
        pullRefresher.attributedTitle = NSAttributedString(string: "正在刷新", attributes: attribute)
        pullRefresher.tintColor = UIColor.lightGray
        //        self.homepageTable.addSubview(pullRefresher)
        pullRefresher.addTarget(self, action: #selector(SelectedCollectionsTableViewController.refreshData), for: .valueChanged)
        self.tableView.insertSubview(pullRefresher, at: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func configLoadingIndicator() {
        loadingIndicator.color = UIColor.themeOrange()
        loadingIndicator.type = NVActivityIndicatorType.pacman
        loadingIndicator.center = self.view.center
        self.view.addSubview(loadingIndicator)
    }
    
    fileprivate func initialLoadData() {
        let location = userLocationManager.getLocationInUse()
        if (location == nil || location!.lat == nil || location!.lon == nil) {
            return
        }
        request.userLocation = location
        loadData { (success) -> Void in
            if !success {
                //self.noNetworkDefaultView.show()
            }
        }
    }
    
    func loadData(_ refreshHandler: ((_ success: Bool) -> Void)?) {
        
        if isFromBookMark == true {
            let request: GetFavoritesRequest = GetFavoritesRequest(type: FavoriteTypeEnum.selectedCollection)
            DataAccessor(serviceConfiguration: ParseConfiguration()).getFavorites(request) { (response) -> Void in
                OperationQueue.main.addOperation({ () -> Void in
                    self.clearData()
                    if (response != nil && response?.results != nil) {
                        if response?.results.count == 0 {
                            self.navigationController?.navigationBar.isTranslucent = false
                            self.tabBarController?.tabBar.isHidden = false
                        }
                        for index in 0..<(response?.results)!.count {
                            self.selectedCollections.append((response?.results)![index].selectedCollection!)
                        }
                        self.tableView.reloadData()
                        self.pullRefresher.endRefreshing()
                        self.loadingIndicator.stopAnimation()
                    } else {
                        self.loadingIndicator.stopAnimation()
                        self.navigationController?.navigationBar.isTranslucent = false
                        self.tabBarController?.tabBar.isHidden = false
                        self.pullRefresher.endRefreshing()
                    }
                    
                });
            }
        } else {
            DataAccessor(serviceConfiguration: ParseConfiguration()).getSelectedCollectionByLocation(request) { (response) -> Void in
                OperationQueue.main.addOperation({ () -> Void in
                    self.lastUsedLocation = self.request.userLocation
                    if response == nil {
                        self.pullRefresher.endRefreshing()
                        if refreshHandler != nil {
                            refreshHandler!(false)
                        }
                    } else {
                        self.clearData()
                        if response != nil && response?.results != nil {
                            if response!.results.count > 0 {
                                self.selectedCollections += response!.results
                                self.tableView.isHidden = false
                            } else {
                                self.navigationController?.navigationBar.isTranslucent = false
                                self.tabBarController?.tabBar.isHidden = false
                            }
                            
                            self.tableView.reloadData()
                            
                            if refreshHandler != nil {
                                refreshHandler!(true)
                            }
                            
                            self.pullRefresher.endRefreshing()
                            self.loadingIndicator.stopAnimation()
                        } else {
                            if refreshHandler != nil {
                                refreshHandler!(false)
                            }
                            self.loadingIndicator.stopAnimation()
                            self.pullRefresher.endRefreshing()
                            self.navigationController?.navigationBar.isTranslucent = false
                            self.tabBarController?.tabBar.isHidden = false
                        }
                    }
                })
            }
        }
    }
    
    fileprivate func clearData() {
        self.selectedCollections.removeAll()
    }
    
    func refreshData() {
        let location = userLocationManager.getLocationInUse()
        if (location == nil || location!.lat == nil || location!.lon == nil) {
            return
        }
        request.userLocation = location
        loadData(nil)
    }
    
    fileprivate func refresh(_ sender:AnyObject) {
        refreshData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SelectedCollectionTableViewCell.height
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return selectedCollections.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: SelectedCollectionTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "selectedCollectionCell") as? SelectedCollectionTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "SelectedCollectionCell", bundle: nil), forCellReuseIdentifier: "selectedCollectionCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "selectedCollectionCell") as? SelectedCollectionTableViewCell
        }
        cell?.setUp(selectedCollection: selectedCollections[indexPath.row])
        return cell!
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedCellFrame = tableView.convert(tableView.cellForRow(at: indexPath)!.frame, to: tableView.superview)
        self.performSegue(withIdentifier: "showCollectionMember", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCollectionMember" {
            let controller: RestaurantCollectionMembersViewController = segue.destination as! RestaurantCollectionMembersViewController
            controller.selectedCollection = selectedCollections[(sender as! IndexPath).row]
        }
    }
    
    // MARK: UINavigationControllerDelegate
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == UINavigationControllerOperation.push {
            transition.operation = UINavigationControllerOperation.push
            transition.duration = 0.80
            transition.selectedCellFrame = self.selectedCellFrame
            
            return transition
        }
        
        if operation == UINavigationControllerOperation.pop {
            transition.operation = UINavigationControllerOperation.pop
            transition.duration = 0.80
            
            return transition
        }
        
        return nil
    }


}
