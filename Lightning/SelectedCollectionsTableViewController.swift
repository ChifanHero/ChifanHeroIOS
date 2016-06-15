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
    
    let refresher = PullToMakeSoup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearTitleForBackBarButtonItem()
        ratingAndBookmarkExecutor = RatingAndBookmarkExecutor(baseVC: self)
        initialLoadData()
        self.tableView.contentInset = UIEdgeInsetsMake(-65, 0, -49, 0);
        configLoadingIndicator()
        loadingIndicator.startAnimation()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let selectedCellIndexPath: NSIndexPath? = self.tableView.indexPathForSelectedRow
        if selectedCellIndexPath != nil {
            self.tableView.deselectRowAtIndexPath(selectedCellIndexPath!, animated: false)
        }
        self.navigationController?.navigationBar.translucent = true
        setTabBarVisible(false, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        Flurry.logEvent("CollectionsView")
        loadingIndicator.stopAnimation()
        self.tableView.addPullToRefresh(refresher, action: {self.refreshData()})
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
    
    private func clearTitleForBackBarButtonItem(){
        let barButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = barButtonItem
    }
    
    private func initialLoadData() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let location = appDelegate.getCurrentLocation()
        if (location.lat == nil || location.lon == nil) {
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
                    for index in 0..<(response?.results)!.count {
                        self.selectedCollections.append((response?.results)![index].selectedCollection!)
                    }
                    self.tableView.reloadData()
                    self.tableView.endRefreshing()
                });
            }
        } else {
            DataAccessor(serviceConfiguration: ParseConfiguration()).getSelectedCollectionByLocation(request) { (response) -> Void in
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    if response == nil {
                        if refreshHandler != nil {
                            refreshHandler!(success: false)
                        }
                    } else {
                        self.clearData()
                        if response!.results.count > 0 {
                            self.selectedCollections += response!.results
                            self.tableView.hidden = false
                        }
                        
                        self.tableView.reloadData()
                        
                        if refreshHandler != nil {
                            refreshHandler!(success: true)
                        }
                        
                        self.tableView.endRefreshing()
                        
                    }
                })
            }
        }
    }
    
    private func clearData() {
        self.selectedCollections.removeAll()
    }
    
    func refreshData() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let location = appDelegate.getCurrentLocation()
        if (location.lat == nil || location.lon == nil) {
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
