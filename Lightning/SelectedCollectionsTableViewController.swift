//
//  ListsTableViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 8/20/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class SelectedCollectionsTableViewController: RefreshableViewController, UITableViewDelegate, UITableViewDataSource {
    
    var selectedCollections: [SelectedCollection] = []
    
    var request: GetSelectedCollectionsByLatAndLonRequest = GetSelectedCollectionsByLatAndLonRequest()
    
    var footerView: LoadMoreFooterView?
    
    var ratingAndBookmarkExecutor: RatingAndBookmarkExecutor?
    
    let refreshControl = Respinner(spinningView: UIImageView(image: UIImage(named: "Pull_Refresh")))
    
    var isLoadingMore = false
    
    
    @IBOutlet weak var selectedCollectionTable: UITableView!
    @IBOutlet weak var waitingIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearTitleForBackBarButtonItem()
        setTableViewFooterView()
        refreshControl.addTarget(self, action: #selector(SelectedCollectionsTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.selectedCollectionTable.addSubview(refreshControl)
        ratingAndBookmarkExecutor = RatingAndBookmarkExecutor(baseVC: self)
        self.selectedCollectionTable.hidden = true
        waitingIndicator.hidden = true
        initialLoadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        let selectedCellIndexPath : NSIndexPath? = self.selectedCollectionTable.indexPathForSelectedRow
        if selectedCellIndexPath != nil {
            self.selectedCollectionTable.deselectRowAtIndexPath(selectedCellIndexPath!, animated: false)
        }
        self.navigationController?.navigationBar.translucent = false
    }
    
    private func setTableViewFooterView() {
        let frame = CGRectMake(0, 0, self.view.frame.size.width, 30)
        footerView = LoadMoreFooterView(frame: frame)
        footerView?.reset()
        self.selectedCollectionTable.tableFooterView = footerView
    }
    
    private func clearTitleForBackBarButtonItem(){
        let barButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = barButtonItem
    }
    
    override func refreshData() {
        footerView?.reset()
        self.waitingIndicator.startAnimating()
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
        self.waitingIndicator.hidden = false
        self.waitingIndicator.startAnimating()
        request.userLocation = location
        loadData { (success) -> Void in
            if !success {
                self.noNetworkDefaultView.show()
            }
        }
    }
    
    override func loadData(refreshHandler: ((success: Bool) -> Void)?) {
        
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
                        self.selectedCollectionTable.hidden = false
                    }
                    
                    self.selectedCollectionTable.reloadData()
                    
                    if refreshHandler != nil {
                        refreshHandler!(success: true)
                    }
                    
                }
                self.isLoadingMore = false
                self.refreshControl.endRefreshing()
                self.waitingIndicator.stopAnimating()
                self.waitingIndicator.hidden = true
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return SelectedCollectionTableViewCell.height
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return selectedCollections.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if selectedCollections.isEmpty {
            return 0
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: SelectedCollectionTableViewCell? = tableView.dequeueReusableCellWithIdentifier("SelectedCollectionCell") as? SelectedCollectionTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "SelectedCollectionCell", bundle: nil), forCellReuseIdentifier: "SelectedCollectionCell")
            cell = tableView.dequeueReusableCellWithIdentifier("SelectedCollectionCell") as? SelectedCollectionTableViewCell
        }
        cell?.setUp(selectedCollection: selectedCollections[indexPath.row])
        return cell!
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showRestaurantCollectionMembers", sender: selectedCollections[indexPath.row])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRestaurantCollectionMembers" {
            let restaurantCollectionMembersController: RestaurantCollectionMembersViewController = segue.destinationViewController as! RestaurantCollectionMembersViewController
            restaurantCollectionMembersController.selectedCollection = (sender as! SelectedCollection)
        }
    }
    
    @objc private func reloadTable() {
        self.selectedCollectionTable.reloadData()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
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


}
