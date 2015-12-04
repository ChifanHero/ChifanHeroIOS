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
        if messageId != nil {
            loadData()
        } else {
            self.messageDetailView.hidden = true
            let blankView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
            let text = UILabel(frame: CGRectMake(blankView.frame.size.width / 2, blankView.frame.size.height/2, 50, 20))
            text.text = "未选中消息"
            blankView.addSubview(text)
            self.view.addSubview(blankView)
        }
        
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
