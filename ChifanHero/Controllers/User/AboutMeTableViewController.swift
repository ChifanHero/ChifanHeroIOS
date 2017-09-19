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
    
    // Sections
    let PROFILE_IMAGE_SECTION = 0 // Profile Image Section
    let INFO_SECTION = 1 // Information Section
    let LOGOUT_SECTION = 2 // Logout Section
    
    // PROFILE_IMAGE_SECTION Rows
    let PROFILE_IMAGE_ROW = 0
    
    // INFO_SECTION Rows
    let NICKNAME_ROW = 0
    let USERNAME_ROW = 1
    let PASSWORD_ROW = 2
    let EMAIL_ROW = 3
    
    // LOGOUT_SECTION Rows
    let LOGOUT_ROW = 0
    
    // Flags
    var isUsingDefaultUsername = false
    var isUsingDefaultPasword = false
    var isEmailVerified = false
    var isUsingDefaultNickname = false
    
    // Facts
    var nickName: String?
    var userName: String?
    var email: String?
    var defaultPassword: String?
    

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    
    var updatingUserInfo = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearTitleForBackBarButtonItem()
        setUserProfileImageProperty()
//        addNotificationButton()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMyInfo()
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
        let button: UIButton = ButtonUtil.barButtonWithTextAndBorder("消息", size: CGRect(x: 0, y: 0, width: 80, height: 26))
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
    
    private func loadMyInfo(){
        if (!updatingUserInfo) {
            AccountManager(serviceConfiguration: ParseConfiguration()).getMyInfo { (response) in
                if let errorCode = response?.error?.code {
                    AlertUtil.showErrorAlert(errorCode: errorCode, target: self, buttonAction: #selector(self.doNothing))
                    if errorCode == ErrorCode.INVALID_SESSION_TOKEN {
                        self.logOut()
                    }
                }
                
                if let user = response?.user {
                    if user.nickName != nil {
                        self.nickName = user.nickName
                        self.nickNameLabel.text = user.nickName
                    } else {
                        self.nickNameLabel.text = "未指定昵称"
                    }
                    
                    if user.email != nil && user.emailVerified == true{
                        self.email = user.email
                        self.emailLabel.text = user.email
                    } else {
                        self.emailLabel.text = "未绑定邮箱"
                    }
                    
                    if user.userName != nil {
                        self.userName = user.userName
                        self.usernameLabel.text = user.userName
                    } else {
                        self.usernameLabel.text = "未指定用户名"
                    }
                    if (user.emailVerified != nil) {
                        self.isEmailVerified = user.emailVerified!
                    }
                    if (user.usingDefaultNickname != nil) {
                        self.isUsingDefaultNickname = user.usingDefaultNickname!
                    } else {
                        self.isUsingDefaultNickname = false
                    }
                    if (user.usingDefaultPassword != nil) {
                        self.isUsingDefaultPasword = user.usingDefaultPassword!
                    } else {
                        self.isUsingDefaultNickname = false
                    }
                    if (user.usingDefaultUsername != nil) {
                        self.isUsingDefaultUsername = user.usingDefaultUsername!
                    } else {
                        self.isUsingDefaultUsername = false
                    }
                    
                    self.passwordLabel.text = "修改密码"
    
                    
                    if let userPicURL = user.picture?.thumbnail {
                        self.userImageView.kf.setImage(with: URL(string: userPicURL)!, placeholder: nil, options: [.transition(ImageTransition.fade(0.5))])
                    }
                    
                }
            }
        }
    }
    
    private func loadUserPicture(){
//        let defaults = UserDefaults.standard
//        
//        if let userPicURL = defaults.string(forKey: "userPicURL"){
//            print(userPicURL)
//            userImageView.kf.setImage(with: URL(string: userPicURL)!, placeholder: nil, options: [.transition(ImageTransition.fade(0.5))])
//        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if indexPath.section == PROFILE_IMAGE_SECTION && indexPath.row == PROFILE_IMAGE_ROW {
            self.popUpImageSourceOption()
        } else if indexPath.section == INFO_SECTION {
            if indexPath.row == NICKNAME_ROW {
                self.performSegue(withIdentifier: "showNickNameChange", sender: indexPath)
            } else if indexPath.row == USERNAME_ROW {
                self.performSegue(withIdentifier: "showUserNameChange", sender: indexPath)
            } else if indexPath.row == PASSWORD_ROW {
                self.performSegue(withIdentifier: "showPassword", sender: indexPath)
            } else if indexPath.row == EMAIL_ROW {
                self.performSegue(withIdentifier: "showEmail", sender: indexPath)
            }
        } else if indexPath.section == LOGOUT_SECTION {
            self.logOutAction()
        }
            
        // TODO: Add favorites in later version
        /*
        else if indexPath.section == 2 {
            if indexPath.row == 0 {
                showRestaurants()
            } else if indexPath.row == 1 {
                showSelectedCollection()
            }
            
        } */
        //make table cell not stay highlighted
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func showRestaurants() {
    }
    
    func showSelectedCollection() {
        let storyboard = UIStoryboard(name: "Collection", bundle: nil)
        let collectionsController = storyboard.instantiateViewController(withIdentifier: "selectedCollection") as! SelectedCollectionsTableViewController
        self.navigationController?.pushViewController(collectionsController, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNickNameChange" {
            let destinationVC = segue.destination as! ChangeNicknameTableViewController
            destinationVC.nickName = nickName
        } else if segue.identifier == "showUserNameChange" {
            let destinationVC = segue.destination as! ChangeUsernameTableViewController
            destinationVC.username = userName
            
        } else if segue.identifier == "showPassword" {
            let destinationVC = segue.destination as! ChangePasswordTableViewController
            if isUsingDefaultPasword {
                destinationVC.isUsingDefaultPassword = true
            }
        } else {
            // do nothing
        }
    }
    
    private func popUpImageSourceOption(){
        let alert = UIAlertController(title: "设置头像", message: "请选择图片来源", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let takePhotoAction = UIAlertAction(title: "拍照上传", style: .default, handler: self.takePhotoFromCamera)
        let chooseFromPhotosAction = UIAlertAction(title: "从相册中选择", style: .default, handler: self.chooseFromPhotoRoll)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: self.cancelChoosingImage)
        
        alert.addAction(takePhotoAction)
        alert.addAction(chooseFromPhotosAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func takePhotoFromCamera(_ alertAction: UIAlertAction!) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func chooseFromPhotoRoll(_ alertAction: UIAlertAction!) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func cancelChoosingImage(_ alertAction: UIAlertAction!) {
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            userImageView.image = image
            self.uploadPicture(image: image)
        } else if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            userImageView.image = image
            self.uploadPicture(image: image)
        } else{
            print("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil);
        
    }
    
    private func uploadPicture(image: UIImage) {
        updatingUserInfo = true
        let newPhoto = ImageUtil.resizeImage(image: image)
        let imageData = UIImageJPEGRepresentation(newPhoto, 0.5) // 0.5 is compression ratio
        let base64_code: String = (imageData?.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters))!
        let request: UploadPictureRequest = UploadPictureRequest(base64_code: base64_code)
        DataAccessor(serviceConfiguration: ParseConfiguration()).uploadPicture(request) { (response) -> Void in
            OperationQueue.main.addOperation({ () -> Void in
                let defaults: UserDefaults = UserDefaults.standard
                defaults.set(response!.result?.thumbnail, forKey: "userPicURL")
                
                if response?.result != nil{
                    AccountManager(serviceConfiguration: ParseConfiguration()).updateInfo(nickName: nil, pictureId: response?.result?.id) { (response) -> Void in
                        OperationQueue.main.addOperation({ () -> Void in
                            self.updatingUserInfo = false
                            if response == nil {
                                AlertUtil.showGeneralErrorAlert(target: self, buttonAction: #selector(self.doNothing))
                            } else if response!.success == true {
                                log.info("Update profile picture succeed")
                                if let userPicURL = response?.user?.picture?.thumbnail {
                                    self.userImageView.kf.setImage(with: URL(string: userPicURL)!, placeholder: nil, options: [.transition(ImageTransition.fade(0.5))])
                                }
                            } else if response!.error?.code != nil {
                                AlertUtil.showErrorAlert(errorCode: response?.error?.code, target: self, buttonAction: #selector(self.doNothing))
                                if response?.error?.code != nil && response?.error?.code == ErrorCode.INVALID_SESSION_TOKEN {
                                    self.logOut()
                                }
                            } else {
                                AlertUtil.showGeneralErrorAlert(target: self, buttonAction: #selector(self.doNothing))
                            }
                        })
                        
                    }
                } else {
                    self.updatingUserInfo = false
                }
                
            });
        }
    }
    
    private func logOutAction(){
        let alert = UIAlertController(title: "退出登录", message: getLogoutActionMessage(), preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let confirmAction = UIAlertAction(title: "确认", style: .default, handler: self.confirmLogOut)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: self.cancelLogOut)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func getLogoutActionMessage() -> String {
        if isUsingDefaultUsername && isUsingDefaultPasword && !isEmailVerified { //000
            return "您仍然在使用临时用户名和密码且未绑定邮箱。请记住临时用户名和密码，否则退出后账户将永久丢失"
        } else if isUsingDefaultUsername && isUsingDefaultPasword && isEmailVerified { //001
            return "您仍然在使用临时用户名和密码。再次登录时请使用邮箱和临时密码。如忘记临时密码，请通过密码找回重设密码"
        } else if isUsingDefaultUsername && !isUsingDefaultPasword && !isEmailVerified { //010
            return "您仍然在使用临时用户名且未绑定邮箱。请记住临时用户名，否则退出后账户将永久丢失"
        } else if isUsingDefaultUsername && !isUsingDefaultPasword && isEmailVerified {//011
            return "您仍然在使用临时用户名。如忘记临时用户名可通过您的邮箱登录"
        } else if !isUsingDefaultUsername && isUsingDefaultPasword && !isEmailVerified {//100
            return "您仍未绑定邮箱且未修改临时密码。如忘记密码则将无法找回"
        } else if !isUsingDefaultUsername && isUsingDefaultPasword && isEmailVerified { //101
            return "您仍未修改临时密码。如忘记密码，请通过密码找回重设密码"
        } else if !isUsingDefaultUsername && !isUsingDefaultPasword && !isEmailVerified { //110
            return "您仍未绑定邮箱。如忘记密码则将无法找回"
        } else {
            return "登出当前用户"
        }
        
    }
    
    private func confirmLogOut(_ alertAction: UIAlertAction!) {
        self.replaceAboutMeViewByLogInView()
        AccountManager(serviceConfiguration: ParseConfiguration()).logOut() { (success) -> Void in
            OperationQueue.main.addOperation({ () -> Void in
                // do nothing for now
            })
            
        }
    }
    
    private func logOut() {
        self.replaceAboutMeViewByLogInView()
        AccountManager(serviceConfiguration: ParseConfiguration()).logOut() { (success) -> Void in
            OperationQueue.main.addOperation({ () -> Void in
                // do nothing for now
            })
            
        }
    }
    
    private func cancelLogOut(_ alertAction: UIAlertAction!) {
        
    }
    
    private func replaceAboutMeViewByLogInView(){
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
    
    private func getLogInNavigationController() -> UINavigationController{
        let storyBoard : UIStoryboard = UIStoryboard(name: "User", bundle: nil)
        let logInNC : UINavigationController = storyBoard.instantiateViewController(withIdentifier: "LogInNavigationController") as! UINavigationController
        logInNC.tabBarItem = UITabBarItem(title: "个人", image: UIImage(named: "Me_Tab"), tag: 4)
        return logInNC
    }
    
    func doNothing() {
        
    }
    

}
