//
//  FirstViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 7/29/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var promotionsTable: UITableView!
    
    var promotions : [Promotion] = []
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if promotions.count == 0 {
            return 0
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print(promotions.count)
        print("start load cell")
        var restaurantCell : RestaurantTableViewCell? = tableView.dequeueReusableCellWithIdentifier("restaurantCell") as? RestaurantTableViewCell
        if restaurantCell == nil {
            print("start load nib")
            tableView.registerNib(UINib(nibName: "RestaurantCell", bundle: nil), forCellReuseIdentifier: "restaurantCell")
            restaurantCell = tableView.dequeueReusableCellWithIdentifier("restaurantCell") as? RestaurantTableViewCell
        }
        restaurantCell?.name = "韶山冲"
        restaurantCell?.address = "DSFSFSFSFSFS"
        restaurantCell?.imageURL = "http://files.parsetfss.com/c25308ff-6a43-40e0-a09a-2596427b692c/tfss-28c48a2f-70d1-42c4-83d0-4d57bb1b67e9-Shao%20mountain.jpeg"
        return restaurantCell!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("home view did load")
        let getPromotionsRequest = GetPromotionsRequest()
        getPromotionsRequest.limit = 10
        getPromotionsRequest.offset = 0
        DataAccessor(serviceConfiguration: ParseConfiguration()).getPromotions(getPromotionsRequest) { (response) -> Void in
            //
            self.promotions = (response?.results)!
            print("before reload data")
            dispatch_async(dispatch_get_main_queue(), {
                self.promotionsTable.reloadData()
            });
            Queue.MainQueue.perform({
                self.promotionsTable.reloadData()
            })
            print("after reload data")
        }

    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }

}

