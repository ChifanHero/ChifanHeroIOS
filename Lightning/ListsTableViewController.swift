//
//  ListsTableViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 8/20/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class ListsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var lists : [List] = []
    
    var request : GetListsRequest?
    
    let footerView : LoadMoreFooterView = LoadMoreFooterView()
    
    var ratingAndBookmarkExecutor: RatingAndBookmarkExecutor?
    
    let LIMIT = 50
    var offset = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var waitingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var resultsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.insertSubview(self.refreshControl, atIndex: 0)
        resultsTableView.hidden = true
        ratingAndBookmarkExecutor = RatingAndBookmarkExecutor(baseVC: self)
        loadTableData()
    }
    
    override func viewWillAppear(animated: Bool) {
        let selectedCellIndexPath : NSIndexPath? = self.tableView.indexPathForSelectedRow
        if selectedCellIndexPath != nil {
            self.tableView.deselectRowAtIndexPath(selectedCellIndexPath!, animated: false)
        }
    }
    
    func loadTableData() {
        if request != nil {
            self.waitingIndicator.hidden = false
            self.waitingIndicator.startAnimating()
            DataAccessor(serviceConfiguration: ParseConfiguration()).getLists(request!) { (response) -> Void in
//                self.lists = (response?.results)!
                if response?.results != nil {
                    self.lists += response!.results
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.refreshControl.endRefreshing()
                    self.resultsTableView.hidden = false
                    self.waitingIndicator.stopAnimating()
                    self.waitingIndicator.hidden = true
                    self.tableView.reloadData()
                });
            }
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == lists.count - 1 {
            footerView.activityIndicator.startAnimating()
            loadMore()
        }
    }
    
    func loadMore() {
        if lists.count == offset + LIMIT {
            offset += LIMIT
            request?.offset = offset
            loadTableData()
        } else {
            footerView.activityIndicator.stopAnimating()
            footerView.activityIndicator.hidden = true
        }
        
    }
    
    func refresh(sender:AnyObject) {
        lists.removeAll()
        loadTableData()
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
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : ListTableViewCell? = tableView.dequeueReusableCellWithIdentifier("listCell") as? ListTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "listCell")
            cell = tableView.dequeueReusableCellWithIdentifier("listCell") as? ListTableViewCell
        }
        cell?.model = lists[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showList", sender: lists[indexPath.row])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let barButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = barButtonItem
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
            
            let addBookmarkAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "收藏\n\(favoriteCount)", handler:{(action, indexpath) -> Void in
                if (!UserContext.isValidUser()) {
                    self.popupSigninAlert()
                } else {
                    favoriteCount++
                    if list.favoriteCount == nil {
                        list.favoriteCount = 1
                    } else {
                        list.favoriteCount!++
                    }
                    self.tableView.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView("收藏\n\(favoriteCount)", index: 0)
                    self.addToFavorites(indexPath)
                }
                self.dismissActionViewWithDelay()
                
            });
            addBookmarkAction.backgroundColor = UIColor(red: 0, green: 0.749, blue: 1, alpha: 1.0);
            
            let likeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "喜欢\n\(likeCount)", handler:{(action, indexpath) -> Void in
                if (UserContext.isRatingTooFrequent(objectId)) {
                    JSSAlertView().warning(self, title: "评价太频繁")
                } else {
                    likeCount++
                    if list.likeCount == nil {
                        list.likeCount = 1
                    } else {
                        list.likeCount!++
                    }
                    self.tableView.cellForRowAtIndexPath(indexPath)?.changeTitleForActionView("喜欢\n\(likeCount)", index: 3)
                    
                    self.rateList(indexPath, ratingType: RatingTypeEnum.like)
                }
                self.dismissActionViewWithDelay()
            });
            likeAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
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
        self.tableView.setEditing(false, animated: true)
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("reloadTable"), userInfo: nil, repeats: false)
    }


}
