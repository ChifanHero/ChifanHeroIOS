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
    
    fileprivate func addBarButton() {
        let addNewRecommendationButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(RecommendationsViewController.addNewRecommendation))
        self.navigationItem.rightBarButtonItem = addNewRecommendationButton
    }
    
    func addNewRecommendation() {
        performSegue(withIdentifier: "createRecommendation", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = UIColor.groupTableViewBackground
        return footer
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: RecommendationTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "recommendationCell") as? RecommendationTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "RecommendationCell", bundle: nil), forCellReuseIdentifier: "recommendationCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "recommendationCell") as? RecommendationTableViewCell
        }
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


}
