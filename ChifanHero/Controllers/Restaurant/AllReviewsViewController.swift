//
//  AllReviewsViewController.swift
//  Lightning
//
//  Created by Shi Yan on 10/3/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu

class AllReviewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var reviewsTable: UITableView!
    
    var reviews: [Review] = []
    
    var reviewUserProfileImageContent: [UIImageView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configDropDownMenu()
        self.addBarButton()
        self.addImageForBackBarButtonItem()
        self.clearTitleForBackBarButtonItem()
        self.reviewsTable.register(UINib(nibName: "ReviewSnapshotCell", bundle: nil), forCellReuseIdentifier: "reviewSnapshotCell")
        self.reviewsTable.tableFooterView = UIView()
    }
    
    private func configDropDownMenu() {
        // TODO: Added in the future
        /*let items = ["排序：按时间", "排序：默认"]
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.view, title: "排序：默认", items: items as [AnyObject])
        self.navigationItem.titleView = menuView
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            
        }*/
    }
    
    private func addBarButton() {
        let button: UIButton! = ButtonUtil.barButtonWithTextAndBorder("我要点评", size: CGRect(x: 0, y: 0, width: 80, height: 26))
        button.addTarget(self, action: #selector(addNewReview), for: UIControlEvents.touchUpInside)
        let addNewReviewButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = addNewReviewButton
    }
    
    func addNewReview() {
        self.performSegue(withIdentifier: "writeReview", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ReviewSnapshotTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "reviewSnapshotCell") as! ReviewSnapshotTableViewCell
        let review = reviews[indexPath.row]
        cell.review = review
        cell.selectionStyle = .none
        if !self.reviewUserProfileImageContent.isEmpty {
            cell.profileImage = self.reviewUserProfileImageContent[indexPath.row]
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showReview(indexPath.row)
    }
    
    func showReview(_ index: Int) {
        performSegue(withIdentifier: "showReview", sender: index)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReview" {
            let reviewVC: ReviewDetailViewController = segue.destination as! ReviewDetailViewController
            reviewVC.review = self.reviews[(sender as! Int)]
            reviewVC.reviewUserProfileImage = self.reviewUserProfileImageContent[(sender as! Int)]
        }
    }
}
