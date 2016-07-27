//
//  RestaurantViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 8/22/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import ARNTransitionAnimator
import Flurry_iOS_SDK

class RestaurantViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HeaderViewDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ARNImageTransitionZoomable, ARNImageTransitionIdentifiable, UICollectionViewDelegate, UICollectionViewDataSource, ImagePickerDelegate{

    
    @IBOutlet weak var containerScrollView: UIScrollView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var topViewContainer: ViewItemTopUIView!
    
    @IBOutlet weak var imagePoolView: UICollectionView!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var goButton: UIButton!
    
    @IBOutlet weak var callButton: UIButton!
    
    
    var restaurantId: String? {
        didSet {
            request = GetRestaurantByIdRequest(id: restaurantId!)
        }
    }
    
    var imagePool: [Picture] = []
    
    var restaurantImage: UIImage?
    
    var restaurantName: String?
    
    var request: GetRestaurantByIdRequest?
    
    var restaurant: Restaurant?
    
    var animateTransition = true
    
    var parentVCName: String = ""
    
    let vcTitleLabel: UILabel = UILabel()
    
    var address: String?
    var phone: String?
    
    var hotDishes: [Dish] = [Dish]()
    
    private let infoToResource: [String : String] = ["address" : "gps", "hours" : "clock", "phone" : "phone"]
    
    var localSearchResponse:MKLocalSearchResponse!
    
    var ratingAndFavoriteExecutor: RatingAndBookmarkExecutor?
    
    static let INFO_ROW_HEIGHT : CGFloat = 35
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addImageForBackBarButtonItem()
        self.containerScrollView.delegate = self
        self.containerScrollView.showsVerticalScrollIndicator = false
        loadData { (success) -> Void in
            if !success {
//                self.noNetworkDefaultView.show()
            }
        }
        loadImagePool()
        topViewContainer.baseVC = self
        self.backgroundImageView.image = restaurantImage
        topViewContainer.name = restaurantName
        ratingAndFavoriteExecutor = RatingAndBookmarkExecutor(baseVC: self)
        self.configureButtons()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.translucent = false
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if self.tabBarController?.tabBar.hidden == true {
            showTabbarSmoothly()
        }
        self.animateTransition = true
        configVCTitle()
        TrackingUtil.trackRestaurantView()
    }
    
    private func configureButtons(){
        self.goButton.layer.borderColor = UIColor(red: 49/255, green: 163/255, blue: 67/255, alpha: 1).CGColor
        self.goButton.layer.borderWidth = 1.0
        self.goButton.layer.cornerRadius = 3.0
        
        self.callButton.layer.borderColor = UIColor(red: 49/255, green: 163/255, blue: 67/255, alpha: 1).CGColor
        self.callButton.layer.borderWidth = 1.0
        self.callButton.layer.cornerRadius = 3.0
    }
    
    func showTabbarSmoothly() {
        self.tabBarController?.tabBar.alpha = 0
        self.tabBarController?.tabBar.hidden = false
        UIView.animateWithDuration(0.6) {
            self.tabBarController?.tabBar.alpha = 1
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
                                self.topViewContainer.restaurantId = self.restaurant?.id
                                if self.topViewContainer.name != nil {
                                    self.topViewContainer.name = self.restaurant?.name
                                }
                                self.topViewContainer.englishName = self.restaurant?.englishName
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
                                if self.restaurant?.likeCount != nil {
                                    self.topViewContainer.likeCount = self.restaurant?.likeCount
                                }
                                if self.restaurant?.dislikeCount != nil {
                                    self.topViewContainer.dislikeCount = self.restaurant?.dislikeCount
                                }
                                if self.restaurant?.neutralCount != nil {
                                    self.topViewContainer.neutralCount = self.restaurant?.neutralCount
                                }
                                if self.restaurant?.favoriteCount != nil {
                                    self.topViewContainer.bookmarkCount = self.restaurant?.favoriteCount
                                }
                                self.adjustUI()
                            }
                            
                        } else {
                            self.topViewContainer.hidden = true
                        }
                        if refreshHandler != nil {
                            refreshHandler!(success: true)
                        }
                        
                        
                    }
                    
                });
            }
        }
    }
    
    private func adjustUI() {
        adjustContainerViewHeight()
    }
    
    func refresh() {
        
    }
    
    func loadImagePool(){
        let request: GetImagesRequest = GetImagesRequest(restaurantId: restaurantId!)
        DataAccessor(serviceConfiguration: ParseConfiguration()).getImagesByRestaurantId(request) { (response) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.clearData()
                if (response != nil && response?.results != nil) {
                    for index in 0..<(response?.results)!.count {
                        self.imagePool.append((response?.results)![index])
                    }
                    self.imagePoolView.reloadData()
                }
            });
        }
    }
    
    private func clearData() {
        self.imagePool.removeAll()
    }
    
    private func adjustContainerViewHeight() {
//        var contentRect : CGRect = CGRectZero
//        for subView : UIView in self.containerScrollView.subviews {
//            if subView.hidden == false {
//                contentRect = CGRectUnion(contentRect, subView.frame)
//            }
//        }
//        self.containerScrollView.contentSize = CGSizeMake(self.view.frame.size.width, contentRect.height)
//        self.view.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    @IBAction func goAction(sender: AnyObject) {
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
    
    @IBAction func callAction(sender: AnyObject) {
        TrackingUtil.trackPhoneCallUsed()
        let alert = UIAlertController(title: "呼叫", message: "呼叫\(self.phone)", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let doCallAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Destructive, handler: { (action) -> Void in
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
    
    private func addToFavorites(indexPath: NSIndexPath){
        let dish = self.hotDishes[indexPath.row]
        ratingAndFavoriteExecutor?.addToFavorites("dish", objectId: dish.id!, failureHandler: { (objectId) -> Void in
            for dish : Dish in self.hotDishes {
                if dish.id == objectId {
                    if dish.favoriteCount != nil {
                        dish.favoriteCount! -= 1
                    }
                }
            }
        })
    }
    
    private func rateDish(indexPath: NSIndexPath, ratingType: RatingTypeEnum){
        let objectId: String? = self.hotDishes[indexPath.row].id
        let type = "dish"
        
        if ratingType == RatingTypeEnum.like {
            ratingAndFavoriteExecutor?.like(type, objectId: objectId!, failureHandler: { (objectId) -> Void in
                for dish : Dish in self.hotDishes {
                    if dish.id == objectId {
                        if dish.likeCount != nil {
                            dish.likeCount! -= 1
                        }
                    }
                }
            })
        } else if ratingType == RatingTypeEnum.dislike {
            ratingAndFavoriteExecutor?.dislike(type, objectId: objectId!,failureHandler: { (objectId) -> Void in
                for dish : Dish in self.hotDishes {
                    if dish.id == objectId {
                        if dish.dislikeCount != nil {
                            dish.dislikeCount! -= 1
                        }
                    }
                }
            })
        } else {
            ratingAndFavoriteExecutor?.neutral(type, objectId: objectId!,failureHandler: { (objectId) -> Void in
                for dish : Dish in self.hotDishes {
                    if dish.id == objectId {
                        if dish.neutralCount != nil {
                            dish.neutralCount! -= 1
                        }
                    }
                }
            })
        }
    }
    
    private func popupSigninAlert() {
        SCLAlertView().showWarning("请登录", subTitle: "登录享受更多便利")
    }
    
    private func dismissActionViewWithDelay() {
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(RestaurantViewController.dismissActionView), userInfo: nil, repeats: false)
    }
    
    @objc private func dismissActionView() {
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(RestaurantViewController.reloadTable), userInfo: nil, repeats: false)
    }
    
    @objc private func reloadTable() {
    }
    
    func headerViewActionButtonPressed() {
        self.performSegueWithIdentifier("showAllDishes", sender: self.restaurantId)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let barButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = barButtonItem
        if segue.identifier == "showAllDishes" {
            self.animateTransition = false
            let restaurantAllDishesController : RestaurantAllDishViewController = segue.destinationViewController as! RestaurantAllDishViewController
            restaurantAllDishesController.restaurantId = sender as? String
        }
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        adjustContainerViewHeight()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let nameLabelBottomY = self.topViewContainer.getNameLabelBottomY() + 200
        if offset > nameLabelBottomY{
            let scale = (abs(offset) - abs(nameLabelBottomY)) / 40
            self.navigationItem.titleView?.alpha = scale
        } else {
            self.navigationItem.titleView?.alpha = 0.0
        }
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
    
    // MARK: - ARNImageTransitionZoomable
    
    func createTransitionImageView() -> UIImageView {
        let imageView = UIImageView(image: self.backgroundImageView.image)
        imageView.contentMode = self.backgroundImageView.contentMode
        imageView.clipsToBounds = true
        imageView.userInteractionEnabled = false
        imageView.frame = backgroundImageView.superview!.convertRect(backgroundImageView.frame, toView: self.view)
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
        let cell: RestaurantImagePoolCollectionViewCell? = imagePoolView.dequeueReusableCellWithReuseIdentifier("imagePoolCell", forIndexPath: indexPath) as? RestaurantImagePoolCollectionViewCell
        
        // Configure the cell
        if indexPath.row < imagePool.count {
            cell!.setUp(image: imagePool[indexPath.row])
        } else {
            cell!.setUpAddingImageCell()
        }
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == imagePool.count {
            let imagePickerController = ImagePickerController()
            imagePickerController.delegate = self
            self.presentViewController(imagePickerController, animated: true, completion: nil)
        } else {
            let photoGallery = PhotoGalleryViewController()
            photoGallery.parentVC = self
            photoGallery.currentIndexPath = indexPath
            self.presentViewController(photoGallery, animated: false, completion: nil)
        }
    }
    
    //MARK: ImagePickerDelegate
    func wrapperDidPress(imagePicker: ImagePickerController, images: [UIImage]){
        
    }
    func doneButtonDidPress(imagePicker: ImagePickerController, images: [UIImage]){
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
                        self.imagePoolView.reloadData()
                    });
                }
            }
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func cancelButtonDidPress(imagePicker: ImagePickerController){
        
    }
    
    
}
