//
//  MessageDetailTableViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 9/2/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class MessageDetailViewController: UIViewController {
    
    
    @IBOutlet weak var messageDetailView: MessageDetailView!
    
    var messageId : String?
    private var message : Message?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        loadData()
    }
    
    func loadData() {
        if (messageId != nil) {
            let request : GetMessageByIdRequest = GetMessageByIdRequest(id: messageId!)
            DataAccessor(serviceConfiguration: ParseConfiguration()).getMessageById(request, responseHandler: { (response) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    self.message = response?.result
                    if (self.message != nil) {
                        self.messageDetailView.setUpMessageView(source: "系统消息", title: (self.message?.title)!, time: "2015-08-26 8:00 AM", greetings: (self.message?.greeting)!, body: (self.message?.body)!, signature: (self.message?.signature)!)
                    }
                });
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
