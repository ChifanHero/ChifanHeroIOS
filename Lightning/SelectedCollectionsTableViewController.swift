//
//  ListsTableViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 8/20/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit
import PullToMakeSoup
import Flurry_iOS_SDK

class SelectedCollectionsTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    var selectedCollections: [SelectedCollection] = []
    
    var isFromBookMark = false
    
    var request: GetSelectedCollectionsByLatAndLonRequest = GetSelectedCollectionsByLatAndLonRequest()
    
    var ratingAndBookmarkExecutor: RatingAndBookmarkExecutor?
    
    var selectedCellFrame = CGRectZero
    
    var selectedIndexPath: NSIndexPath?
    
    let transition = ExpandingCellTransition()
    
    var loadingIndicator = NVActivityIndicatorView(frame: CGRectMake(0, 0, 40, 40))
    
//    let refresher = PullToMakeSoup()
    var pullRefresher: UIRefreshControl!
    
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let selectedCellIndexPath: NSIndexPath? = self.tableView.indexPathForSelectedRow
        if selectedCellIndexPath != nil {
            self.tableView.deselectRowAtIndexPath(selectedCellIndexPath!, animated: false)
        }
        self.setNavigationBarTranslucent(To: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        if self.tableView.pullToRefresh == nil {
//            self.tableView.addPullToRefresh(refresher, action: {self.refreshData()})
//        }
        TrackingUtil.trackCollectionsView()
    }
    
    func configPullToRefresh() {
        pullRefresher = UIRefreshControl()
        let attribute = [ NSForegroundColorAttributeName: UIColor.lightGrayColor(),
                          NSFontAttributeName: UIFont(name: "Arial", size: 14.0)!]
        pullRefresher.attributedTitle = NSAttributedString(string: "正在刷新", attributes: attribute)
        pullRefresher.tintColor = UIColor.lightGrayColor()
        //        self.homepageTable.addSubview(pullRefresher)
        pullRefresher.addTarget(self, action: #selector(SelectedCollectionsTableViewController.refreshData), forControlEvents: .ValueChanged)
        self.tableView.insertSubview(pullRefresher, atIndex: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configLoadingIndicator() {
        loadingIndicator.color = UIColor.themeOrange()
        loadingIndicator.type = NVActivityIndicatorType.Pacman
        loadingIndicator.center = self.view.center
        self.view.addSubview(loadingIndicator)
    }
    
    private func initialLoadData() {
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
    
    func loadData(refreshHandler: ((success: Bool) -> Void)?) {
        
        if isFromBookMark == true {
            let request: GetFavoritesRequest = GetFavoritesRequest(type: FavoriteTypeEnum.SelectedCollection)
            DataAccessor(serviceConfiguration: ParseConfiguration()).getFavorites(request) { (response) -> Void in
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.clearData()
                    if (response != nil && response?.results != nil) {
                        if response?.results.count == 0 {
                            self.navigationController?.navigationBar.translucent = false
                            self.tabBarController?.tabBar.hidden = false
                        }
                        for index in 0..<(response?.results)!.count {
                            self.selectedCollections.append((response?.results)![index].selectedCollection!)
                        }
                        self.tableView.reloadData()
                        self.pullRefresher.endRefreshing()
                        self.tableView.endRefreshing()
                        self.loadingIndicator.stopAnimation()
                    } else {
                        self.tableView.endRefreshing()
                        self.loadingIndicator.stopAnimation()
                        self.navigationController?.navigationBar.translucent = false
                        self.tabBarController?.tabBar.hidden = false
                        self.pullRefresher.endRefreshing()
                    }
                    
                });
            }
        } else {
            DataAccessor(serviceConfiguration: ParseConfiguration()).getSelectedCollectionByLocation(request) { (response) -> Void in
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    if response == nil {
                        self.pullRefresher.endRefreshing()
                        if refreshHandler != nil {
                            refreshHandler!(success: false)
                        }
                    } else {
                        self.clearData()
                        if response != nil && response?.results != nil {
                            if response!.results.count > 0 {
                                self.selectedCollections += response!.results
                                self.tableView.hidden = false
                            } else {
                                self.navigationController?.navigationBar.translucent = false
                                self.tabBarController?.tabBar.hidden = false
                            }
                            
                            self.tableView.reloadData()
                            
                            if refreshHandler != nil {
                                refreshHandler!(success: true)
                            }
                            
                            self.tableView.endRefreshing()
                            self.pullRefresher.endRefreshing()
                            self.loadingIndicator.stopAnimation()
                        } else {
                            if refreshHandler != nil {
                                refreshHandler!(success: false)
                            }
                            self.tableView.endRefreshing()
                            self.loadingIndicator.stopAnimation()
                            self.pullRefresher.endRefreshing()
                            self.navigationController?.navigationBar.translucent = false
                            self.tabBarController?.tabBar.hidden = false
                        }
                    }
                })
            }
        }
    }
    
    private func clearData() {
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
    
    private func refresh(sender:AnyObject) {
        refreshData()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return SelectedCollectionTableViewCell.height
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return selectedCollections.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: SelectedCollectionTableViewCell? = tableView.dequeueReusableCellWithIdentifier("selectedCollectionCell") as? SelectedCollectionTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "SelectedCollectionCell", bundle: nil), forCellReuseIdentifier: "selectedCollectionCell")
            cell = tableView.dequeueReusableCellWithIdentifier("selectedCollectionCell") as? SelectedCollectionTableViewCell
        }
        cell?.setUp(selectedCollection: selectedCollections[indexPath.row])
        return cell!
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.selectedCellFrame = tableView.convertRect(tableView.cellForRowAtIndexPath(indexPath)!.frame, toView: tableView.superview)
        self.performSegueWithIdentifier("showCollectionMember", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showCollectionMember" {
            let controller: RestaurantCollectionMembersViewController = segue.destinationViewController as! RestaurantCollectionMembersViewController
            controller.selectedCollection = selectedCollections[(sender as! NSIndexPath).row]
        }
    }
    
    // MARK: UINavigationControllerDelegate
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == UINavigationControllerOperation.Push {
            transition.operation = UINavigationControllerOperation.Push
            transition.duration = 0.40
            transition.selectedCellFrame = self.selectedCellFrame
            
            return transition
        }
        
        if operation == UINavigationControllerOperation.Pop {
            transition.operation = UINavigationControllerOperation.Pop
            transition.duration = 0.20
            
            return transition
        }
        
        return nil
    }


}
