//
//  RestaurantMainTableViewController.swift
//  ChifanHero
//
//  Created by Shi Yan on 8/15/16.
//  Copyright © 2016 ChifanHero. All rights reserved.
//

import UIKit
import MapKit
import Kingfisher
import SKPhotoBrowser

class RestaurantMainTableViewController: UITableViewController, ImagePickerDelegate, ARNImageTransitionZoomable, ARNImageTransitionIdentifiable, SKPhotoBrowserDelegate, RatingStarCellDelegate, RestaurantInfoSectionDelegate, RestaurantReviewSectionDelegate, RestaurantPhotoSectionDelegate, RestaurantRecommendedDishDelegate {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var infoSectionRootView: UIView!
    @IBOutlet weak var photoSectionRootView: UIView!
    @IBOutlet weak var reviewSectionRootView: UIView!
    @IBOutlet weak var recommendedDishSectionRootView: UIView!
    
    var infoSectionView: RestaurantInfoSectionView!
    var photoSectionView: RestaurantPhotoSectionView!
    var reviewSectionView: RestaurantReviewSectionView!
    var recommendedDishSectionView: RestaurantRecommendedDishSectionView!
    
    var localSearchResponse: MKLocalSearchResponse!
    
    var restaurantId: String? {
        didSet {
            request = GetRestaurantByIdRequest(id: restaurantId!)
        }
    }
    
    var userRating: Int = 0
    
    var uploadingAlertView : SCLAlertView?
    
    var request: GetRestaurantByIdRequest?
    
    var restaurant: Restaurant? {
        didSet {
            self.scoreLabel.text = String(format:"%.1f", self.restaurant?.rating ?? 0)
            self.scoreLabel.backgroundColor = ScoreComputer.getScoreColor(self.restaurant?.rating ?? 0)
            self.scoreLabel.alpha = 1
            self.infoSectionView.restaurant = self.restaurant
            self.reviewSectionView.reviews = self.restaurant?.reviewInfo?.reviews
            self.loadImagePool(self.restaurant!.photoInfo!.photos)
            self.downloadReviewUserProfileImages()
            self.recommendedDishSectionView.restaurant = self.restaurant
        }
    }
    
    var imagePool: [Picture] = [] {
        didSet {
            self.photoSectionView.imagePool = self.imagePool
        }
    }
    
    var imagePoolContent: [UIImageView] = [] {
        didSet {
            self.photoSectionView.imagePoolContent = self.imagePoolContent
        }
    }
    
    var reviewUserProfileImageContent: [UIImageView] = [] {
        didSet {
            self.reviewSectionView.reviewUserProfileImageContent = self.reviewUserProfileImageContent
        }
    }
    
    var restaurantFromGoogle: Restaurant?
    
    var restaurantImage: UIImage?
    var distance: Distance?
    
    var currentLocation: Location?
    
    let vcTitleLabel: UILabel = UILabel()
    
    var headerView: UIView!
    
    let kTableHeaderHeight: CGFloat = 250.0
    
    var animateTransition = true
    
    var parentVCName: String = ""
    
    var photoAttributionTextView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addImageForBackBarButtonItem()
        self.clearTitleForBackBarButtonItem()
        self.configLabels()
        self.tableView.showsVerticalScrollIndicator = false
        self.loadData()
        self.backgroundImageView.image = restaurantImage
        self.configureHeaderView()
        self.configureInfoSectionView()
        self.configurePhotoSectionView()
        self.configureReviewSectionView()
        self.configureRecommendedDishSectionView()
        self.addNotificationObserver()
        self.configPhotoAttributionTextView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reviewSectionView.resetRatingStar()
        self.recommendedDishSectionView.configureView()
    }
    
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadData), name:NSNotification.Name(rawValue: REVIEW_UPLOAD_DONE), object: nil)
    }
    
    private func configureInfoSectionView() {
        self.infoSectionView = UINib(
            nibName: "RestaurantInfoSectionView",
            bundle: nil
            ).instantiate(withOwner: nil, options: nil).first as! RestaurantInfoSectionView
        
        self.infoSectionView.frame = CGRect(x: 0, y: 0, width: self.infoSectionRootView.frame.width, height: self.infoSectionRootView.frame.height)
        self.infoSectionView.delegate = self
        self.infoSectionRootView.addSubview(self.infoSectionView)
    }
    
    private func configPhotoAttributionTextView() {
        photoAttributionTextView = UITextView(frame: CGRect(x: 0, y: self.view.frame.height - 80, width: self.view.frame.width, height: 30))
        photoAttributionTextView!.backgroundColor = UIColor.black
        photoAttributionTextView!.isEditable = false
        photoAttributionTextView!.textColor = UIColor.white
    }
    
    private func configurePhotoSectionView() {
        self.photoSectionView = UINib(
            nibName: "RestaurantPhotoSectionView",
            bundle: nil
            ).instantiate(withOwner: nil, options: nil).first as! RestaurantPhotoSectionView
        
        self.photoSectionView.frame = CGRect(x: 0, y: 0, width: self.photoSectionRootView.frame.width, height: self.photoSectionRootView.frame.height)
        self.photoSectionView.delegate = self
        self.photoSectionRootView.addSubview(self.photoSectionView)
    }
    
    private func configureReviewSectionView() {
        self.reviewSectionView = UINib(
            nibName: "RestaurantReviewSectionView",
            bundle: nil
            ).instantiate(withOwner: nil, options: nil).first as! RestaurantReviewSectionView
        
        self.reviewSectionView.frame = CGRect(x: 0, y: 0, width: self.reviewSectionRootView.frame.width, height: self.reviewSectionRootView.frame.height)
        self.reviewSectionView.delegate = self
        self.reviewSectionView.parentViewController = self
        self.reviewSectionRootView.addSubview(self.reviewSectionView)
    }
    
    private func configureRecommendedDishSectionView() {
        self.recommendedDishSectionView = UINib(
            nibName: "RestaurantRecommendedDishSectionView",
            bundle: nil
            ).instantiate(withOwner: nil, options: nil).first as! RestaurantRecommendedDishSectionView
        
        self.recommendedDishSectionView.frame = CGRect(x: 0, y: 0, width: self.recommendedDishSectionRootView.frame.width, height: self.recommendedDishSectionRootView.frame.height)
        recommendedDishSectionView.delegate = self
        //self.recommendedDishSectionView.parentViewController = self
        self.recommendedDishSectionRootView.addSubview(self.recommendedDishSectionView)
    }
    
    private func configLabels() {
        scoreLabel.layer.cornerRadius = 4
        scoreLabel.alpha = 0
    }
    
    /**
     *TODO: Future feature
     func configureFavoriteView(){
     favoriteView.layer.borderWidth = 1.0
     favoriteView.layer.borderColor = UIColor.whiteColor().CGColor
     favoriteView.layer.cornerRadius = 10.0
     favoriteButton.addTarget(self, action: #selector(RestaurantCollectionMembersViewController.favoriteButtonTapped(_:)), forControlEvents: .TouchUpInside)
     if let favoriteCount = selectedCollection?.userFavoriteCount {
     favoriteLabel.text = String(favoriteCount)
     }
     if !UserContext.isValidUser() {
     favoriteButton.selected = false
     } else {
     let request = GetIsFavoriteRequest(type: FavoriteTypeEnum.SelectedCollection, id: selectedCollection!.id!)
     DataAccessor(serviceConfiguration: ParseConfiguration()).getIsFavorite(request, responseHandler: { (response) -> Void in
     NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
     if response != nil && response?.result != nil {
     self.favoriteButton.selected = (response?.result)!
     }
     })
     
     })
     }
     }
     */
    
    
    
    private func configureHeaderView(){
        headerView = self.tableView.tableHeaderView
        self.tableView.tableHeaderView = nil
        self.tableView.addSubview(headerView)
        self.tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        self.tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)
        updateHeaderView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.tabBarController?.tabBar.isHidden == true {
            showTabbarSmoothly()
        }
        showNavigationBarSmoothly()
        self.animateTransition = true
        configVCTitle()
        TrackingUtil.trackRestaurantView()
    }
    
    
    func showTabbarSmoothly() {
        self.tabBarController?.tabBar.alpha = 0
        self.tabBarController?.tabBar.isHidden = false
        UIView.animate(withDuration: 0.6, animations: {
            self.tabBarController?.tabBar.alpha = 1
        })
    }
    
    func showNavigationBarSmoothly() {
        UIView.animate(withDuration: 0.6, animations: {
            self.setNavigationBarTranslucent(To: false)
        })
    }
    
    func configVCTitle() {
        if self.navigationItem.titleView?.alpha == nil {
            vcTitleLabel.text = self.restaurant?.name
            vcTitleLabel.backgroundColor = UIColor.clear
            vcTitleLabel.textColor = UIColor.white
            vcTitleLabel.sizeToFit()
            vcTitleLabel.alpha = 1.0
            self.navigationItem.titleView = vcTitleLabel
            self.navigationItem.titleView?.alpha = 0.0
        }
        
    }
    
    // MARK: TableView
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 260
        } else if indexPath.section == 1 {
            return 180
        } else if indexPath.section == 2 {
            return 160 + CGFloat(self.restaurant?.reviewInfo?.reviews.count ?? 0) * 160
        } else if indexPath.section == 3 {
            return 120
        } else {
            return 0
        }
    }
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        animateTransition = false
        if segue.identifier == "showAllPhotos" {
            let photosVC: PhotosCollectionViewController = segue.destination as! PhotosCollectionViewController
            photosVC.imagePool = imagePool
            photosVC.imagePoolContent = imagePoolContent
        } else if segue.identifier == "writeReview" {
            let newReviewNavigationVC: UINavigationController = segue.destination as! UINavigationController
            let newReviewVC: NewReviewViewController = newReviewNavigationVC.viewControllers[0] as! NewReviewViewController
            newReviewVC.restaurant = self.restaurant
            newReviewVC.rating = self.userRating
        } else if segue.identifier == "showAllReviews" {
            let reviewsVC: AllReviewsViewController = segue.destination as! AllReviewsViewController
            reviewsVC.reviews = self.restaurant?.reviewInfo?.reviews ?? []
            reviewsVC.reviewUserProfileImageContent = self.reviewUserProfileImageContent
        } else if segue.identifier == "showReview" {
            let reviewVC: ReviewDetailViewController = segue.destination as! ReviewDetailViewController
            reviewVC.review = self.restaurant?.reviewInfo?.reviews[(sender as! Int)]
            reviewVC.reviewUserProfileImage = self.reviewUserProfileImageContent[(sender as! Int)]
        } else if segue.identifier == "showAllRecommendedDishes" {
            let recommendedDishVC: RecommendedDishViewController = segue.destination as! RecommendedDishViewController
            recommendedDishVC.restaurant = self.restaurant
        }
    }
    
    
    // MARK: Restaurant Data
    
    func loadData() {
        if (request != nil) {
            request?.userLocation = self.currentLocation
            DataAccessor(serviceConfiguration: ParseConfiguration()).getRestaurantById(request!) { (response) -> Void in
                OperationQueue.main.addOperation({ () -> Void in
                    if response == nil {
                        
                    } else {
                        if response?.result != nil {
                            self.restaurant = (response?.result)!
                            if self.restaurant != nil {
                                
                                if self.backgroundImageView.image == nil {
                                    let backgroundImage: UIImage?
                                    if let imageURL = self.restaurant?.picture?.original {
                                        let url = URL(string: imageURL)
                                        let data = try? Data(contentsOf: url!)
                                        if data != nil {
                                            backgroundImage = UIImage(data: data!)
                                        } else {
                                            backgroundImage = DefaultImageGenerator.generateRestaurantDefaultImage()
                                        }
                                        
                                    } else {
                                        backgroundImage = DefaultImageGenerator.generateRestaurantDefaultImage()
                                    }
                                    self.backgroundImageView.image = backgroundImage
                                }
                                self.tableView.reloadData()
                            }
                        }
                    }
                });
            }
        }
    }
    
    
    
    private func clearData() {
        self.imagePool.removeAll()
    }
    
    func doUsingAppleMap(_ alertAction: UIAlertAction!) -> Void {
        TrackingUtil.trackAppleMapUsed()
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
        
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.restaurant?.address
        mapItem.openInMaps(launchOptions: options)
    }
    
    func doUsingGoogleMap(_ alertAction: UIAlertAction!) -> Void {
        TrackingUtil.trackGoogleMapUsed()
        let address: String = (self.restaurant?.address!.replacingOccurrences(of: " ", with: "+"))!
        let requestString: String = "comgooglemaps://?q=" + address
        print(requestString)
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.openURL(URL(string:
                requestString)!)
        } else {
            print("Can't use comgooglemaps://");
        }
    }
    
    func copyToClipBoard(_ alertAction: UIAlertAction!) -> Void {
        UIPasteboard.general.string = self.restaurant?.address
    }
    
    func cancelNavigation(_ alertAction: UIAlertAction!) {
        
    }
    
    func extractPhoneNumber(_ originalNumber : String?) -> String{
        if originalNumber == nil {
            return ""
        }
        let stringArray = originalNumber!.components(
            separatedBy: CharacterSet.decimalDigits.inverted)
        let newString = stringArray.joined(separator: "")
        return newString
    }
    
    
    // MARK: Photo Data
    private func loadImagePool(_ photos: [Picture]){
        self.imagePool.removeAll()
        for photo in photos {
            self.imagePool.append(photo)
        }
        self.downloadImages()
    }
    
    private func downloadImages(){
        self.imagePoolContent.removeAll()
        for image in imagePool {
            let imageView = UIImageView()
            var url: URL!
            if image.original != nil {
                url = URL(string: image.original!)
            } else if image.googlePhotoReference != nil {
                let googlePhotoURL: String = "https://maps.googleapis.com/maps/api/place/photo?key=AIzaSyDbWSwTi-anJJf25HxNrfBNicmrR0JSaOY&maxheight=500&maxwidth=500&photoreference=" + image.googlePhotoReference!
                url = URL(string: googlePhotoURL)
            } else {
                url = URL(string: "")
            }
            imageView.kf.setImage(with: url, placeholder: DefaultImageGenerator.generateRestaurantDefaultImage(),options: [.transition(ImageTransition.fade(0.5))], completionHandler: { (image, error, cacheType, imageURL) -> () in
                self.photoSectionView.imagePoolView.reloadData()
            })
            self.imagePoolContent.append(imageView)
        }
    }
    
    private func downloadReviewUserProfileImages() {
        if let reviews = self.restaurant?.reviewInfo?.reviews {
            for review in reviews {
                let imageView = UIImageView()
                let url: URL! = URL(string: review.user?.picture?.thumbnail ?? "")
                imageView.kf.setImage(with: url, placeholder: UIImage(named: "ChifanHero_UserProfile"),options: [.transition(ImageTransition.fade(0.5))], completionHandler: { (image, error, cacheType, imageURL) -> () in
                })
                self.reviewUserProfileImageContent.append(imageView)
            }
        }
    }
    
    private func uploadImages(_ images: [UIImage]) {
        print("start upload time \(Date().timeIntervalSince1970)")
        showUploadingAlert()
        let queue = OperationQueue()
        
        for image in images {
            queue.addOperation() {
                let maxLength = 100000 // 100KB
                var imageData = UIImageJPEGRepresentation(image, 1.0) //1.0 is compression ratio
                if imageData!.count > maxLength {
                    let compressionRatio: CGFloat = CGFloat(maxLength) / CGFloat((imageData?.count)!)
                    imageData = UIImageJPEGRepresentation(image, compressionRatio)
                }
                
                let base64_code: String = (imageData?.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters))!
                let request: UploadPictureRequest = UploadPictureRequest(base64_code: base64_code)
                request.restaurantId = self.restaurantId!
                
                print("upload to server time \(Date().timeIntervalSince1970)")
                DataAccessor(serviceConfiguration: ParseConfiguration()).uploadPicture(request) { (response) -> Void in
                    OperationQueue.main.addOperation({ () -> Void in
                        //add actions here
                        print("done");
                        if response != nil && response?.result != nil && response?.result?.id != nil {
                            print("upload finish time \(Date().timeIntervalSince1970)")
                            self.imagePool.insert((response?.result)!, at: 0)
                            self.showNewAddedImage(image)
                        } else {
                            #if DEBUG
                                self.showBannerAlert("图片上传失败。Error: Response is nil")
                            #else
                                self.showBannerAlert("图片上传失败。请稍后再试。")
                            #endif
                        }
                    });
                }
            }
        }
    }
    
    private func showNewAddedImage(_ image: UIImage) {
        let imageView = UIImageView()
        imageView.image = image
        self.imagePoolContent.insert(imageView, at: 0)
        self.photoSectionView.imagePoolView.reloadData()
    }
    
    private func showBannerAlert(_ message: String) {
        MILAlertViewManager.sharedInstance.show(.classic,
                                                text: message,
                                                backgroundColor: UIColor.purple,
                                                inView: nil,
                                                toHeight: 0,
                                                forSeconds:0.5,
                                                callback: nil)
    }
    
    
    
    
    private func showUploadingAlert() {
        var appearance = SCLAlertView.SCLAppearance()
        appearance.showCloseButton = false
        appearance.showCircularIcon = true
        appearance.setkWindowHeight(40)
        uploadingAlertView = SCLAlertView(appearance: appearance)
        
        let timeoutConfig = SCLButton.ShowTimeoutConfiguration()
        uploadingAlertView?.addButton("隐藏", backgroundColor: UIColor.themeOrange(), textColor: UIColor.black, showTimeout: timeoutConfig, target: self, selector: #selector(RestaurantMainTableViewController.hideAlertView))
        uploadingAlertView!.showInfo("正在上传图片", subTitle: "正在后台上传，请稍等...")
    }
    
    func hideAlertView() {
        if uploadingAlertView != nil {
            uploadingAlertView?.hideView()
            uploadingAlertView = nil
        }
        
    }
    
    
    // MARK: Photo selection
    func goToAlbum(_ alertAction: UIAlertAction!) -> Void {
        let pickerController = DKImagePickerController()
        pickerController.singleSelect = false
        pickerController.maxSelectableCount = 10
        pickerController.assetType = DKImagePickerControllerAssetType.allPhotos
        pickerController.sourceType = DKImagePickerControllerSourceType.photo
        pickerController.allowMultipleTypes = false
        pickerController.allowsLandscape = false
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            self.processSelectedPhotosFromPhotoLibrary(assets)
        }
        self.present(pickerController, animated: true) {}
    }
    
    func goToCamera(_ alertAction: UIAlertAction!) -> Void {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func processSelectedPhotosFromPhotoLibrary(_ assets: [DKAsset]) {
        var images : [UIImage] = []
        for asset in assets {
            asset.fetchOriginalImageWithCompleteBlock({ (image, info) in
                images.append(image!)
                if images.count == assets.count {
                    self.uploadImages(images)
                }
            })
        }
    }
    
    // MARK: ImagePickerDelegate
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
        
    }
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
        uploadImages(images)
        self.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController){
        
    }
    
    // MARK: - ScrollView
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
        let offset = scrollView.contentOffset.y
        let nameLabelBottomY = getNameLabelBottomY() + 200
        if offset > nameLabelBottomY{
            let scale = (abs(offset) - abs(nameLabelBottomY)) / 40
            self.navigationItem.titleView?.alpha = scale
        } else {
            self.navigationItem.titleView?.alpha = 0.0
        }
    }
    
    private func getNameLabelBottomY() -> CGFloat {
        return 0
    }
    
    private func updateHeaderView(){
        var headerRect = CGRect(x: 0, y: -kTableHeaderHeight, width: self.tableView.bounds.width, height: kTableHeaderHeight)
        if tableView.contentOffset.y < -kTableHeaderHeight {
            headerRect.origin.y = self.tableView.contentOffset.y
            headerRect.size.height = -self.tableView.contentOffset.y
        }
        headerView.frame = headerRect
    }
    
    // MARK: - ARNImageTransitionZoomable
    
    func createTransitionImageView() -> UIImageView {
        let imageView = UIImageView(image: self.backgroundImageView.image)
        imageView.contentMode = self.backgroundImageView.contentMode
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = false
        imageView.frame = CGRect(x: 0.0, y: 0.0, width: self.tableView.frame.width, height: 314.0)
        return imageView
    }
    
    func presentationBeforeAction() {
        backgroundImageView.isHidden = true
    }
    
    func presentationCompletionAction(_ completeTransition: Bool) {
        backgroundImageView.isHidden = false
    }
    
    func dismissalBeforeAction() {
        backgroundImageView.isHidden = true
    }
    
    func dismissalCompletionAction(_ completeTransition: Bool) {
        if !completeTransition {
            backgroundImageView.isHidden = false
        }
    }
    
    func usingAnimatedTransition() -> Bool {
        return animateTransition
    }
    
    func getId() -> String {
        return "RestaurantViewController"
    }
    
    func getDirectAncestorId() -> String {
        return parentVCName
    }
    
    // MARK: RatingStarCellDelegate
    func writeReview() {
        self.performSegue(withIdentifier: "writeReview", sender: nil)
    }
    
    func recordUserRating(_ rating: Int) {
        self.userRating = rating
    }
    
    // MARK: RestaurantInfoSectionDelegate
    func callRestaurant() {
        TrackingUtil.trackPhoneCallUsed()
        let alert = UIAlertController(title: "呼叫", message: "\(self.restaurant?.phone ?? "")", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let doCallAction = UIAlertAction(title: "确定", style: .default, handler: { (action) -> Void in
            let phoneNumber = self.extractPhoneNumber(self.restaurant?.phone)
            if let url = URL(string: "tel://\(phoneNumber)") {
                UIApplication.shared.openURL(url)
            }
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alert.addAction(doCallAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func startNavigation() {
        TrackingUtil.trackNavigationUsed()
        var localSearchRequest:MKLocalSearchRequest!
        var localSearch:MKLocalSearch!
        
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = self.restaurant?.address
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            self.localSearchResponse = localSearchResponse
            let alert = UIAlertController(title: "打开地图", message: "是否打开地图导航", preferredStyle: UIAlertControllerStyle.actionSheet)
            
            let goWithAppleAction = UIAlertAction(title: "内置地图", style: .default, handler: self.doUsingAppleMap)
            let goWithGoogleAction = UIAlertAction(title: "谷歌地图", style: .default, handler: self.doUsingGoogleMap)
            let copyAction = UIAlertAction(title: "复制", style: .default, handler: self.copyToClipBoard)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: self.cancelNavigation)
            
            alert.addAction(goWithAppleAction)
            alert.addAction(goWithGoogleAction)
            alert.addAction(copyAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func addBookmarkButtonPressed() {
        print("I know")
    }
    
    func writeReviewButtonPressed() {
        self.performSegue(withIdentifier: "writeReview", sender: nil)
    }
    
    func addPhotoButtonPressed() {
        let alert = UIAlertController(title: "相片来源", message: "请选取相片来源", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let goAlbumAction = UIAlertAction(title: "相册", style: .default, handler: self.goToAlbum)
        let goCameraAction = UIAlertAction(title: "拍照", style: .default, handler: self.goToCamera)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alert.addAction(goAlbumAction)
        alert.addAction(goCameraAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: RestaurantReviewSectionDelegate
    func showReview(_ index: Int) {
        performSegue(withIdentifier: "showReview", sender: index)
    }
    
    func showAllReviews() {
        performSegue(withIdentifier: "showAllReviews", sender: nil)
    }
    
    // MARK: RestaurantPhotoSectionDelegate
    func showAllPhotos() {
        performSegue(withIdentifier: "showAllPhotos", sender: nil)
    }
    
    func showSKPhotoBrowser(pageIndex: Int) {
        var images = [SKPhoto]()
        for imageView in imagePoolContent {
            images.append(SKPhoto.photoWithImage(imageView.image!))
        }
        let browser = SKPhotoBrowser(photos: images)
        browser.delegate = self
        browser.view.addSubview(photoAttributionTextView!)
        browser.initializePageIndex(pageIndex)
        present(browser, animated: true, completion: {
            if self.imagePool[pageIndex].htmlAttributions.count > 0 {
                self.photoAttributionTextView!.attributedText = self.imagePool[pageIndex].htmlAttributions[0].attributedStringFromHTML()
                self.photoAttributionTextView!.textAlignment = .center
                self.photoAttributionTextView!.font = .systemFont(ofSize: 16)
            }
        })
    }
    
    // MARK: RestaurantRecommendedDishDelegate
    
    func showAllRecommendedDishes() {
        performSegue(withIdentifier: "showAllRecommendedDishes", sender: nil)
    }
    
    func didScrollToIndex(_ index: Int) {
        if self.imagePool[index].htmlAttributions.count > 0 {
            self.photoAttributionTextView!.attributedText = self.imagePool[index].htmlAttributions[0].attributedStringFromHTML()
            self.photoAttributionTextView!.textAlignment = .center
            self.photoAttributionTextView!.font = .systemFont(ofSize: 16)
        }
    }
    
    func controlsVisibilityToggled(hidden: Bool) {
        var alpha: CGFloat?
        if hidden {
            alpha = 0
        } else {
            alpha = 1
        }
        UIView.animate(withDuration: 0.2) {
            self.photoAttributionTextView!.alpha = alpha!
        }
    }
    
}
