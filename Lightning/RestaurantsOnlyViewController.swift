//
//  RestaurantsTableViewController.swift
//  Lightning
//
//  Created by Shi Yan on 8/20/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import UIKit

class RestaurantsOnlyViewController: RefreshableViewController, UITableViewDataSource, UITableViewDelegate, ARNImageTransitionZoomable, ARNImageTransitionIdentifiable {
    
    @IBOutlet var restaurantsTable: UITableView!
    
    fileprivate var request: GetRestaurantsRequest = GetRestaurantsRequest()
    
    var animateTransition = false
    
    weak var selectedImageView: UIImageView?
    
    var selectedRestaurantName: String?
    
    var selectedRestaurantId: String?
    
    var restaurants: [Restaurant] = []
    
    var loadMoreIndicator : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    var footerView : LoadMoreFooterView?
    
    var ratingAndFavoriteExecutor: RatingAndBookmarkExecutor?
    
    var isLoadingMore = false
    
    var pullRefresher: UIRefreshControl!
    
    var loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    var isFromBookMark = false {
        didSet {
            if isFromBookMark == true {
                self.navigationItem.title = "我的餐厅"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addImageForBackBarButtonItem()
        self.clearTitleForBackBarButtonItem()
        self.configLoadingIndicator()
        self.configPullToRefresh()
        self.restaurantsTable.delegate = self
        self.restaurantsTable.dataSource = self
        self.restaurantsTable.isHidden = true
        setTableViewFooterView()
        firstLoadData()
        ratingAndFavoriteExecutor = RatingAndBookmarkExecutor(baseVC: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.animateTransition = false
        let selectedCellIndexPath : IndexPath? = self.restaurantsTable.indexPathForSelectedRow
        if selectedCellIndexPath != nil {
            self.restaurantsTable.deselectRow(at: selectedCellIndexPath!, animated: false)
        }
        //        setTabBarVisible(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TrackingUtil.trackRestaurantsView()
    }
    
    fileprivate func configPullToRefresh() {
        pullRefresher = UIRefreshControl()
        let attribute = [ NSForegroundColorAttributeName: UIColor.lightGray,
                          NSFontAttributeName: UIFont(name: "Arial", size: 14.0)!]
        pullRefresher.attributedTitle = NSAttributedString(string: "正在刷新", attributes: attribute)
        pullRefresher.tintColor = UIColor.lightGray
        pullRefresher.addTarget(self, action: #selector(RestaurantsOnlyViewController.refreshData), for: .valueChanged)
        self.restaurantsTable.insertSubview(pullRefresher, at: 0)
    }
    
    fileprivate func configLoadingIndicator() {
        loadingIndicator.color = UIColor.themeOrange()
        loadingIndicator.type = NVActivityIndicatorType.pacman
        loadingIndicator.center = (UIApplication.shared.keyWindow?.center)!
        self.view.addSubview(loadingIndicator)
    }
    
    func setTableViewFooterView() {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30)
        footerView = LoadMoreFooterView(frame: frame)
        footerView?.reset()
        self.restaurantsTable.tableFooterView = footerView
    }
    
    override func refreshData() {
        request.limit = 50
        request.skip = 0
        footerView?.reset()
        let location = userLocationManager.getLocationInUse()
        if (location == nil || location!.lat == nil || location!.lon == nil) {
            return
        }
        request.userLocation = location
        loadData(nil)
    }
    
    func firstLoadData() {
        request.limit = 50
        request.skip = 0
        footerView?.reset()
        let location = userLocationManager.getLocationInUse()
        if (location == nil || location!.lat == nil || location!.lon == nil) {
            return
        }
        loadingIndicator.startAnimation()
        request.userLocation = location
        loadData { (success) -> Void in
            if !success {
                self.noNetworkDefaultView.show()
            }
        }
    }
    
    func clearData() {
        self.restaurants.removeAll()
    }
    
    override func loadData(_ refreshHandler: ((_ success: Bool) -> Void)?) {
        
        if isFromBookMark == true {
            let request: GetFavoritesRequest = GetFavoritesRequest(type: FavoriteTypeEnum.restaurant)
            let location = userLocationManager.getLocationInUse()
            request.lat = location!.lat
            request.lon = location!.lon
            DataAccessor(serviceConfiguration: ParseConfiguration()).getFavorites(request) { (response) -> Void in
                OperationQueue.main.addOperation({ () -> Void in
                    self.clearData()
                    for index in 0..<(response?.results)!.count {
                        self.restaurants.append((response?.results)![index].restaurant!)
                    }
                    if self.restaurants.count > 0 && self.restaurantsTable.isHidden == true{
                        self.restaurantsTable.isHidden = false
                    }
                    self.loadingIndicator.stopAnimation()
                    self.footerView!.activityIndicator.stopAnimating()
                    self.restaurantsTable.reloadData()
                    self.pullRefresher.endRefreshing()
                });
            }
        } else {
            DataAccessor(serviceConfiguration: ParseConfiguration()).getRestaurants(request) { (response) -> Void in
                DispatchQueue.main.async(execute: {
                    if response == nil {
                        if refreshHandler != nil {
                            refreshHandler!(false)
                        }
                        self.pullRefresher.endRefreshing()
                        self.loadingIndicator.stopAnimation()
                        self.footerView!.activityIndicator.stopAnimating()
                    } else {
                        if self.request.skip == 0 {
                            self.clearData()
                        }
                        self.loadResults(response?.results)
                        if self.restaurants.count > 0 && self.restaurantsTable.isHidden == true{
                            self.restaurantsTable.isHidden = false
                        }
                        self.pullRefresher.endRefreshing()
                        self.loadingIndicator.stopAnimation()
                        self.footerView!.activityIndicator.stopAnimating()
                        self.restaurantsTable.reloadData()
                        if refreshHandler != nil {
                            refreshHandler!(true)
                        }
                        
                    }
                    self.isLoadingMore = false
                    
                });
            }
        }
    }
    
    func loadResults(_ results : [Restaurant]?) {
        if results != nil {
            for restaurant in results! {
                self.restaurants.append(restaurant)
            }
        }
    }
    
    
    @objc fileprivate func refresh(_ sender:AnyObject) {
        refreshData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return RestaurantTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return restaurants.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: RestaurantTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "restaurantCell") as? RestaurantTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "RestaurantCell", bundle: nil), forCellReuseIdentifier: "restaurantCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell") as? RestaurantTableViewCell
        }
        cell?.setUp(restaurant: restaurants[indexPath.row])
        return cell!
    }
    
    func needToLoadMore() -> Bool {
        if self.restaurants.count == (request.skip)! + (request.limit)! {
            return true
        } else {
            return false
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let restaurantSelected : Restaurant = restaurants[indexPath.row]
        let selectedCell : RestaurantTableViewCell = tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell
        self.selectedImageView = selectedCell.restaurantImageView
        selectedRestaurantName = selectedCell.nameLabel.text
        selectedRestaurantId = restaurantSelected.id
        self.animateTransition = true
        performSegue(withIdentifier: "showRestaurant", sender: restaurantSelected.id)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurant" {
            let restaurantController : RestaurantMainTableViewController = segue.destination as! RestaurantMainTableViewController
            restaurantController.restaurantId = sender as? String
            restaurantController.restaurantImage = self.selectedImageView?.image
            restaurantController.restaurantName = self.selectedRestaurantName
            restaurantController.parentVCName = self.getId()
        }
    }
    
    fileprivate func loadMore() {
        request.skip = (request.skip)! + (request.limit)!
        isLoadingMore = true
        footerView?.activityIndicator.startAnimating()
        loadData(nil)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let restaurant: Restaurant = self.restaurants[indexPath.row]
        let objectId = restaurant.id
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "删除", handler:{(action, indexpath) -> Void in
            
            let request = RemoveFavoriteRequest()
            request.type = "restaurant"
            request.objectId = objectId
            DataAccessor(serviceConfiguration: ParseConfiguration()).removeFavorite(request) { (response) -> Void in
                OperationQueue.main.addOperation({ () -> Void in
                    
                });
            }
            
            self.restaurantsTable.beginUpdates()
            self.restaurants.remove(at: indexPath.row)
            self.restaurantsTable.deleteRows(at: [indexPath], with: .fade)
            self.restaurantsTable.endUpdates()
            
        });
        
        return [deleteAction];
    }
    
    fileprivate func popupSigninAlert() {
        SCLAlertView().showWarning("请登录", subTitle: "登录享受更多便利")
    }
    
    // MARK: - ARNImageTransitionZoomable
    
    func createTransitionImageView() -> UIImageView {
        let imageView = UIImageView(image: self.selectedImageView!.image)
        imageView.contentMode = self.selectedImageView!.contentMode
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = false
        //        imageView.frame = self.selectedImageView!.convertRect(self.selectedImageView!.frame, toView: self.view)
        imageView.frame = PositionConverter.getViewAbsoluteFrame(self.selectedImageView!)
        
        return imageView
    }
    
    func presentationCompletionAction(_ completeTransition: Bool) {
        self.selectedImageView?.isHidden = true
    }
    
    func dismissalCompletionAction(_ completeTransition: Bool) {
        self.selectedImageView?.isHidden = false
    }
    
    func usingAnimatedTransition() -> Bool {
        return animateTransition
    }
    
    func getId() -> String {
        return "RestaurantsOnlyViewController"
    }
    
    func getDirectAncestorId() -> String {
        return ""
    }
    
}

