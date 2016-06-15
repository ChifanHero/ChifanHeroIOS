//
//  AboutMeTableViewController.swift
//  SoHungry
//
//  Created by Zhang, Alex on 11/9/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit
import Kingfisher
import Flurry_iOS_SDK

class AboutMeTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearTitleForBackBarButtonItem()
        loadUserNickName()
        loadUserPicture()
        setUserProfileImageProperty()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadUserNickName()
        self.navigationController?.navigationBar.translucent = false
        setTabBarVisible(true, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        TrackingUtil.trackUserProfileView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func clearTitleForBackBarButtonItem(){
        let barButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = barButtonItem
    }
    
    private func setUserProfileImageProperty(){
        self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2
        self.userImageView.clipsToBounds = true
        self.userImageView.layer.borderWidth = 3.0
        self.userImageView.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    private func loadUserNickName(){
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let nickname = defaults.stringForKey("userNickName"){
            nickNameLabel.text = nickname
        } else{
            nickNameLabel.text = "未设定"
        }
        
    }
    
    private func loadUserPicture(){
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let userPicURL = defaults.stringForKey("userPicURL"){
//            userImageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: userPicURL)!)!)
            userImageView.kf_setImageWithURL(NSURL(string: userPicURL)!, placeholderImage: nil, optionsInfo: [.Transition(ImageTransition.Fade(0.5))])
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if indexPath.section == 0 && indexPath.row == 0 {
            self.popUpImageSourceOption()
        } else if indexPath.section == 1 && indexPath.row == 0 {
            self.performSegueWithIdentifier("showNickNameChange", sender: indexPath)
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                self.performSegueWithIdentifier("showRestaurants", sender: indexPath)
            } else if indexPath.row == 1 {
                self.performSegueWithIdentifier("showSelectedCollection", sender: indexPath)
            }
            
        } else {
            self.logOutAction()
        }
        //make table cell not stay highlighted
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRestaurants" {
            let destinationVC = segue.destinationViewController as! RestaurantsViewController
            destinationVC.isFromBookMark = true
        } else if segue.identifier == "showSelectedCollection" {
            let destinationVC = segue.destinationViewController as! SelectedCollectionsTableViewController
            destinationVC.isFromBookMark = true
        } else if segue.identifier == "showNickNameChange" {
            let destinationVC = segue.destinationViewController as! NickNameChangeViewController
            destinationVC.nickName = self.nickNameLabel.text
        }
    }
    
    private func popUpImageSourceOption(){
        let alert = UIAlertController(title: "更换头像", message: "选取图片来源", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let takePhotoAction = UIAlertAction(title: "相机", style: .Default, handler: self.takePhotoFromCamera)
        let chooseFromPhotosAction = UIAlertAction(title: "照片", style: .Default, handler: self.chooseFromPhotoRoll)
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: self.cancelChoosingImage)
        
        alert.addAction(takePhotoAction)
        alert.addAction(chooseFromPhotosAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func takePhotoFromCamera(alertAction: UIAlertAction!) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func chooseFromPhotoRoll(alertAction: UIAlertAction!) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func cancelChoosingImage(alertAction: UIAlertAction!) {
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        userImageView.image = image
        self.dismissViewControllerAnimated(true, completion: nil);
        
        let imageData = UIImageJPEGRepresentation(image, 0.1) //0.1 is compression ratio
        let base64_code: String = (imageData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength))!
        let request : UploadPictureRequest = UploadPictureRequest(base64_code: base64_code)
        DataAccessor(serviceConfiguration: ParseConfiguration()).uploadPicture(request) { (response) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                
                if response?.result != nil{
                    AccountManager(serviceConfiguration: ParseConfiguration()).updateInfo(nickName: nil, pictureId: response?.result?.id) { (success, user) -> Void in
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            if success == true {
                                print("Update profile picture succeed")
                            } else {
                                print("Update profile picture failed")
                            }
                        })
                        
                    }
                }
                
            });
        }
    }
    
    private func logOutAction(){
        let alert = UIAlertController(title: "退出登录", message: "登出当前用户", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let confirmAction = UIAlertAction(title: "确认", style: .Destructive, handler: self.confirmLogOut)
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: self.cancelLogOut)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func confirmLogOut(alertAction: UIAlertAction!) {
        let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(false, forKey: "isLoggedIn")
        self.replaceAboutMeViewByLogInView()
        AccountManager(serviceConfiguration: ParseConfiguration()).logOut() { (success) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                // do nothing for now
            })
            
        }
    }
    
    private func cancelLogOut(alertAction: UIAlertAction!) {
        
    }
    
    private func replaceAboutMeViewByLogInView(){
        let tabBarController : UITabBarController = UIApplication.sharedApplication().keyWindow?.rootViewController as! UITabBarController
        var viewControllers = tabBarController.viewControllers!
        for index in 0 ..< viewControllers.count {
            let vc : UIViewController = viewControllers[index]
            if vc.restorationIdentifier == "AboutMeNavigationController" {
                viewControllers.removeAtIndex(index)
                let logInNC = getLogInNavigationController()
                viewControllers.insert(logInNC, atIndex: index)
                break
            }
        }
        tabBarController.setViewControllers(viewControllers, animated: false)
    }
    
    private func getLogInNavigationController() -> UINavigationController{
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let logInNC : UINavigationController = storyBoard.instantiateViewControllerWithIdentifier("LogInNavigationController") as! UINavigationController
        logInNC.tabBarItem = UITabBarItem(title: "我的主页", image: UIImage(named: "AboutMe"), tag: 3)
        return logInNC
    }

}
