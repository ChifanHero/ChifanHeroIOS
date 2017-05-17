//
//  ListMemberViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 10/15/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit
import Kingfisher
import Flurry_iOS_SDK

class RestaurantCollectionMembersViewController: UITableViewController, ARNImageTransitionZoomable, ARNImageTransitionIdentifiable{
    
    var selectedCollection: SelectedCollection?
    
    var animateTransition = false
    weak var selectedImageView: UIImageView?
    var selectedRestaurantName: String?
    
    var likeCount: Int? {
        didSet {
            if likeLabel != nil {
                if let count = likeCount {
                    likeLabel.text = String(count)
                }
            }
        }
    }
    
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
    @IBOutlet weak var likeView: UIView!
    @IBOutlet weak var likeButton: DOFavoriteButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var favoriteView: UIView!
    @IBOutlet weak var favoriteButton: DOFavoriteButton!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var nominationView: UIView!
    @IBOutlet weak var nominationButton: DOFavoriteButton!
    
    
    var ratingAndFavoriteExecutor: RatingAndBookmarkExecutor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configActionButton()
        self.clearTitleForBackBarButtonItem()
        loadTableData()
        ratingAndFavoriteExecutor = RatingAndBookmarkExecutor(baseVC: self)
        self.setUpHeaderView()
        self.configureHeaderView()
        self.configureLikeView()
        self.configureFavoriteView()
        self.configureNominationView()
        
        likeCount = selectedCollection?.likeCount
        favoriteCount = selectedCollection?.userFavoriteCount
        // Do any additional setup after loading the view.
    }
    
    fileprivate func configActionButton() {
        self.view.layoutIfNeeded()
        likeButton.image = UIImage(named: "Chifanhero_Like")
        favoriteButton.image = UIImage(named: "Chifanhero_Favorite")
        nominationButton.image = UIImage(named: "Chifanhero_Nomination")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let selectedCellIndexPath : IndexPath? = self.tableView.indexPathForSelectedRow
        if selectedCellIndexPath != nil {
            self.tableView.deselectRow(at: selectedCellIndexPath!, animated: false)
        }
        self.animateTransition = false
        self.navigationController?.navigationBar.isTranslucent = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TrackingUtil.trackCollectionsMemberView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setUpHeaderView(){
        headerImage.kf.setImage(with: URL(string: (selectedCollection?.cellImage?.original)!)!, placeholder: nil, options: [.transition(ImageTransition.fade(0.5))])
        self.collectionTitle.text = selectedCollection?.title
    }
    
    fileprivate func configureHeaderView(){
        headerView = self.tableView.tableHeaderView
        self.tableView.tableHeaderView = nil
        self.tableView.addSubview(headerView)
        self.tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        self.tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)
        updateHeaderView()
    }
    
    fileprivate func updateHeaderView(){
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
    
    func configureLikeView(){
        likeView.layer.borderWidth = 1.0
        likeView.layer.borderColor = UIColor.white.cgColor
        likeView.layer.cornerRadius = 10.0
        likeButton.addTarget(self, action: #selector(RestaurantCollectionMembersViewController.likeButtonTapped(_:)), for: .touchUpInside)
        if let likeCount = selectedCollection?.likeCount {
            likeLabel.text = String(likeCount)
        }
    }
    
    func configureFavoriteView(){
        favoriteView.layer.borderWidth = 1.0
        favoriteView.layer.borderColor = UIColor.white.cgColor
        favoriteView.layer.cornerRadius = 10.0
        favoriteButton.addTarget(self, action: #selector(RestaurantCollectionMembersViewController.favoriteButtonTapped(_:)), for: .touchUpInside)
        if let favoriteCount = selectedCollection?.userFavoriteCount {
            favoriteLabel.text = String(favoriteCount)
        }
        if !UserContext.isValidUser() {
            favoriteButton.isSelected = false
        } else {
            let request = GetIsFavoriteRequest(type: FavoriteTypeEnum.selectedCollection, id: selectedCollection!.id!)
            DataAccessor(serviceConfiguration: ParseConfiguration()).getIsFavorite(request, responseHandler: { (response) -> Void in
                OperationQueue.main.addOperation({ () -> Void in
                    if response != nil && response?.result != nil {
                        self.favoriteButton.isSelected = (response?.result)!
                    }
                })
                
            })
        }
    }
    
    func configureNominationView(){
        nominationView.layer.borderWidth = 1.0
        nominationView.layer.borderColor = UIColor.white.cgColor
        nominationView.layer.cornerRadius = 10.0
        nominationButton.addTarget(self, action: #selector(RestaurantCollectionMembersViewController.nominationButtonTapped(_:)), for: .touchUpInside)
    }
    
    func likeButtonTapped(_ sender: DOFavoriteButton) {
        if sender.isSelected {
            // deselect
            sender.deselect()
        } else {
            // select with animation
            sender.select()
        }
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
            DataAccessor(serviceConfiguration: ParseConfiguration()).getRestaurantCollectionMembersById(request, responseHandler: { (response) -> Void in
                OperationQueue.main.addOperation({ () -> Void in
                    if response != nil && !response!.results.isEmpty {
                        self.members.removeAll()
                        self.members += response!.results
                        /*self.members.sort {
                            (r1, r2) -> Bool in
                            return ScoreComputer.getScoreNum(positive: r1.likeCount, negative: r1.dislikeCount, neutral: r1.neutralCount) > ScoreComputer.getScoreNum(positive: r2.likeCount, negative: r2.dislikeCount, neutral: r2.neutralCount)
                        }*/
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
        var cell: RestaurantCollectionMemberTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "restaurantCollectionMemberTableViewCell") as? RestaurantCollectionMemberTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "RestaurantCollectionMemberCell", bundle: nil), forCellReuseIdentifier: "restaurantCollectionMemberTableViewCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCollectionMemberTableViewCell") as? RestaurantCollectionMemberTableViewCell
        }
        cell?.setUp(restaurant: self.members[indexPath.row], rank: indexPath.row + 1)
        
        return cell!
    }
    
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
    
    @IBAction func handleLikeButton(_ sender: AnyObject) {
        if likeButton.isSelected == false {
            self.likeCount! += 1
            self.likeButton.isEnabled = false
        }
    }
    @IBAction func handleFavoriteButton(_ sender: AnyObject) {
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
        }
        
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

}