//
//  MessageDetailTableViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 9/2/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit
import CoreData
import Flurry_iOS_SDK

class NotificationDetailViewController: UIViewController {
    
    
    @IBOutlet weak var notificationDetailView: NotificationDetailView?
    
    var notification : NSManagedObject?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addImageForBackBarButtonItem()
        self.notificationDetailView?.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.notification != nil {
            let title = notification!.value(forKey: "title") as! String
            let body = notification!.value(forKey: "body") as! String
            self.notificationDetailView!.setUp(title, body: body)
            self.notificationDetailView!.isHidden = false
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TrackingUtil.trackNotificationContentView()
    }
    
    func notificationSelected(_ notification : NSManagedObject) {
        self.notification = notification
        if self.notificationDetailView != nil {
            let title = notification.value(forKey: "title") as! String
            let body = notification.value(forKey: "body") as! String
            self.notificationDetailView!.setUp(title, body: body)
            print(body)
            self.notificationDetailView!.isHidden = false
        }
        
    }
    
    func clear() {
        self.notificationDetailView?.isHidden = true
        self.notification = nil
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


