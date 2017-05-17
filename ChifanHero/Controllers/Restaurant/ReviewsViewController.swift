//
//  ReviewsViewController.swift
//  Lightning
//
//  Created by Shi Yan on 10/3/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu

class ReviewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var reviewsTable: UITableView!
    
    var reviews: [Review] = []
    
    var restaurantId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.layoutIfNeeded()
        configDropDownMenu()
        
        addBarButton()
        self.addImageForBackBarButtonItem()
        self.clearTitleForBackBarButtonItem()
        // Do any additional setup after loading the view.
        loadData(50, skip: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func configDropDownMenu() {
        let items = ["排序：按时间", "排序：默认"]
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: "排序：默认", items: items as [AnyObject])
        self.navigationItem.titleView = menuView
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
//            menuView
//            self.selectedCellLabel.text = "排序: \(items[indexPath])"
            if indexPath == 0 {
                self!.loadData(50, skip: 0)
            } else {
                
                self!.loadData(50, skip: 0)
            }
        }
    }
    
    fileprivate func loadData(_ limit: Int, skip: Int) {
        let getReviewsRequest: GetAllReviewsOfOneRestaurantRequest = GetAllReviewsOfOneRestaurantRequest()
        getReviewsRequest.limit = limit
        getReviewsRequest.skip = skip
        getReviewsRequest.restaurantId = self.restaurantId
        DataAccessor(serviceConfiguration: ParseConfiguration()).getReviews(getReviewsRequest) { (response) in
            if response != nil && response?.error == nil {
                if skip == 0 {
                    self.reviews.removeAll()
                }
                self.reviews.append(contentsOf: response!.results)
                self.reviewsTable.reloadData()
            } else {
                
            }
        }
    }
    
    fileprivate func addBarButton() {
        let addNewReviewButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(ReviewsViewController.addNewReview))
        self.navigationItem.rightBarButtonItem = addNewReviewButton
    }
    
    func addNewReview() {
        self.performSegue(withIdentifier: "writeReview", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: ReviewSnapshotTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "reviewSnapshotCell") as? ReviewSnapshotTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "ReviewSnapshotCell", bundle: nil), forCellReuseIdentifier: "reviewSnapshotCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "reviewSnapshotCell") as? ReviewSnapshotTableViewCell
        }
        let review = reviews[indexPath.row]
        cell?.review = review
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 166
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
//    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footerView = UIView()
//        footerView.backgroundColor = UIColor.groupTableViewBackgroundColor()
//        return footerView
//    }
//    
//    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 10
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell : UITableViewCell = tableView.cellForRow(at: indexPath)!
        showReview()
        cell.isSelected = false
    }
    
    func showReview() {
        performSegue(withIdentifier: "showReview", sender: nil)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
