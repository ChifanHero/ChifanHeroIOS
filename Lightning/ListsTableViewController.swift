//
//  ListsTableViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 8/20/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class ListsTableViewController: RefreshableViewController, UITableViewDelegate, UITableViewDataSource {
    
    var lists : [List] = []
    
    var request : GetListsRequest = GetListsRequest()
    
    var footerView : LoadMoreFooterView?
    
    var ratingAndBookmarkExecutor: RatingAndBookmarkExecutor?
    
    let refreshControl = Respinner(spinningView: UIImageView(image: UIImage(named: "Pull_Refresh")))
    
    let LIMIT = 50
    var offset = 0
    
    var isLoadingMore = false
    
    @IBOutlet weak var listTable: UITableView!
    @IBOutlet weak var waitingIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearTitleForBackBarButtonItem()
        setTableViewFooterView()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.listTable.insertSubview(refreshControl, atIndex: 0)
        ratingAndBookmarkExecutor = RatingAndBookmarkExecutor(baseVC: self)
        self.listTable.hidden = true
        waitingIndicator.hidden = true
        firstLoadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        let selectedCellIndexPath : NSIndexPath? = self.listTable.indexPathForSelectedRow
        if selectedCellIndexPath != nil {
            self.listTable.deselectRowAtIndexPath(selectedCellIndexPath!, animated: false)
        }
    }
    
    func setTableViewFooterView() {
        let frame = CGRectMake(0, 0, self.view.frame.size.width, 30)
        footerView = LoadMoreFooterView(frame: frame)
        footerView?.reset()
        self.listTable.tableFooterView = footerView
    }
    
    private func clearTitleForBackBarButtonItem(){
        let barButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = barButtonItem
    }
    
    override func refreshData() {
        request.limit = 50
        request.skip = 0
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
    
    func firstLoadData() {
        request.limit = 50
        request.skip = 0
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
        
        DataAccessor(serviceConfiguration: ParseConfiguration()).getLists(request) { (response) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if response == nil {
                    if refreshHandler != nil {
                        refreshHandler!(success: false)
                    }
                } else {
                    if response!.results.count > 0 {
                        if self.request.skip == 0 {
                            self.clearStates()
                        }
                        self.lists += response!.results
                        self.listTable.hidden = false
                        
                    }
                    
                    self.listTable.reloadData()
                    
                    if refreshHandler != nil {
                        refreshHandler!(success: true)
                    }
                    
                }
                self.isLoadingMore = true
                self.refreshControl.endRefreshing()
                self.waitingIndicator.stopAnimating()
                self.waitingIndicator.hidden = true
                self.footerView!.activityIndicator.stopAnimating()
            })
            
            
        }
    }
    
    func clearStates() {
        self.lists.removeAll()
    }

    
    func needToLoadMore() -> Bool {
        if self.lists.count == (request.skip)! + (request.limit)! {
            return true
        } else {
            return false
        }
        
    }
    
    func loadMore() {
        offset += LIMIT
        request.skip = offset
        isLoadingMore = true
        loadData(nil)
    }
    
    @objc private func refresh(sender:AnyObject) {
        refreshData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ListTableViewCell.height
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return lists.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if lists.isEmpty {
            return 0
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : ListTableViewCell? = tableView.dequeueReusableCellWithIdentifier("listCell") as? ListTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "listCell")
            cell = tableView.dequeueReusableCellWithIdentifier("listCell") as? ListTableViewCell
        }
        cell?.setUp(list: lists[indexPath.row])
        
        
        cell?.model = lists[indexPath.row]
        return cell!
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showList", sender: lists[indexPath.row])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showList" {
            let listMemberController : ListMemberViewController = segue.destinationViewController as! ListMemberViewController
            listMemberController.listId = (sender as! List).id
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) ->
        [UITableViewRowAction]? {
            
            var favoriteCount : Int = 0
            var likeCount : Int = 0
            var objectId = ""
            let list = self.lists[indexPath.row]
            if list.likeCount != nil {
                likeCount = list.likeCount!
            }
            if list.favoriteCount != nil {
                favoriteCount = list.favoriteCount!
            }
            if list.id != nil {
                objectId = list.id!
            }
            
            let addBookmarkAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: CellActionTitle.bookMark(favoriteCount), handler:{(action, indexpath) -> Void in
                if (!UserContext.isValidUser()) {
                    self.popupSigninAlert()
                } else {
                    favoriteCount++
                    if list.favoriteCount == nil {
                        list.favoriteCount = 1
                    } else {
                        list.favoriteCount!++
                    }
                    self.listTable.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView(CellActionTitle.bookMark(favoriteCount), index: 0)
                    self.addToFavorites(indexPath)
                }
                self.dismissActionViewWithDelay()
                
            });
            addBookmarkAction.backgroundColor = LightningColor.bookMarkGreenLarge()
            
            let likeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: CellActionTitle.positive(likeCount), handler:{(action, indexpath) -> Void in
                if (UserContext.isRatingTooFrequent(objectId)) {
                    JSSAlertView().warning(self, title: "评价太频繁")
                } else {
                    likeCount++
                    if list.likeCount == nil {
                        list.likeCount = 1
                    } else {
                        list.likeCount!++
                    }
                    self.listTable.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView(CellActionTitle.positive(likeCount), index: 3)
                    
                    self.rateList(indexPath, ratingType: RatingTypeEnum.like)
                }
                self.dismissActionViewWithDelay()
            });
            likeAction.backgroundColor = LightningColor.themeRedLarge()
            return [addBookmarkAction, likeAction];
    }
    
    private func addToFavorites(indexPath: NSIndexPath){
        
        let list = self.lists[indexPath.row]
        ratingAndBookmarkExecutor?.addToFavorites("list", objectId: list.id!, failureHandler: { (objectId) -> Void in
            if list.favoriteCount != nil {
                list.favoriteCount!--
            }
        })
    }
    
    private func rateList(indexPath: NSIndexPath, ratingType: RatingTypeEnum){
        let type: String = "list"
        let list = self.lists[indexPath.row]
        let objectId = list.id
        
        if ratingType == RatingTypeEnum.like {
            ratingAndBookmarkExecutor?.like(type, objectId: objectId!, failureHandler: { (objectId) -> Void in
                if list.likeCount != nil {
                    list.likeCount!--
                }
            })
        }
    }
    
    private func popupSigninAlert() {
        let alertview = JSSAlertView().show(self, title: "请登录", text: nil, buttonText: "我知道了")
        alertview.setTextTheme(.Dark)
    }
    
    private func dismissActionViewWithDelay() {
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("dismissActionView"), userInfo: nil, repeats: false)
    }
    
    @objc private func dismissActionView() {
        self.listTable.setEditing(false, animated: true)
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("reloadTable"), userInfo: nil, repeats: false)
    }
    
    @objc private func reloadTable() {
        self.listTable.reloadData()
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
