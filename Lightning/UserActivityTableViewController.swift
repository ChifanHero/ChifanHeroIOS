//
//  UserActivityTableViewController.swift
//  Lightning
//
//  Created by Zhang, Alex on 10/31/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class UserActivityTableViewController: UITableViewController {

    var userId: String! = "v44vNqdgbe"
    var userActivities: [UserActivity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userActivities.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UserActivityTableViewCell? = tableView.dequeueReusableCellWithIdentifier("userActivityCell") as? UserActivityTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "UserActivityCell", bundle: nil), forCellReuseIdentifier: "userActivityCell")
            cell = tableView.dequeueReusableCellWithIdentifier("userActivityCell") as? UserActivityTableViewCell
        }
        cell?.setUp(userActivities[indexPath.row])
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let cell = tableView.dequeueReusableCellWithIdentifier("userActivityCell") as? UserActivityTableViewCell {
            return cell.cellHeight
        }
        return UITableViewAutomaticDimension
    }
    
    private func loadData(){
        let request: GetUserActivitiesRequest = GetUserActivitiesRequest()
        request.userId = self.userId
        DataAccessor(serviceConfiguration: ParseConfiguration()).getUserActivities(request) { (response) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.userActivities.removeAll()
                for index in 0..<(response?.results)!.count {
                    self.userActivities.append((response?.results)![index])
                }
                self.tableView.reloadData()
            });
        }
    }

}
