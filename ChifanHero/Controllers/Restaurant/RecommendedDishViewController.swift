//
//  RecommendationsViewController.swift
//  Lightning
//
//  Created by Shi Yan on 10/10/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class RecommendedDishViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var recommendedDishTableView: UITableView!
    
    var recommendedDishes: [RecommendedDish]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recommendedDishTableView.delegate = self
        self.recommendedDishTableView.dataSource = self
        self.recommendedDishTableView.register(RecommendedDishTableViewCell.self, forCellReuseIdentifier: "recommendedDishCell")
        self.recommendedDishTableView.tableFooterView = UIView()
        self.addBarButton()
        self.addImageForBackBarButtonItem()
        self.clearTitleForBackBarButtonItem()
    }
    
    private func addBarButton() {
        let addNewRecommendationButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(RecommendedDishViewController.addNewRecommendation))
        self.navigationItem.rightBarButtonItem = addNewRecommendationButton
    }
    
    func addNewRecommendation() {
        performSegue(withIdentifier: "nominateRecommendedDish", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendedDishes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RecommendedDishTableViewCell! = recommendedDishTableView.dequeueReusableCell(withIdentifier: "recommendedDishCell") as? RecommendedDishTableViewCell
        cell.setUp(self.recommendedDishes?[indexPath.row].name ?? "")
        return cell
    }
}
