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

class RestaurantMainTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, ImagePickerDelegate, ARNImageTransitionZoomable, ARNImageTransitionIdentifiable, SKPhotoBrowserDelegate {
    
    @IBOutlet weak var blurContainer: UIVisualEffectView!

    @IBOutlet weak var blurContainerWidthContraint: NSLayoutConstraint!
    
    @IBOutlet weak var favoriteButton: DOFavoriteButton!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var recommendationDishLabel: UILabel!
    
    @IBOutlet weak var imagePoolView: UICollectionView!
    
    @IBOutlet weak var goButton: UIButton!
    
    @IBOutlet weak var callButton: UIButton!
    
    @IBOutlet weak var reviewsSnapshotView: ReviewsSnapshotView!
    
    
    var localSearchResponse: MKLocalSearchResponse!
    
    var restaurantId: String? {
        didSet {
            request = GetRestaurantByIdRequest(id: restaurantId!)
        }
    }
    
    var uploadingAlertView : SCLAlertView?
    
    var request: GetRestaurantByIdRequest?
    
    var restaurant: Restaurant?
    
    var restaurantFromGoogle: Restaurant?
    
    var restaurantImage: UIImage?
    var restaurantName: String?
    var address: String?
    var phone: String?
    var distance: Distance?
    var hotDishes: [Dish] = []
    var rating: Double?
    
    var imagePool: [Picture] = []
    
    var imagePoolContent: [UIImageView] = []
    
    let vcTitleLabel: UILabel = UILabel()
    
    var headerView: UIView!
    
    let kTableHeaderHeight: CGFloat = 250.0
    
    var animateTransition = true
    
    var parentVCName: String = ""
    
    var isFromGoogleSearch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.addImageForBackBarButtonItem()
        self.clearTitleForBackBarButtonItem()
        self.prepareBlurContainer()
        self.configLabels()
        self.configActionButton()
        self.tableView.showsVerticalScrollIndicator = false
        self.reviewsSnapshotView.parentViewController = self
        self.loadData { (success) -> Void in
            if !success {
                // self.noNetworkDefaultView.show()
            }
        }
        self.backgroundImageView.image = restaurantImage
        self.configureButtons()
        self.configureHeaderView()
        self.configureRestaurantIfFromGoogle()
    }

    private func configLabels() {
        if distance != nil && distance?.value != nil && distance?.unit != nil{
            let distanceValue = String(format: "%.1f", distance!.value!)
            distanceLabel.text = "\(distanceValue) \(distance!.unit!)"
        }
        if rating != nil {
            let ratingValue = String(format: "%.1f", rating!)
            scoreLabel.text = ratingValue
            scoreLabel.backgroundColor = ScoreComputer.getScoreColor(rating!)
        }
        if address != nil {
            addressLabel.text = address!
        }
        if phone != nil {
            phoneLabel.text = phone!
        }
        scoreLabel.layer.cornerRadius = 4
        nameLabel.text = restaurantName
    }
    
    private func prepareBlurContainer() {
        let nameWidth: CGFloat = (restaurantName! as NSString).size(attributes: [NSFontAttributeName : nameLabel.font]).width
        self.blurContainerWidthContraint.constant = nameWidth + 60
        self.blurContainer.layer.cornerRadius = 4
        self.view.layoutIfNeeded()
    }
    
    private func configureRestaurantIfFromGoogle(){
        if isFromGoogleSearch {
            if restaurantFromGoogle?.address != nil {
                self.addressLabel.text = restaurantFromGoogle?.address
            }
            if restaurantFromGoogle?.phone != nil {
                self.phoneLabel.text = restaurantFromGoogle?.phone
            }
        }
    }
    
    private func configActionButton() {
        self.view.layoutIfNeeded()
        favoriteButton.image = UIImage(named: "Chifanhero_Favorite")
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
    
    private func configureButtons(){
        self.goButton.layer.borderColor = UIColor(red: 49/255, green: 163/255, blue: 67/255, alpha: 1).cgColor
        self.goButton.layer.borderWidth = 1.0
        self.goButton.layer.cornerRadius = 3.0
        
        self.callButton.layer.borderColor = UIColor(red: 49/255, green: 163/255, blue: 67/255, alpha: 1).cgColor
        self.callButton.layer.borderWidth = 1.0
        self.callButton.layer.cornerRadius = 3.0
    }
    
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
            vcTitleLabel.text = restaurantName
            vcTitleLabel.backgroundColor = UIColor.clear
            vcTitleLabel.textColor = UIColor.white
            vcTitleLabel.sizeToFit()
            vcTitleLabel.alpha = 1.0
            self.navigationItem.titleView = vcTitleLabel
            self.navigationItem.titleView?.alpha = 0.0
        }
        
    }
    
    // MARK: - Data
    
    private func downloadImages(){
        for image in imagePool {
            let imageView = UIImageView()
            var url: String = ""
            url = image.original!
            imageView.kf.setImage(with: URL(string: url)!, placeholder: UIImage(named: "restaurant_default_background"),options: [.transition(ImageTransition.fade(0.5))], completionHandler: { (image, error, cacheType, imageURL) -> () in
                self.imagePoolView.reloadData()
            })
            self.imagePoolContent.append(imageView)
        }
    }
    
    
    func loadData(_ refreshHandler: ((_ success: Bool) -> Void)?) {
        if (request != nil) {
            DataAccessor(serviceConfiguration: ParseConfiguration()).getRestaurantById(request!) { (response) -> Void in
                OperationQueue.main.addOperation({ () -> Void in
                    if response == nil {
                        if refreshHandler != nil {
                            refreshHandler!(false)
                        }
                    } else {
                        if response?.result != nil {
                            self.restaurant = (response?.result)!
                            if self.restaurant != nil {
                                
                                if self.restaurantName != nil {
                                    self.restaurantName = self.restaurant?.name
                                }
                                if self.backgroundImageView.image == nil {
                                    let backgroundImage : UIImage?
                                    if let imageURL = self.restaurant?.picture?.original {
                                        let url = URL(string: imageURL)
                                        let data = try? Data(contentsOf: url!)
                                        if data != nil {
                                            backgroundImage = UIImage(data: data!)
                                        } else {
                                            backgroundImage = UIImage(named: "restaurant_default_background")
                                        }
                                        
                                    } else {
                                        backgroundImage = UIImage(named: "restaurant_default_background")
                                    }
                                    self.backgroundImageView.image = backgroundImage
                                }
                                //
                                if self.restaurant?.address != nil {
                                    self.address = self.restaurant?.address
                                    self.addressLabel.text = self.address
                                }
                                if self.restaurant?.phone != nil {
                                    self.phone = self.restaurant?.phone
                                    self.phoneLabel.text = self.phone
                                }
                                if self.restaurant != nil {
                                    self.hotDishes.removeAll()
                                    self.hotDishes += (self.restaurant?.hotDishes)!
                                }
                                if self.restaurant?.hotDishes != nil && self.restaurant?.hotDishes.count != 0 {
                                    self.recommendationDishLabel.text = ""
                                    for index in 0..<10 {
                                        self.recommendationDishLabel.text?.append((self.restaurant?.hotDishes[index].name)!)
                                        self.recommendationDishLabel.text?.append("  ")
                                    }
                                }
                                if self.restaurant?.photoInfo != nil {
                                    if self.restaurant?.photoInfo!.photos != nil {
                                        self.loadImagePool(self.restaurant!.photoInfo!.photos)
                                    }
                                    
                                }
                                if self.restaurant?.reviewInfo != nil {
                                    self.reviewsSnapshotView.reviews = self.restaurant!.reviewInfo!.reviews
                                    self.reviewsSnapshotView.reloadData()
                                }
                                self.tableView.reloadData()
                            }
                            
                        }
                        if refreshHandler != nil {
                            refreshHandler!(true)
                        }
                        
                        
                    }
                    
                });
            }
        }
    }
    
    func loadImagePool(_ photos: [Picture]){
        imagePool.removeAll()
        for photo in photos {
            self.imagePool.append(photo)
        }
        self.downloadImages()
    }
    
    fileprivate func clearData() {
        self.imagePool.removeAll()
    }
    
    
    @IBAction func go(_ sender: AnyObject) {
        TrackingUtil.trackNavigationUsed()
        var localSearchRequest:MKLocalSearchRequest!
        var localSearch:MKLocalSearch!
        
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = self.address
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
        mapItem.name = self.address
        mapItem.openInMaps(launchOptions: options)
    }
    
    func doUsingGoogleMap(_ alertAction: UIAlertAction!) -> Void {
        TrackingUtil.trackGoogleMapUsed()
        let address: String = self.address!.replacingOccurrences(of: " ", with: "+")
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
        UIPasteboard.general.string = self.address
    }
    
    func cancelNavigation(_ alertAction: UIAlertAction!) {
        
    }
    
    @IBAction func showAllReviews(_ sender: AnyObject) {
        performSegue(withIdentifier: "showReviews", sender: nil)
    }
    
    @IBAction func showAllPhotos(_ sender: AnyObject) {
        performSegue(withIdentifier: "showAllPhotos", sender: nil)
    }
    
    @IBAction func showAllRecommendations(_ sender: AnyObject) {
        performSegue(withIdentifier: "showRecommendations", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        animateTransition = false
        if segue.identifier == "showAllPhotos" {
            let photosVC: PhotosCollectionViewController = segue.destination as! PhotosCollectionViewController
            var pictures: [Picture] = []
            for picture in imagePool {
                pictures.append(picture)
            }
            photosVC.pictures = pictures
        } else if segue.identifier == "writeReview" {
            let newReviewNavigationVC: UINavigationController = segue.destination as! UINavigationController
            let newReviewVC: NewReviewViewController = newReviewNavigationVC.viewControllers[0] as! NewReviewViewController
            newReviewVC.restaurantId = self.restaurantId
        } else if segue.identifier == "showReviews" {
            let reviewsVC: ReviewsViewController = segue.destination as! ReviewsViewController
            reviewsVC.restaurantId = self.restaurantId
        }
    }
    

    @IBAction func call(_ sender: AnyObject) {
        TrackingUtil.trackPhoneCallUsed()
        let alert = UIAlertController(title: "呼叫", message: "\(self.phone!)", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let doCallAction = UIAlertAction(title: "确定", style: .default, handler: { (action) -> Void in
            let phoneNumber = self.extractPhoneNumber(self.phone)
            if let url = URL(string: "tel://\(phoneNumber)") {
                UIApplication.shared.openURL(url)
            }
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alert.addAction(doCallAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
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
    // MARK: - Table view data source
    
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return imagePool.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RestaurantImagePoolCollectionViewCell? = imagePoolView.dequeueReusableCell(withReuseIdentifier: "restaurantImagePoolCell", for: indexPath) as? RestaurantImagePoolCollectionViewCell
        
        // Configure the cell
        if indexPath.row < imagePool.count {
            cell!.setUp(image: imagePoolContent[indexPath.row].image!)
        } else {
            cell!.setUpAddingImageCell()
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == imagePool.count {
//            let imagePickerController = ImagePickerController()
//            imagePickerController.delegate = self
//            self.presentViewController(imagePickerController, animated: true, completion: nil)
            let alert = UIAlertController(title: "选择图片来源", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
            
            let albumAction = UIAlertAction(title: "相册", style: .default, handler: self.goToAlbum)
            let cameraAction = UIAlertAction(title: "拍摄", style: .default, handler: self.goToCamera)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: self.cancelNavigation)
            
            alert.addAction(albumAction)
            alert.addAction(cameraAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        } else {
//            let photoGallery = PhotoGalleryViewController()
//            photoGallery.parentVC = self
//            photoGallery.currentIndexPath = indexPath
//            self.presentViewController(photoGallery, animated: false, completion: nil)
            var images = [SKPhoto]()
            for picture in imagePool {
//                let photo = SKPhoto.photoWithImage(imageView.image!)// add some UIImage
                if picture.original != nil {
                    let photo = SKPhoto.photoWithImageURL(picture.original!)
                    images.append(photo)
//                    photo.caption = picture.description
                    photo.caption = "这张照片非常牛逼这张照片非常牛逼这张照片非常牛逼这张照片非常牛逼这张照片非常牛逼这张照片非常牛逼这张照片非常牛逼这张照片非常牛逼这张照片非常牛逼这张照片非常牛逼这张照片非常牛逼这张照片非常牛逼这张照片非常牛逼这张照片非常牛逼这张照片非常牛逼这张照片非常牛逼这张照片非常牛逼这张照片非常牛逼这张照片非常牛逼这张照片非常牛逼这张照片非常牛逼这张照片非常牛逼这张照片非常牛逼这张照片非常牛逼这张照片非常牛逼这张照片非常牛逼这张照片非常牛逼这张照片非常牛逼"
                } else {
                    let photo = SKPhoto.photoWithImage(UIImage(named: "restaurant_default_background")!)
                    images.append(photo)
                    photo.caption = picture.description
                }
            }
            let browser = SKPhotoBrowser(photos: images)
            browser.initializePageIndex(indexPath.row)
            present(browser, animated: true, completion: {})
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
    
    //MARK: ImagePickerDelegate
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
        
    }
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
        uploadImages(images)
        self.dismiss(animated: true, completion: nil)
    }
    
    func uploadImages(_ images: [UIImage]) {
        print("start upload time \(Date().timeIntervalSince1970)")
        showUploadingAlert()
        let queue = OperationQueue()
        let uniqueId = IdGenerator.newId()
        
        for image in images {
            queue.addOperation() {
                let maxLength = 99999
                var imageData = UIImageJPEGRepresentation(image, 1.0) //1.0 is compression ratio
                if imageData!.count > maxLength {
                    let compressionRatio: CGFloat = CGFloat(maxLength) / CGFloat((imageData?.count)!)
                    imageData = UIImageJPEGRepresentation(image, compressionRatio)
                }
                
                let base64_code: String = (imageData?.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters))!
                let request: UploadRestaurantPictureRequest = UploadRestaurantPictureRequest(restaurantId: self.restaurantId!, type: "restaurant", base64_code: base64_code)
                request.eventId = uniqueId
                print("upload to server time \(Date().timeIntervalSince1970)")
                DataAccessor(serviceConfiguration: ParseConfiguration()).uploadRestaurantPicture(request) { (response) -> Void in
                    OperationQueue.main.addOperation({ () -> Void in
                        //add actions here
                        print("done");
                        if response != nil && response?.result != nil {
                            if response?.error == nil {
                                print("upload finish time \(Date().timeIntervalSince1970)")
                                self.imagePool.append((response?.result)!)
                                //                            self.downloadNewAddedImage((response?.result)!)
                                self.showNewAddedImage(image)
                            } else {
                                #if DEBUG
                                    self.showBannerAlert("图片上传失败。Error:\(String(describing: response?.error?.message))")
                                #else
                                    self.showBannerAlert("图片上传失败。请稍后再试。")
                                #endif
                            }
                            
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
    
    func showBannerAlert(_ message: String) {
        self.view.layoutIfNeeded()
        print(self.view.frame)
        print(self.view.bounds)
        MILAlertViewManager.sharedInstance.show(.classic,
                                                text: message,
                                                backgroundColor: UIColor.purple,
                                                inView: nil,
                                                toHeight: 0,
                                                forSeconds:0.5,
                                                callback: nil)
    }
    
    fileprivate func showNewAddedImage(_ image: UIImage) {
        let imageView = UIImageView()
        imageView.image = image
        self.imagePoolContent.append(imageView)
        self.imagePoolView.reloadData()
    }
    
    
    func showUploadingAlert() {
        var appearance = SCLAlertView.SCLAppearance()
        appearance.showCloseButton = false
        appearance.showCircularIcon = true
        appearance.setkWindowHeight(40)
        uploadingAlertView = SCLAlertView(appearance: appearance)
        //let alertViewIcon = UIImage(named: "LogoWithBorder")
        
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        } else if indexPath.section == 1 {
            return 180
        } else if indexPath.section == 2 {
            return self.reviewsSnapshotView.getHeight() + 40
        } else if indexPath.section == 3 {
            return 120
        } else {
            return 0
        }
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
    
    fileprivate func updateHeaderView(){
        var headerRect = CGRect(x: 0, y: -kTableHeaderHeight, width: self.tableView.bounds.width, height: kTableHeaderHeight)
        if tableView.contentOffset.y < -kTableHeaderHeight {
            headerRect.origin.y = self.tableView.contentOffset.y
            headerRect.size.height = -self.tableView.contentOffset.y
        }
        headerView.frame = headerRect
    }
    
    func getNameLabelBottomY() -> CGFloat {
        return self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height / 2
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
}
