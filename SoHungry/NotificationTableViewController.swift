//
//  NotificationViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 8/5/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class NotificationTableViewController: UITableViewController {
    
    var request : GetMessagesRequest?
    
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("did load")
        loadTableData()
    }
    
    func loadTableData() {
        request = GetMessagesRequest()
        request?.limit = 10
        request?.offset = 0
        if request != nil {
            DataAccessor(serviceConfiguration: ParseConfiguration()).getMessages(request!) { (response) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    self.messages = (response?.results)!
                    self.tableView.reloadData()
                });
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return MessageTableViewCell.height
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : MessageTableViewCell? = tableView.dequeueReusableCellWithIdentifier("messageCell") as? MessageTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "messageCell")
            cell = tableView.dequeueReusableCellWithIdentifier("messageCell") as? MessageTableViewCell
        }
        return cell!
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let messageCell : MessageTableViewCell = cell as! MessageTableViewCell
        let message = messages[indexPath.row]
        messageCell.title = message.title
        messageCell.source = "系统消息"
    }
    
    

}
