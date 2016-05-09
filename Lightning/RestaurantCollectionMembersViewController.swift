//
//  ListMemberViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 10/15/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit
import Kingfisher

class RestaurantCollectionMembersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate{
    
    var selectedCollection: SelectedCollection?
    
    var members: [Restaurant] = [Restaurant]()
    
    var headerView: UIView!
    let kTableHeaderHeight: CGFloat = 300.0
    
    @IBOutlet weak var navBarTitle: UILabel!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var waitingView: UIView!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var memberTable: UITableView!
    @IBOutlet weak var collectionTitle: UILabel!
    
    var ratingAndFavoriteExecutor: RatingAndBookmarkExecutor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTableData()
        ratingAndFavoriteExecutor = RatingAndBookmarkExecutor(baseVC: self)
        self.setUpHeaderView()
        //self.configureHeaderView()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let selectedCellIndexPath : NSIndexPath? = self.memberTable.indexPathForSelectedRow
        if selectedCellIndexPath != nil {
            self.memberTable.deselectRowAtIndexPath(selectedCellIndexPath!, animated: false)
        }
        self.configureHeaderView()
        self.navigationController?.navigationBar.translucent = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setUpHeaderView(){
        headerImage.kf_setImageWithURL(NSURL(string: (selectedCollection?.cellImage?.original)!)!, placeholderImage: nil, optionsInfo: [.Transition(ImageTransition.Fade(0.5))])
        self.collectionTitle.text = selectedCollection?.title
        self.navBarTitle.text = selectedCollection?.title
        self.navBarTitle.hidden = true
    }
    
    private func configureHeaderView(){
        if headerView == nil {
            headerView = self.memberTable.tableHeaderView
            self.memberTable.tableHeaderView = nil
            self.memberTable.addSubview(headerView)
        }
        self.memberTable.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        //self.memberTable.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)
        updateHeaderView()
    }
    
    private func updateHeaderView(){
        var headerRect = CGRect(x: 0, y: -kTableHeaderHeight, width: self.view.frame.width, height: kTableHeaderHeight)
        if memberTable.contentOffset.y < -kTableHeaderHeight {
            headerRect.origin.y = self.memberTable.contentOffset.y
            headerRect.size.height = -self.memberTable.contentOffset.y
        }
        headerView.frame = headerRect
        if self.memberTable.contentOffset.y > 0 {
            self.navBarTitle.hidden = false
            self.navigationController?.navigationBar.translucent = false
        } else{
            self.navBarTitle.hidden = true
            self.navigationController?.navigationBar.translucent = true
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    func loadTableData() {
        self.waitingView.hidden = false
        self.activityIndicator.startAnimating()
        if selectedCollection?.id != nil {
            let request : GetRestaurantCollectionMembersRequest = GetRestaurantCollectionMembersRequest(id: (selectedCollection?.id!)!)
            DataAccessor(serviceConfiguration: ParseConfiguration()).getRestaurantCollectionMembersById(request, responseHandler: { (response) -> Void in
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    if response != nil && !response!.results.isEmpty {
                        self.members.removeAll()
                        self.members += response!.results
                        self.members.sortInPlace {
                            (r1, r2) -> Bool in
                            return ScoreComputer.getScoreNum(positive: r1.likeCount, negative: r1.dislikeCount, neutral: r1.neutralCount) > ScoreComputer.getScoreNum(positive: r2.likeCount, negative: r2.dislikeCount, neutral: r2.neutralCount)
                        }
                        self.memberTable.reloadData()
                        self.activityIndicator.stopAnimating()
                        self.waitingView.hidden = true
                        
                    }
                })
                
            })
            
        }
        
    }
    
    func refresh() {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.members.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: RestaurantCollectionMemberTableViewCell? = tableView.dequeueReusableCellWithIdentifier("restaurantCollectionMemberTableViewCell") as? RestaurantCollectionMemberTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "RestaurantCollectionMemberCell", bundle: nil), forCellReuseIdentifier: "restaurantCollectionMemberTableViewCell")
            cell = tableView.dequeueReusableCellWithIdentifier("restaurantCollectionMemberTableViewCell") as? RestaurantCollectionMemberTableViewCell
        }
        cell?.setUp(restaurant: self.members[indexPath.row], rank: indexPath.row + 1)
        
        return cell!
    }
    
    private func popupSigninAlert() {
        let alertview = JSSAlertView().show(self, title: "请登录", text: nil, buttonText: "我知道了")
        alertview.setTextTheme(.Dark)
    }
    
    @objc private func reloadTable() {
        self.memberTable.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return RestaurantCollectionMemberTableViewCell.height
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func addCandidate(){
        self.performSegueWithIdentifier("addCandidate", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let barButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = barButtonItem
        if segue.identifier == "addCandidate" {
            
        }
    }

}
