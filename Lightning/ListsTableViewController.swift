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
    
    let LIMIT = 50
    var offset = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var waitingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var resultsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        resultsTableView.hidden = true
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
    
    func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        // if last section, add activity indicator
        if section == lists.count - 1 {
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
        return 50
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return lists.count
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == lists.count - 1 {
            return 30
        } else {
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : ListTableViewCell? = tableView.dequeueReusableCellWithIdentifier("listCell") as? ListTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "listCell")
            cell = tableView.dequeueReusableCellWithIdentifier("listCell") as? ListTableViewCell
        }
        cell?.model = lists[indexPath.section]
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showList", sender: lists[indexPath.section])
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 10
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showList" {
            let listMemberController : ListMemberViewController = segue.destinationViewController as! ListMemberViewController
            listMemberController.listId = (sender as! List).id
        }
    }

}
