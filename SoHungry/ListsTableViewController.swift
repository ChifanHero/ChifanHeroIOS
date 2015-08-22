//
//  ListsTableViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 8/20/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class ListsTableViewController: UITableViewController {
    
    var lists : [List] = []
    
    var request : GetListsRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTableData()
    }
    
    func loadTableData() {
        if request != nil {
            DataAccessor(serviceConfiguration: ParseConfiguration()).getLists(request!) { (response) -> Void in
                self.lists = (response?.results)!
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                });
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        return headerView
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return lists.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : ListTableViewCell? = tableView.dequeueReusableCellWithIdentifier("listCell") as? ListTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "listCell")
            cell = tableView.dequeueReusableCellWithIdentifier("listCell") as? ListTableViewCell
        }
        return cell!
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let restaurantCell : ListTableViewCell = cell as! ListTableViewCell
        restaurantCell.model = lists[indexPath.section]
    }

}
