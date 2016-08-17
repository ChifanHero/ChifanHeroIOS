//
//  RestaurantMainTableViewController.swift
//  Lightning
//
//  Created by Shi Yan on 8/15/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit
import MapKit

class RestaurantMainTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, ImagePickerDelegate, ARNImageTransitionZoomable, ARNImageTransitionIdentifiable {
    
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    
    @IBOutlet weak var recommendationDishLabel: UILabel!
    
    
    @IBOutlet weak var imagePoolView: UICollectionView!
    
    
    @IBOutlet weak var actionPanelView: ActionPanelView!
    
    var localSearchResponse:MKLocalSearchResponse!
    
    var restaurantId: String? {
        didSet {
            request = GetRestaurantByIdRequest(id: restaurantId!)
        }
    }
    
    var request: GetRestaurantByIdRequest?
    
    var restaurant: Restaurant?
    
    var restaurantImage: UIImage?
    var restaurantName: String?
    var address: String?
    var phone: String?
    var hotDishes: [Dish] = [Dish]()
    
    var imagePool: [Picture] = []
    
    let vcTitleLabel: UILabel = UILabel()
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var goButton: UIButton!
    
    @IBOutlet weak var callButton: UIButton!
    
    var animateTransition = true
    
    var parentVCName: String = ""
    
    let kTableHeaderHeight: CGFloat = 264.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addImageForBackBarButtonItem()
        self.tableView.showsVerticalScrollIndicator = false
        loadData { (success) -> Void in
            if !success {
                //                self.noNetworkDefaultView.show()
            }
        }
        backgroundImageView.image = restaurantImage
        
        nameLabel.text = restaurantName
        loadImagePool()
        actionPanelView.baseVC = self
        self.configureButtons()
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
        if self.tableView.tableHeaderView != nil {
            headerView = self.tableView.tableHeaderView
            self.tableView.tableHeaderView = nil
            self.tableView.addSubview(headerView)
            self.tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
            self.tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)
            updateHeaderView()
        }
        
//        print(backgroundImageView.superview!.convertRect(backgroundImageView.frame, toView: self.view))
    }
    
//    override func viewDidLayoutSubviews() {
//        if let rect = self.navigationController?.navigationBar.frame {
//            let y = rect.size.height + rect.origin.y
//            self.tableView.contentInset = UIEdgeInsetsMake(y, 0, 0, 0)
//        }
//    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if self.tabBarController?.tabBar.hidden == true {
            showTabbarSmoothly()
        }
        self.animateTransition = true
        configVCTitle()
        self.configureHeaderView()
        TrackingUtil.trackRestaurantView()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Data
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
                                self.actionPanelView.restaurantId = self.restaurant?.id
                                
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
                                if self.restaurant?.likeCount != nil {
                                    self.actionPanelView.likeCount = self.restaurant?.likeCount
                                }
                                if self.restaurant?.dislikeCount != nil {
                                    self.actionPanelView.dislikeCount = self.restaurant?.dislikeCount
                                }
                                if self.restaurant?.neutralCount != nil {
                                    self.actionPanelView.neutralCount = self.restaurant?.neutralCount
                                }
                                if self.restaurant?.favoriteCount != nil {
                                    self.actionPanelView.favoriteCount = self.restaurant?.favoriteCount
                                }
                                if self.restaurant?.hotDishes != nil && self.restaurant?.hotDishes!.count != 0 {
                                    self.recommendationDishLabel.text = ""
                                    for index in 0..<10 {
                                        self.recommendationDishLabel.text?.appendContentsOf((self.restaurant?.hotDishes![index].name)!)
                                        self.recommendationDishLabel.text?.appendContentsOf("  ")
                                    }
                                }
                            }
                            
                        } else {
                            self.actionPanelView.hidden = true
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

    @IBAction func call(sender: AnyObject) {
        TrackingUtil.trackPhoneCallUsed()
        let alert = UIAlertController(title: "呼叫", message: "呼叫\(self.phone)", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
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
//        imageView.frame = backgroundImageView.superview!.convertRect(backgroundImageView.frame, toView: self.view)
//        print(backgroundImageView.superview!.convertRect(backgroundImageView.frame, toView: self.view))
        imageView.frame = CGRectMake(0.0, 0.0, 414.0, 264.0)
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


    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
