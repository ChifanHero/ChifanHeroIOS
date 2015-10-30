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
        self.refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl!)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        loadTableData()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }
    
    func loadTableData() {
        request = GetMessagesRequest()
        request?.limit = 10
        request?.offset = 0
        if request != nil {
            DataAccessor(serviceConfiguration: ParseConfiguration()).getMessages(request!) { (response) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    self.messages = (response?.results)!
                    self.refreshControl?.endRefreshing()
                    self.tableView.reloadData()
                });
            }
        }
    }
    
    func refresh(sender:AnyObject) {
        loadTableData()
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
        let message = messages[indexPath.row]
        cell!.title = message.title
        cell!.source = "系统消息"
        return cell!
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let messageSelected : Message = messages[indexPath.row]
        performSegueWithIdentifier("showMessage", sender: messageSelected)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMessage" {
            let messageDetalController : MessageDetailViewController = (segue.destinationViewController as! UINavigationController).topViewController as! MessageDetailViewController
            let message = sender as? Message
            messageDetalController.messageId = message!.id
            messageDetalController.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            messageDetalController.navigationItem.leftItemsSupplementBackButton = true
            if (message?.read != true) {
                var badgeValue : Int?
                if self.navigationController?.tabBarItem.badgeValue != nil {
                    badgeValue = Int((self.navigationController?.tabBarItem.badgeValue)!)!
                } else {
                    badgeValue = 0
                }
                badgeValue = badgeValue! - 1
                if badgeValue > 0 {
                    self.navigationController?.tabBarItem.badgeValue = String(badgeValue)
                } else {
                    self.navigationController?.tabBarItem.badgeValue = nil
                }
                
            }
            
        }
    }
    
    

}
