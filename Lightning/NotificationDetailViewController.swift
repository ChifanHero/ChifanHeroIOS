//
//  MessageDetailTableViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 9/2/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit
import CoreData

class NotificationDetailViewController: UIViewController, NotificationSelectionDelegate {
    
    
    @IBOutlet weak var notificationDetailView: NotificationDetailView?
    
    var notification : NSManagedObject?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.notificationDetailView?.hidden = true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if self.notification != nil {
            let title = notification!.valueForKey("title") as! String
            let body = notification!.valueForKey("body") as! String
            self.notificationDetailView!.setUp(title, body: body)
            self.notificationDetailView!.hidden = false
        }
        
    }
    
    func notificationSelected(notification : NSManagedObject) {
        self.notification = notification
        if self.notificationDetailView != nil {
            let title = notification.valueForKey("title") as! String
            let body = notification.valueForKey("body") as! String
            self.notificationDetailView!.setUp(title, body: body)
            self.notificationDetailView!.hidden = false
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

