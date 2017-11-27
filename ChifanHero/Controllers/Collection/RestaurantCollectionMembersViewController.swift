//
//  RestaurantCollectionMembersViewController.swift
//  ChifanHero
//
//  Created by Shi Yan on 10/15/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit
import Kingfisher
import Flurry_iOS_SDK
import BTNavigationDropdownMenu

class RestaurantCollectionMembersViewController: UITableViewController, ARNImageTransitionZoomable, ARNImageTransitionIdentifiable{
    
    var selectedCollection: SelectedCollection!
    
    var animateTransition = false
    weak var selectedImageView: UIImageView!
    var selectedRestaurantName: String!
    var lastUsedLocation: Location?
    
    private var sortOrder: SortOrder = .RATING
    
    var favoriteCount: Int? {
        didSet {
            if favoriteLabel != nil {
                if let count = favoriteCount {
                    favoriteLabel.text = String(count)
                }
            }
        }
    }
    
    var members: [Restaurant] = [Restaurant]()
    
    var headerView: UIView!
    let kTableHeaderHeight: CGFloat = 300.0
    
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var collectionTitle: UILabel!
    @IBOutlet weak var favoriteView: UIView!
    @IBOutlet weak var favoriteButton: DOFavoriteButton!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var nominationView: UIView!
    @IBOutlet weak var nominationButton: DOFavoriteButton!
    
    
    var ratingAndFavoriteExecutor: RatingAndBookmarkExecutor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configActionButton()
        self.clearTitleForBackBarButtonItem()
        loadTableData()
        ratingAndFavoriteExecutor = RatingAndBookmarkExecutor(baseVC: self)
        self.setUpHeaderView()
        self.configureHeaderView()
        self.configureFavoriteView()
        self.configureNominationView()
        self.configDropDownMenu()
        self.tableView.register(UINib(nibName: "RestaurantCollectionMemberCell", bundle: nil), forCellReuseIdentifier: "restaurantCollectionMemberTableViewCell")
        
        favoriteCount = selectedCollection?.userFavoriteCount
        // Do any additional setup after loading the view.
    }
    
    private func configDropDownMenu() {
        if !userLocationManager.usingNotAutoDetectedLocation() {
            let items = ["排序：按评分", "排序：按距离"]
            let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, title: "排序：按评分", items: items as [AnyObject])
            self.navigationItem.titleView = menuView
            menuView.cellSelectionColor = UIColor.themeOrange()
            menuView.selectedCellTextLabelColor = UIColor.white
            menuView.animationDuration = 0.2
            menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
                if indexPath == 0 {
                    self?.sortOrder = RestaurantCollectionMembersViewController.SortOrder.RATING
                } else {
                    self?.sortOrder = RestaurantCollectionMembersViewController.SortOrder.DISTANCE
                }
                self?.sort()
//                self.tableView.visibleCells.forEach { (cell) in
//                    UIView.animate(withDuration: 2.0, animations: {
//                        cell.contentView.alpha = 0
//                    })
//                }
                UIView.animate(withDuration: 0.5, animations: {
                    self?.tableView.visibleCells.forEach({ (cell) in
                        cell.contentView.alpha = 0
                    })
                }, completion: { (completed) in
                    self?.tableView.reloadData()
                })
                
            }
        }
    }
    
    private func sort() {
        //Parameter areInIncreasingOrder: A predicate that returns `true` if its
        //first argument should be ordered before its second argument; otherwise,`false`.
        members.sort { (restaurant1, restaurant2) -> Bool in
            if self.sortOrder == RestaurantCollectionMembersViewController.SortOrder.RATING {
                if (restaurant1.rating == nil) {
                    return false
                } else if (restaurant2.rating == nil) {
                    return true
                } else {
                    return restaurant1.rating! > restaurant2.rating!
                }
            } else {
                if (restaurant1.distance?.value == nil) {
                    return false
                } else if (restaurant2.distance?.value == nil) {
                    return true
                } else {
                    return restaurant1.distance!.value! < restaurant2.distance!.value!
                }
            }
            return false
        }
    }
    
    private func configActionButton() {
        self.view.layoutIfNeeded()
        favoriteButton.image = UIImage(named: "Chifanhero_Favorite")
        nominationButton.image = UIImage(named: "Chifanhero_Nomination")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.animateTransition = false
//        self.setNavigationBarTranslucent(To: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TrackingUtil.trackCollectionsMemberView()
    }
    
    private func setUpHeaderView(){
        let url = URL(string: selectedCollection.cellImage?.original ?? "")
        headerImage.kf.setImage(with: url, placeholder: DefaultImageGenerator.generateRestaurantDefaultImage(), options: [.transition(ImageTransition.fade(0.5))])
        self.collectionTitle.text = selectedCollection?.title
    }
    
    private func configureHeaderView(){
        headerView = self.tableView.tableHeaderView
        self.tableView.tableHeaderView = nil
        self.tableView.addSubview(headerView)
        self.tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        self.tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)
        updateHeaderView()
    }
    
    private func updateHeaderView(){
        var headerRect = CGRect(x: 0, y: -kTableHeaderHeight, width: self.tableView.bounds.width, height: kTableHeaderHeight)
        if tableView.contentOffset.y < -kTableHeaderHeight {
            headerRect.origin.y = self.tableView.contentOffset.y
            headerRect.size.height = -self.tableView.contentOffset.y
        }
        headerView.frame = headerRect
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    func configureFavoriteView(){
        // Remove this feature for now
        favoriteView.isHidden = true
        favoriteView.layer.borderWidth = 1.0
        favoriteView.layer.borderColor = UIColor.white.cgColor
        favoriteView.layer.cornerRadius = 10.0
        favoriteButton.addTarget(self, action: #selector(RestaurantCollectionMembersViewController.favoriteButtonTapped(_:)), for: .touchUpInside)
        if let favoriteCount = selectedCollection?.userFavoriteCount {
            favoriteLabel.text = String(favoriteCount)
        }
        /*
        if !UserContext.isValidUser() {
            favoriteButton.isSelected = false
        } else {
            
        }
        */
    }
    
    func configureNominationView(){
        // Remove this feature for now
        nominationView.isHidden = true
        nominationView.layer.borderWidth = 1.0
        nominationView.layer.borderColor = UIColor.white.cgColor
        nominationView.layer.cornerRadius = 10.0
        nominationButton.addTarget(self, action: #selector(RestaurantCollectionMembersViewController.nominationButtonTapped(_:)), for: .touchUpInside)
    }
    
    func favoriteButtonTapped(_ sender: DOFavoriteButton) {
        if sender.isSelected {
            // deselect
            sender.deselect()
        } else {
            // select with animation
            sender.select()
        }
    }
    
    func nominationButtonTapped(_ sender: DOFavoriteButton) {
        if sender.isSelected {
            // deselect
            sender.deselect()
        } else {
            // select with animation
            sender.select()
        }
    }
    
    func loadTableData() {
        if selectedCollection?.id != nil {
            let request: GetRestaurantCollectionMembersRequest = GetRestaurantCollectionMembersRequest(id: (selectedCollection?.id!)!)
            let location = userLocationManager.getLocationInUse()
            request.userLocation = userLocationManager.getLocationInUse()
            DataAccessor(serviceConfiguration: ParseConfiguration()).getRestaurantCollectionMembersById(request, responseHandler: { (response) -> Void in
                OperationQueue.main.addOperation({ () -> Void in
                    if response != nil && !response!.results.isEmpty {
                        self.members.removeAll()
                        self.members += response!.results
                        self.sort()
                        self.tableView.reloadData()
                    }
                })
                
            })
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.members.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RestaurantCollectionMemberTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "restaurantCollectionMemberTableViewCell") as! RestaurantCollectionMemberTableViewCell
        cell.setUp(restaurant: self.members[indexPath.row], rank: indexPath.row + 1)
        cell.selectionStyle = .none
        UIView.animate(withDuration: 1.5) {
            cell.contentView.alpha = 1
        }
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if cell.contentView.alpha == 0 {
//            UIView.animate(withDuration: 1.0, animations: {
//                cell.contentView.alpha = 1.0
//            })
//        }
//
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let restaurantSelected: Restaurant = members[indexPath.row]
        let selectedCell: RestaurantCollectionMemberTableViewCell = tableView.cellForRow(at: indexPath) as! RestaurantCollectionMemberTableViewCell
        self.selectedImageView = selectedCell.restaurantImage
        self.selectedRestaurantName = selectedCell.restaurantName.text
        self.animateTransition = true
        showRestaurant(restaurantSelected.id!, restaurant: restaurantSelected)
    }
    
    func showRestaurant(_ id: String, restaurant: Restaurant) {
        self.animateTransition = true
        let storyboard = UIStoryboard(name: "Restaurant", bundle: nil)
        let restaurantController = storyboard.instantiateViewController(withIdentifier: "RestaurantMainTableViewController") as! RestaurantMainTableViewController
        restaurantController.restaurantImage = self.selectedImageView?.image
        restaurantController.restaurantId = id
        restaurantController.currentLocation = self.lastUsedLocation
        restaurantController.parentVCName = self.getId()
        self.navigationController?.pushViewController(restaurantController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurant" {
            let controller: RestaurantMainTableViewController = segue.destination as! RestaurantMainTableViewController
            controller.restaurantId = sender as? String
            controller.restaurantImage = self.selectedImageView?.image
        } else if segue.identifier == "showNomination" {
            let controller: RestaurantNominationViewController = segue.destination as! RestaurantNominationViewController
            controller.selectedCollection = sender as? SelectedCollection
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return RestaurantCollectionMemberTableViewCell.height
    }
    
    @IBAction func handleFavoriteButton(_ sender: AnyObject) {
        AlertUtil.showAlertView(buttonText: "我知道了", infoTitle: "友情提示", infoSubTitle: "收藏功能即将开通", target: self, buttonAction: #selector(dismissAlert))
        
        // TODO: Add favorite in the future
        /*
        if self.favoriteButton.isSelected == false {
            if !UserContext.isValidUser() {
                SCLAlertView().showWarning("请登录", subTitle: "登录享受更多便利")
                favoriteButton.isSelected = true
            } else {
                self.favoriteCount! += 1
                ratingAndFavoriteExecutor?.addToFavorites("selected_collection", objectId: selectedCollection!.id!, failureHandler: { (objectId) -> Void in
                    if self.selectedCollection?.userFavoriteCount != nil {
                        self.selectedCollection?.userFavoriteCount! -= 1
                    }
                })
            }
        } else {
            self.favoriteCount! -= 1
            ratingAndFavoriteExecutor?.removeFavorite("selected_collection", objectId: selectedCollection!.id!, successHandler: { () -> Void in
                
            })
        }*/
        
    }
    
    func dismissAlert() {
        
    }
    
    @IBAction func handleNominationButton(_ sender: AnyObject) {
        performSegue(withIdentifier: "showNomination", sender: selectedCollection)
    }
    
    @IBAction func unwindToCollectionMember(_ segue: UIStoryboardSegue) {}
    
    // MARK: - ARNImageTransitionZoomable
    
    func createTransitionImageView() -> UIImageView {
        let imageView = UIImageView(image: self.selectedImageView!.image)
        imageView.contentMode = self.selectedImageView!.contentMode
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = false
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
        return "RestaurantsCollectionMemberController"
    }
    
    func getDirectAncestorId() -> String {
        return "SelectedCollectionTableViewController"
    }
    
    private enum SortOrder {
        case RATING
        case DISTANCE
    }

}
