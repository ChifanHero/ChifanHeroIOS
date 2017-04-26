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
        addNotificationButton()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserNickName()
        self.navigationController?.navigationBar.isTranslucent = false
//        setTabBarVisible(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TrackingUtil.trackUserProfileView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func addNotificationButton() {
        let button: UIButton = UIButton.barButtonWithTextAndBorder("消息", size: CGRect(x: 0, y: 0, width: 80, height: 26))
        button.addTarget(self, action: #selector(AboutMeTableViewController.showNotification), for: UIControlEvents.touchUpInside)
        let notificationButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = notificationButton
    }
    
    func showNotification(){
        performSegue(withIdentifier: "showNotification", sender: nil)
    }
    
    fileprivate func setUserProfileImageProperty(){
        self.view.layoutIfNeeded()
        self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2
        self.userImageView.clipsToBounds = true
        self.userImageView.layer.borderWidth = 3.0
        self.userImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    fileprivate func loadUserNickName(){
        let defaults = UserDefaults.standard
        
        if let nickname = defaults.string(forKey: "userNickName"){
            nickNameLabel.text = nickname
        } else{
            nickNameLabel.text = "未设定"
        }
        
    }
    
    fileprivate func loadUserPicture(){
        let defaults = UserDefaults.standard
        
        if let userPicURL = defaults.string(forKey: "userPicURL"){
            userImageView.image = UIImage(data: try! Data(contentsOf: URL(string: userPicURL)!))
            userImageView.kf.setImage(with: URL(string: userPicURL)!, placeholder: nil, options: [.transition(ImageTransition.fade(0.5))])
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if indexPath.section == 0 && indexPath.row == 0 {
            self.popUpImageSourceOption()
        } else if indexPath.section == 1 && indexPath.row == 0 {
            self.performSegue(withIdentifier: "showNickNameChange", sender: indexPath)
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                showRestaurants()
            } else if indexPath.row == 1 {
                showSelectedCollection()
            }
            
        } else {
            self.logOutAction()
        }
        //make table cell not stay highlighted
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func showRestaurants() {
        let storyboard = UIStoryboard(name: "RestaurantsAndSearch", bundle: nil)
        let restaurantsController = storyboard.instantiateViewController(withIdentifier: "RestaurantsOnlyViewController") as! RestaurantsOnlyViewController
        restaurantsController.isFromBookMark = true
        self.navigationController?.pushViewController(restaurantsController, animated: true)
    }
    
    func showSelectedCollection() {
        let storyboard = UIStoryboard(name: "Collection", bundle: nil)
        let collectionsController = storyboard.instantiateViewController(withIdentifier: "selectedCollection") as! SelectedCollectionsTableViewController
        collectionsController.isFromBookMark = true
        self.navigationController?.pushViewController(collectionsController, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "showNickNameChange" {
            let destinationVC = segue.destination as! NickNameChangeViewController
            destinationVC.nickName = self.nickNameLabel.text
        }
    }
    
    fileprivate func popUpImageSourceOption(){
        let alert = UIAlertController(title: "更换头像", message: "选取图片来源", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let takePhotoAction = UIAlertAction(title: "相机", style: .default, handler: self.takePhotoFromCamera)
        let chooseFromPhotosAction = UIAlertAction(title: "照片", style: .default, handler: self.chooseFromPhotoRoll)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: self.cancelChoosingImage)
        
        alert.addAction(takePhotoAction)
        alert.addAction(chooseFromPhotosAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func takePhotoFromCamera(_ alertAction: UIAlertAction!) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    fileprivate func chooseFromPhotoRoll(_ alertAction: UIAlertAction!) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    fileprivate func cancelChoosingImage(_ alertAction: UIAlertAction!) {
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        userImageView.image = image
        self.dismiss(animated: true, completion: nil);
        
        let imageData = UIImageJPEGRepresentation(image, 0.1) //0.1 is compression ratio
        let base64_code: String = (imageData?.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters))!
        let request : UploadPictureRequest = UploadPictureRequest(base64_code: base64_code)
        DataAccessor(serviceConfiguration: ParseConfiguration()).uploadPicture(request) { (response) -> Void in
            OperationQueue.main.addOperation({ () -> Void in
                
                if response?.result != nil{
                    AccountManager(serviceConfiguration: ParseConfiguration()).updateInfo(nickName: nil, pictureId: response?.result?.id) { (response) -> Void in
                        OperationQueue.main.addOperation({ () -> Void in
                            if response!.success == true {
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
    
    fileprivate func logOutAction(){
        let alert = UIAlertController(title: "退出登录", message: "登出当前用户", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let confirmAction = UIAlertAction(title: "确认", style: .default, handler: self.confirmLogOut)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: self.cancelLogOut)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func confirmLogOut(_ alertAction: UIAlertAction!) {
        let defaults : UserDefaults = UserDefaults.standard
        defaults.set(false, forKey: "isLoggedIn")
        self.replaceAboutMeViewByLogInView()
        AccountManager(serviceConfiguration: ParseConfiguration()).logOut() { (success) -> Void in
            OperationQueue.main.addOperation({ () -> Void in
                // do nothing for now
            })
            
        }
    }
    
    fileprivate func cancelLogOut(_ alertAction: UIAlertAction!) {
        
    }
    
    fileprivate func replaceAboutMeViewByLogInView(){
        let tabBarController : UITabBarController = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
        var viewControllers = tabBarController.viewControllers!
        for index in 0 ..< viewControllers.count {
            let vc : UIViewController = viewControllers[index]
            if vc.restorationIdentifier == "AboutMeNavigationController" {
                viewControllers.remove(at: index)
                let logInNC = getLogInNavigationController()
                viewControllers.insert(logInNC, at: index)
                break
            }
        }
        tabBarController.setViewControllers(viewControllers, animated: false)
    }
    
    fileprivate func getLogInNavigationController() -> UINavigationController{
        let storyBoard : UIStoryboard = UIStoryboard(name: "User", bundle: nil)
        let logInNC : UINavigationController = storyBoard.instantiateViewController(withIdentifier: "LogInNavigationController") as! UINavigationController
        logInNC.tabBarItem = UITabBarItem(title: "个人", image: UIImage(named: "Me_Tab"), tag: 4)
        return logInNC
    }
    

}
