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
    
    @IBAction func unwindToRecommendedDish(_ segue: UIStoryboardSegue) {}
    
    var restaurant: Restaurant!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.recommendedDishTableView.reloadData()
    }
    
    private func addBarButton() {
        let button: UIButton! = ButtonUtil.barButtonWithTextAndBorder("我要推荐", size: CGRect(x: 0, y: 0, width: 80, height: 26))
        button.addTarget(self, action: #selector(addNewRecommendation), for: UIControlEvents.touchUpInside)
        let addNewRecommendationButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = addNewRecommendationButton
    }
    
    func addNewRecommendation() {
        performSegue(withIdentifier: "nominateRecommendedDish", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurant.recommendedDishes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RecommendedDishTableViewCell! = recommendedDishTableView.dequeueReusableCell(withIdentifier: "recommendedDishCell") as? RecommendedDishTableViewCell
        cell.setUp(self.restaurant.recommendedDishes[indexPath.row])
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nominateRecommendedDish" {
            let recommendedDishNominationVC: RecommendedDishNominationViewController = segue.destination as! RecommendedDishNominationViewController
            recommendedDishNominationVC.restaurant = self.restaurant
        }
    }
}
