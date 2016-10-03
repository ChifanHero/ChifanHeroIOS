//
//  RestaurantMainTableViewController.swift
//  Lightning
//
//  Created by Shi Yan on 8/15/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit
import MapKit
import Kingfisher
import SKPhotoBrowser


class RestaurantMainTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, ImagePickerDelegate, ARNImageTransitionZoomable, ARNImageTransitionIdentifiable {
    
    @IBOutlet weak var blurContainer: UIVisualEffectView!
    
    
//    @IBOutlet weak var distanceBlurContainer: UIVisualEffectView!
    
    
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
    
//    @IBOutlet weak var actionPanelView: ActionPanelView!
    
    @IBOutlet weak var goButton: UIButton!
    
    @IBOutlet weak var callButton: UIButton!
    
    @IBOutlet weak var reviewsSnapshotView: ReviewsSnapshotView!
    
    
    var localSearchResponse:MKLocalSearchResponse!
    
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
    var phone: String!
    var hotDishes: [Dish] = [Dish]()
    
    var imagePool: [Picture] = []
    
    var imagePoolContent: [UIImageView] = []
    
    var imagePoolSKPhoto : [SKPhoto] = [SKPhoto]()
    
    let vcTitleLabel: UILabel = UILabel()
    
    var headerView: UIView!
    
    let kTableHeaderHeight: CGFloat = 250.0
    
    var animateTransition = true
    
    var parentVCName: String = ""
    
    var isFromGoogleSearch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewsSnapshotView.parentViewController = self
        self.addImageForBackBarButtonItem()
        self.clearTitleForBackBarButtonItem()
        prepareBlurContainer()
//        distanceBlurContainer.layer.cornerRadius = 4
        distanceLabel.text = "25.5 mi"
        scoreLabel.layer.cornerRadius = 4
        configActionButton()
        self.tableView.showsVerticalScrollIndicator = false
        loadData { (success) -> Void in
            if !success {
                //                self.noNetworkDefaultView.show()
            }
        }
        backgroundImageView.image = restaurantImage
        
        nameLabel.text = restaurantName
        loadImagePool()
//        actionPanelView.baseVC = self
//        actionPanelView.isFromGoogleSearch = self.isFromGoogleSearch
        self.configureButtons()
        
        self.configureHeaderView()
        self.configureRestaurantIfFromGoogle()
    }
    
    private func prepareBlurContainer() {
        let nameWidth : CGFloat = (restaurantName! as NSString).sizeWithAttributes([NSFontAttributeName : nameLabel.font]).width
        blurContainerWidthContraint.constant = nameWidth + 60
        self.view.layoutIfNeeded()
        blurContainer.layer.cornerRadius = 4
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
    
    func configureFavoriteView(){
//        favoriteView.layer.borderWidth = 1.0
//        favoriteView.layer.borderColor = UIColor.whiteColor().CGColor
//        favoriteView.layer.cornerRadius = 10.0
//        favoriteButton.addTarget(self, action: #selector(RestaurantCollectionMembersViewController.favoriteButtonTapped(_:)), forControlEvents: .TouchUpInside)
//        if let favoriteCount = selectedCollection?.userFavoriteCount {
//            favoriteLabel.text = String(favoriteCount)
//        }
//        if !UserContext.isValidUser() {
//            favoriteButton.selected = false
//        } else {
//            let request = GetIsFavoriteRequest(type: FavoriteTypeEnum.SelectedCollection, id: selectedCollection!.id!)
//            DataAccessor(serviceConfiguration: ParseConfiguration()).getIsFavorite(request, responseHandler: { (response) -> Void in
//                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                    if response != nil && response?.result != nil {
//                        self.favoriteButton.selected = (response?.result)!
//                    }
//                })
//                
//            })
//        }
    }
    
    private func configureButtons(){
        self.goButton.layer.borderColor = UIColor(red: 49/255, green: 163/255, blue: 67/255, alpha: 1).CGColor
        self.goButton.layer.borderWidth = 1.0
        self.goButton.layer.cornerRadius = 3.0
        
        self.callButton.layer.borderColor = UIColor(red: 49/255, green: 163/255, blue: 67/255, alpha: 1).CGColor
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if self.tabBarController?.tabBar.hidden == true {
            showTabbarSmoothly()
        }
        showNavigationBarSmoothly()
        self.animateTransition = true
        configVCTitle()
        TrackingUtil.trackRestaurantView()
    }
    
    
    func showTabbarSmoothly() {
        self.tabBarController?.tabBar.alpha = 0
        self.tabBarController?.tabBar.hidden = false
        UIView.animateWithDuration(0.6) {
            self.tabBarController?.tabBar.alpha = 1
        }
    }
    
    func showNavigationBarSmoothly() {
        UIView.animateWithDuration(0.6) {
            self.setNavigationBarTranslucent(To: false)
        }
    }
    
    func configVCTitle() {
        if self.navigationItem.titleView?.alpha == nil {
            vcTitleLabel.text = restaurantName
            vcTitleLabel.backgroundColor = UIColor.clearColor()
            vcTitleLabel.textColor = UIColor.whiteColor()
            vcTitleLabel.sizeToFit()
            vcTitleLabel.alpha = 1.0
            self.navigationItem.titleView = vcTitleLabel
            self.navigationItem.titleView?.alpha = 0.0
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Data
    
    private func downloadImages(){
        for image in imagePool {
            let imageView = UIImageView()
            var url: String = ""
            url = image.original!
            imageView.kf_setImageWithURL(NSURL(string: url)!, placeholderImage: UIImage(named: "restaurant_default_background"),optionsInfo: [.Transition(ImageTransition.Fade(0.5))], completionHandler: { (image, error, cacheType, imageURL) -> () in
                self.imagePoolView.reloadData()
            })
            self.imagePoolContent.append(imageView)
        }
    }
    
    private func downloadNewAddedImage(image: Picture){
        let imageView = UIImageView()
        var url: String = ""
        url = image.original!
        imageView.kf_setImageWithURL(NSURL(string: url)!, placeholderImage: UIImage(named: "restaurant_default_background"),optionsInfo: [.Transition(ImageTransition.Fade(0.5))], completionHandler: { (image, error, cacheType, imageURL) -> () in
            self.imagePoolView.reloadData()
            self.hideAlertView()
        })
        self.imagePoolContent.append(imageView)
        
    }
    
    func loadData(refreshHandler: ((success: Bool) -> Void)?) {
        if (request != nil) {
            DataAccessor(serviceConfiguration: ParseConfiguration()).getRestaurantById(request!) { (response) -> Void in
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    if response == nil {
                        if refreshHandler != nil {
                            refreshHandler!(success: false)
                        }
                    } else {
                        if response?.result != nil {
                            self.restaurant = (response?.result)!
                            if self.restaurant != nil {
//                                self.actionPanelView.restaurantId = self.restaurant?.id
                                
                                if self.restaurantName != nil {
                                    self.restaurantName = self.restaurant?.name
                                }
                                if self.backgroundImageView.image == nil {
                                    let backgroundImage : UIImage?
                                    if let imageURL = self.restaurant?.picture?.original {
                                        let url = NSURL(string: imageURL)
                                        let data = NSData(contentsOfURL: url!)
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
                                if self.restaurant != nil && self.restaurant!.hotDishes != nil {
                                    self.hotDishes.removeAll()
                                    self.hotDishes += (self.restaurant?.hotDishes)!
                                }
//                                if self.restaurant?.likeCount != nil {
//                                    self.actionPanelView.likeCount = self.restaurant?.likeCount
//                                }
//                                if self.restaurant?.dislikeCount != nil {
//                                    self.actionPanelView.dislikeCount = self.restaurant?.dislikeCount
//                                }
//                                if self.restaurant?.neutralCount != nil {
//                                    self.actionPanelView.neutralCount = self.restaurant?.neutralCount
//                                }
//                                if self.restaurant?.favoriteCount != nil {
//                                    self.actionPanelView.favoriteCount = self.restaurant?.favoriteCount
//                                }
                                if self.restaurant?.hotDishes != nil && self.restaurant?.hotDishes!.count != 0 {
                                    self.recommendationDishLabel.text = ""
                                    for index in 0..<10 {
                                        self.recommendationDishLabel.text?.appendContentsOf((self.restaurant?.hotDishes![index].name)!)
                                        self.recommendationDishLabel.text?.appendContentsOf("  ")
                                    }
                                }
                            }
                            
                        } else {
//                            self.actionPanelView.hidden = true
                        }
                        if refreshHandler != nil {
                            refreshHandler!(success: true)
                        }
                        
                        
                    }
                    
                });
            }
        }
    }
    
    func loadImagePool(){
        imagePool.removeAll()
        let request: GetImagesRequest = GetImagesRequest(restaurantId: restaurantId!)
        DataAccessor(serviceConfiguration: ParseConfiguration()).getImagesByRestaurantId(request) { (response) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.clearData()
                if (response != nil && response?.results != nil) {
                    for index in 0..<(response?.results)!.count {
                        self.imagePool.append((response?.results)![index])
                    }
                    self.downloadImages()
                }
            });
        }
    }
    
    private func clearData() {
        self.imagePool.removeAll()
    }
    
    
    @IBAction func go(sender: AnyObject) {
        TrackingUtil.trackNavigationUsed()
        var localSearchRequest:MKLocalSearchRequest!
        var localSearch:MKLocalSearch!
        
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = self.address
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            self.localSearchResponse = localSearchResponse
            let alert = UIAlertController(title: "打开地图", message: "是否打开地图导航", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            let goWithAppleAction = UIAlertAction(title: "内置地图", style: .Default, handler: self.doUsingAppleMap)
            let goWithGoogleAction = UIAlertAction(title: "谷歌地图", style: .Default, handler: self.doUsingGoogleMap)
            let copyAction = UIAlertAction(title: "复制", style: .Default, handler: self.copyToClipBoard)
            let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: self.cancelNavigation)
            
            alert.addAction(goWithAppleAction)
            alert.addAction(goWithGoogleAction)
            alert.addAction(copyAction)
            alert.addAction(cancelAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }

    }
    
    func doUsingAppleMap(alertAction: UIAlertAction!) -> Void {
        TrackingUtil.trackAppleMapUsed()
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
        
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.address
        mapItem.openInMapsWithLaunchOptions(options)
    }
    
    func doUsingGoogleMap(alertAction: UIAlertAction!) -> Void {
        TrackingUtil.trackGoogleMapUsed()
        let address: String = self.address!.stringByReplacingOccurrencesOfString(" ", withString: "+")
        let requestString: String = "comgooglemaps://?q=" + address
        print(requestString)
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
            UIApplication.sharedApplication().openURL(NSURL(string:
                requestString)!)
        } else {
            print("Can't use comgooglemaps://");
        }
    }
    
    func copyToClipBoard(alertAction: UIAlertAction!) -> Void {
        UIPasteboard.generalPasteboard().string = self.address
    }
    
    func cancelNavigation(alertAction: UIAlertAction!) {
        
    }
    
    @IBAction func showAllReviews(sender: AnyObject) {
        performSegueWithIdentifier("showReviews", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        animateTransition = false
    }
    

    @IBAction func call(sender: AnyObject) {
        TrackingUtil.trackPhoneCallUsed()
        let alert = UIAlertController(title: "呼叫", message: "\(self.phone)", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let doCallAction = UIAlertAction(title: "确定", style: .Default, handler: { (action) -> Void in
            let phoneNumber = self.extractPhoneNumber(self.phone)
            if let url = NSURL(string: "tel://\(phoneNumber)") {
                UIApplication.sharedApplication().openURL(url)
            }
        })
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        
        alert.addAction(doCallAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    func extractPhoneNumber(originalNumber : String?) -> String{
        if originalNumber == nil {
            return ""
        }
        let stringArray = originalNumber!.componentsSeparatedByCharactersInSet(
            NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        let newString = stringArray.joinWithSeparator("")
        return newString
    }
    // MARK: - Table view data source
    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return imagePool.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: RestaurantImagePoolCollectionViewCell? = imagePoolView.dequeueReusableCellWithReuseIdentifier("restaurantImagePoolCell", forIndexPath: indexPath) as? RestaurantImagePoolCollectionViewCell
        
        // Configure the cell
        if indexPath.row < imagePool.count {
            cell!.setUp(image: imagePoolContent[indexPath.row].image!)
        } else {
            cell!.setUpAddingImageCell()
        }
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == imagePool.count {
//            let imagePickerController = ImagePickerController()
//            imagePickerController.delegate = self
//            self.presentViewController(imagePickerController, animated: true, completion: nil)
            let alert = UIAlertController(title: "选择图片来源", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            let albumAction = UIAlertAction(title: "相册", style: .Default, handler: self.goToAlbum)
            let cameraAction = UIAlertAction(title: "拍摄", style: .Default, handler: self.goToCamera)
            let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: self.cancelNavigation)
            
            alert.addAction(albumAction)
            alert.addAction(cameraAction)
            alert.addAction(cancelAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
//            let photoGallery = PhotoGalleryViewController()
//            photoGallery.parentVC = self
//            photoGallery.currentIndexPath = indexPath
//            self.presentViewController(photoGallery, animated: false, completion: nil)
            var images = [SKPhoto]()
            for imageView in imagePoolContent {
                let photo = SKPhoto.photoWithImage(imageView.image!)// add some UIImage
                images.append(photo)
            }
            let browser = SKPhotoBrowser(photos: images)
            browser.initializePageIndex(indexPath.row)
            presentViewController(browser, animated: true, completion: {})
        }
    }
    
    // MARK: Photo selection
    func goToAlbum(alertAction: UIAlertAction!) -> Void {
        let pickerController = DKImagePickerController()
        pickerController.singleSelect = false
        pickerController.maxSelectableCount = 10
        pickerController.assetType = DKImagePickerControllerAssetType.AllPhotos
        pickerController.sourceType = DKImagePickerControllerSourceType.Photo
        pickerController.allowMultipleTypes = false
        pickerController.allowsLandscape = false
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            self.processSelectedPhotosFromPhotoLibrary(assets)
        }
        self.presentViewController(pickerController, animated: true) {}
    }
    
    func goToCamera(alertAction: UIAlertAction!) -> Void {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func processSelectedPhotosFromPhotoLibrary(assets: [DKAsset]) {
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
    func wrapperDidPress(imagePicker: ImagePickerController, images: [UIImage]){
        
    }
    func doneButtonDidPress(imagePicker: ImagePickerController, images: [UIImage]){
        uploadImages(images)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func uploadImages(images: [UIImage]) {
        showUploadingAlert()
        let queue = NSOperationQueue()
        
        for image in images {
            queue.addOperationWithBlock() {
                let maxLength = 500000
                var imageData = UIImageJPEGRepresentation(image, 1.0) //1.0 is compression ratio
                if imageData?.length > maxLength {
                    let compressionRatio: CGFloat = CGFloat(maxLength) / CGFloat((imageData?.length)!)
                    imageData = UIImageJPEGRepresentation(image, compressionRatio)
                }
                
                let base64_code: String = (imageData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength))!
                let request: UploadRestaurantPictureRequest = UploadRestaurantPictureRequest(restaurantId: self.restaurantId!, type: "restaurant", base64_code: base64_code)
                DataAccessor(serviceConfiguration: ParseConfiguration()).uploadRestaurantPicture(request) { (response) -> Void in
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        //add actions here
                        print("done");
                        self.imagePool.append((response?.result)!)
                        self.downloadNewAddedImage((response?.result)!)
                    });
                }
            }
        }
    }
    
    func showUploadingAlert() {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false, showCircularIcon: true, kCircleIconHeight: 40)
        uploadingAlertView = SCLAlertView(appearance: appearance)
        uploadingAlertView!.duration = 2.0
        let alertViewIcon = UIImage(named: "LogoWithBorder")
        uploadingAlertView!.addButton("隐藏", backgroundColor: UIColor.themeOrange(), showDurationStatus: true, target:self, selector:#selector(RestaurantMainTableViewController.hideAlertView))
        uploadingAlertView!.showInfo("正在上传图片", subTitle: "正在后台上传，请稍等...", duration: 5.0, circleIconImage: alertViewIcon, colorStyle: UIColor.themeOrange().getColorCode())
    }
    
    func hideAlertView() {
        if uploadingAlertView != nil {
            uploadingAlertView?.hideView()
            uploadingAlertView = nil
        }
        
    }
    
    func cancelButtonDidPress(imagePicker: ImagePickerController){
        
    }
    
    // MARK: - ScrollView
    override func scrollViewDidScroll(scrollView: UIScrollView) {
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
    
    private func updateHeaderView(){
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
        imageView.userInteractionEnabled = false
        imageView.frame = CGRectMake(0.0, 0.0, self.tableView.frame.width, 314.0)
        return imageView
    }
    
    func presentationBeforeAction() {
        backgroundImageView.hidden = true
    }
    
    func presentationCompletionAction(completeTransition: Bool) {
        backgroundImageView.hidden = false
    }
    
    func dismissalBeforeAction() {
        backgroundImageView.hidden = true
    }
    
    func dismissalCompletionAction(completeTransition: Bool) {
        if !completeTransition {
            backgroundImageView.hidden = false
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
