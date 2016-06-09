//
//  ListsTableViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 8/20/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

class SelectedCollectionsTableViewController: UITableViewController, UINavigationControllerDelegate, RefreshableViewDelegate {
    
    var selectedCollections: [SelectedCollection] = []
    
    var request: GetSelectedCollectionsByLatAndLonRequest = GetSelectedCollectionsByLatAndLonRequest()
    
    var footerView: LoadMoreFooterView?
    
    var ratingAndBookmarkExecutor: RatingAndBookmarkExecutor?
    
    //let refreshControl = Respinner(spinningView: UIImageView(image: UIImage(named: "Pull_Refresh")))
    
    var isLoadingMore = false
    
    var selectedCellFrame = CGRectZero
    
    var selectedIndexPath: NSIndexPath?
    
    let transition = ExpandingCellTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearTitleForBackBarButtonItem()
        setTableViewFooterView()
        //refreshControl!.addTarget(self, action: #selector(SelectedCollectionsTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        //self.tableView.addSubview(refreshControl!)
        ratingAndBookmarkExecutor = RatingAndBookmarkExecutor(baseVC: self)
        //waitingIndicator.hidden = true
        initialLoadData()
        self.tableView.contentInset = UIEdgeInsetsMake(-65, 0, 0, 0);
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let selectedCellIndexPath: NSIndexPath? = self.tableView.indexPathForSelectedRow
        if selectedCellIndexPath != nil {
            self.tableView.deselectRowAtIndexPath(selectedCellIndexPath!, animated: false)
        }
        self.navigationController?.navigationBar.translucent = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        Flurry.logEvent("CollectionsView")
    }
    
    
    private func setTableViewFooterView() {
        let frame = CGRectMake(0, 0, self.view.frame.size.width, 30)
        footerView = LoadMoreFooterView(frame: frame)
        footerView?.reset()
        self.tableView.tableFooterView = footerView
    }
    
    private func clearTitleForBackBarButtonItem(){
        let barButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = barButtonItem
    }
    
    func refreshData() {
        footerView?.reset()
        //self.waitingIndicator.startAnimating()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let location = appDelegate.currentLocation
        if (location.lat == nil || location.lon == nil) {
            return
        }
        request.userLocation = location
        loadData(nil)
    }
    
    private func initialLoadData() {
        footerView?.reset()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let location = appDelegate.currentLocation
        if (location.lat == nil || location.lon == nil) {
            return
        }
        //self.waitingIndicator.hidden = false
        //self.waitingIndicator.startAnimating()
        request.userLocation = location
        loadData { (success) -> Void in
            if !success {
                //self.noNetworkDefaultView.show()
            }
        }
    }
    
    func loadData(refreshHandler: ((success: Bool) -> Void)?) {
        
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
                    
                }
                self.isLoadingMore = false
                //self.refreshControl!.endRefreshing()
                //self.waitingIndicator.stopAnimating()
                //self.waitingIndicator.hidden = true
                self.footerView!.activityIndicator.stopAnimating()
            })
            
            
        }
    }
    
    private func clearData() {
        self.selectedCollections.removeAll()
    }
    
    private func needToLoadMore() -> Bool {
        return false
    }
    
    func loadMore() {
    }
    
    @objc private func refresh(sender:AnyObject) {
        refreshData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return SelectedCollectionTableViewCell.height
        //return 120
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return selectedCollections.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if selectedCollections.isEmpty {
            return 0
        }
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: SelectedCollectionTableViewCell? = tableView.dequeueReusableCellWithIdentifier("SelectedCollectionCell") as? SelectedCollectionTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "SelectedCollectionCell", bundle: nil), forCellReuseIdentifier: "SelectedCollectionCell")
            cell = tableView.dequeueReusableCellWithIdentifier("SelectedCollectionCell") as? SelectedCollectionTableViewCell
        }
        cell?.setUp(selectedCollection: selectedCollections[indexPath.row])
        return cell!
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.selectedCellFrame = tableView.convertRect(tableView.cellForRowAtIndexPath(indexPath)!.frame, toView: tableView.superview)
        self.performSegueWithIdentifier("showCollectionMember", sender: indexPath)
        
//        
//        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("restaurantCollectionMembers") as! RestaurantCollectionMembersViewController
//        controller.selectedCollection = selectedCollections[indexPath.row]
//        controller.transition = ExpandingCellTransition()
//        controller.transition!.operation = UINavigationControllerOperation.Push
//        controller.transition!.duration = 0.80
//        controller.transition!.selectedCellFrame = self.selectedCellFrame
//        
//        presentViewController(controller, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showCollectionMember" {
            //self.navigationController?.delegate = self
            let controller: RestaurantCollectionMembersViewController = segue.destinationViewController as! RestaurantCollectionMembersViewController
            controller.selectedCollection = selectedCollections[(sender as! NSIndexPath).row]
            //controller.transition = ExpandingCellTransition()
            //controller.transition!.operation = UINavigationControllerOperation.Push
            //controller.transition!.duration = 0.80
            //controller.transition!.selectedCellFrame = self.selectedCellFrame
        }
    }
    
    @objc private func reloadTable() {
        self.tableView.reloadData()
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.isKindOfClass(UITableView.classForCoder()) && scrollView.contentOffset.y > 0.0 {
            let scrollPosition = scrollView.contentSize.height - CGRectGetHeight(scrollView.frame) - scrollView.contentOffset.y
            if scrollPosition < 30 && !self.isLoadingMore {
                if self.needToLoadMore() {
                    self.loadMore()
                } else {
                    footerView?.showFinishMessage()
                }
                
            }
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
