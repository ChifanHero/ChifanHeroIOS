//
//  NotificationViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 8/5/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit
import CoreData
import Flurry_iOS_SDK

class NotificationTableViewController: UITableViewController {
    
    var notifications = [NSManagedObject]()
    private var foregroundNotification: NSObjectProtocol!
    
    var detailNavigationController: UINavigationController?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NotificationTableViewController.notificationArrived), name:"NotificationArrived", object: nil)
        self.clearTitleForBackBarButtonItem()
        self.addImageForBackBarButtonItem()
        configurePullRefresh()
        addEditButton()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTableData()
        TrackingUtil.trackNotificationsView()
    }
    
    private func addEditButton() {
        let button: UIButton = UIButton.barButtonWithTextAndBorder("编辑", size: CGRectMake(0, 0, 80, 26))
        button.addTarget(self, action: #selector(NotificationTableViewController.edit), forControlEvents: UIControlEvents.TouchUpInside)
        let editButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    private func configurePullRefresh(){
    }
    
    @objc private func refresh(sender:AnyObject) {
        loadTableData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        clearTableViewSelection()
    }
    
    private func clearTableViewSelection() {
        let selectedCellIndexPath : NSIndexPath? = self.tableView.indexPathForSelectedRow
        if selectedCellIndexPath != nil {
            self.tableView.deselectRowAtIndexPath(selectedCellIndexPath!, animated: false)
        }
    }
    
    func notificationArrived() {
        loadTableData()
        recalculateBadgeValue()
    }
    
    func recalculateBadgeValue() {
        let badgeValue: Int = countNumberOfUnreadItems()
        if badgeValue > 0 {
            self.navigationController?.tabBarItem.badgeValue = "\(badgeValue)"
            UIApplication.sharedApplication().applicationIconBadgeNumber = badgeValue;
        } else {
            self.navigationController?.tabBarItem.badgeValue = nil
            UIApplication.sharedApplication().applicationIconBadgeNumber = 0;
        }
    }
    
    func loadTableData() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Notification")
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            notifications = results as! [NSManagedObject]
            self.tableView.reloadData()
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: NotificationTableViewCell? = tableView.dequeueReusableCellWithIdentifier("notificationCell") as? NotificationTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "notificationCell")
            cell = tableView.dequeueReusableCellWithIdentifier("notificationCell") as? NotificationTableViewCell
        }
        let notification = notifications[indexPath.row]
        let title = notification.valueForKey("title") as! String
        let body = notification.valueForKey("body") as! String
        let read = notification.valueForKey("read") as! Bool
        cell?.setUp(title: title, body: body, read: read)
        return cell!
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let notificationSelected : NSManagedObject = notifications[indexPath.row]
        markNotificationAsRead(notificationSelected)
        performSegueWithIdentifier("showNotificationDetail", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showNotificationDetail" {
            let controller: NotificationDetailViewController = segue.destinationViewController as! NotificationDetailViewController
            controller.notificationSelected(notifications[(sender as! NSIndexPath).row])
        }
    }
    
    private func markNotificationAsRead(notification : NSManagedObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        if (notification.valueForKey("read"))! as! Bool == false {
            notification.setValue(true, forKey: "read")
            do {
                try managedContext.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
            recalculateBadgeValue()
        }
    }
    
    private func countNumberOfUnreadItems() -> Int{
        var count = 0
        for item : NSManagedObject in self.notifications {
            let read : Bool = item.valueForKey("read") as! Bool
            if read == false {
                count += 1
            }
        }
        return count
    }
    
    func edit() {
        let button: UIButton = UIButton.barButtonWithTextAndBorder("完成", size: CGRectMake(0, 0, 80, 26))
        button.addTarget(self, action: #selector(NotificationTableViewController.done), forControlEvents: UIControlEvents.TouchUpInside)
        let doneButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = doneButton
        self.tableView.editing = true
        
    }
    
    func done() {
        let button: UIButton = UIButton.barButtonWithTextAndBorder("编辑", size: CGRectMake(0, 0, 80, 26))
        button.addTarget(self, action: #selector(NotificationTableViewController.edit), forControlEvents: UIControlEvents.TouchUpInside)
        let editButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = editButton
        self.tableView.editing = false
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let deletedObject : NSManagedObject = self.notifications.removeAtIndex(indexPath.row)
            clearDetailView()
            deleteFromCoreData(deletedObject)
            self.tableView.beginUpdates()
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
            self.tableView.endUpdates()
        }
    }
    
    func clearDetailView() {
//        if let detailViewController = self.delegate as? NotificationDetailViewController {
//            detailViewController.clear()
//        }
    }
    
    private func deleteFromCoreData(object : NSManagedObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        managedContext.deleteObject(object)
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
}
