//
//  RecommendationsViewController.swift
//  Lightning
//
//  Created by Shi Yan on 10/10/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class RecommendationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        addBarButton()
        self.addImageForBackBarButtonItem()
        self.clearTitleForBackBarButtonItem()

        // Do any additional setup after loading the view.
    }
    
    private func addBarButton() {
        let addNewRecommendationButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(RecommendationsViewController.addNewRecommendation))
        self.navigationItem.rightBarButtonItem = addNewRecommendationButton
    }
    
    func addNewRecommendation() {
        performSegueWithIdentifier("createRecommendation", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = UIColor.groupTableViewBackgroundColor()
        return footer
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: RecommendationTableViewCell? = tableView.dequeueReusableCellWithIdentifier("recommendationCell") as? RecommendationTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "RecommendationCell", bundle: nil), forCellReuseIdentifier: "recommendationCell")
            cell = tableView.dequeueReusableCellWithIdentifier("recommendationCell") as? RecommendationTableViewCell
        }
        return cell!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }


}
