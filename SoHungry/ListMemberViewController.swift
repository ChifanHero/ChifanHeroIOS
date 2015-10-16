//
//  ListMemberViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 10/15/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class ListMemberViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ListHeaderViewDelegate {
    
    var listId : String?
    
    var member : [Dish] = [Dish]()

    @IBOutlet weak var memberTable: UITableView!
    
    @IBOutlet weak var headerView: ListHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.delegate = self
        loadTableData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let selectedCellIndexPath : NSIndexPath? = self.memberTable.indexPathForSelectedRow
        if selectedCellIndexPath != nil {
            self.memberTable.deselectRowAtIndexPath(selectedCellIndexPath!, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadTableData() {
        if listId != nil {
            let request : GetListByIdRequest = GetListByIdRequest(id: listId!)
            DataAccessor(serviceConfiguration: ParseConfiguration()).getListById(request, responseHandler: { (response) -> Void in
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    if response != nil && response!.result != nil {
                        self.member += response!.result!.dishes
                        self.memberTable.reloadData()
                    }
                })
                
            })
            
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : DishTableViewCell? = tableView.dequeueReusableCellWithIdentifier("dishCell") as? DishTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "DishCell", bundle: nil), forCellReuseIdentifier: "dishCell")
            cell = tableView.dequeueReusableCellWithIdentifier("dishCell") as? DishTableViewCell
        }
        cell?.model = member[indexPath.section]
        return cell!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return member.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return DishTableViewCell.height
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 10
        }
    }
    
    func addCandidate(){
        self.performSegueWithIdentifier("addCandidate", sender: self)
    }

}
