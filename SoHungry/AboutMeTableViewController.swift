//
//  AboutMeTableViewController.swift
//  SoHungry
//
//  Created by Zhang, Alex on 11/9/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class AboutMeTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var favoriteCuisineTypeLabel: UILabel!
    @IBOutlet weak var userLevelLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserInfo()
        setUserProfileImageProperty()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setUserProfileImageProperty(){
        self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2
        self.userImageView.clipsToBounds = true
        self.userImageView.layer.borderWidth = 3.0
        self.userImageView.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    private func loadUserInfo(){
        let defaults = NSUserDefaults.standardUserDefaults()
        
        favoriteCuisineTypeLabel.hidden = true
        
        if let userPicURL = defaults.stringForKey("userPicURL"){
            userImageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: userPicURL)!)!)
        }
        
        if let nickname = defaults.stringForKey("userNickName"){
            nickNameLabel.text = nickname
        } else{
            nickNameLabel.text = "未设定"
        }
        
        if let userLevel = defaults.stringForKey("userLevel"){
            userLevelLabel.text = userLevel
        } else{
            userLevelLabel.text = "1"
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if indexPath.section == 0 && indexPath.row == 0 {
            self.popUpImageSourceOption()
        } else if indexPath.section == 1 && indexPath.row == 0 {
            self.performSegueWithIdentifier("showNickNameChange", sender: indexPath)
        } else if indexPath.section == 2 && indexPath.row == 0 {
            
        } else {
            self.performSegueWithIdentifier("showAboutMeDetail", sender: indexPath)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender!.section == 1 && sender!.row == 1 {
            let destinationVC = segue.destinationViewController as! AboutMeDetailTableViewController
            //destinationVC.detailType = "favoriteCuisineType"
        } else if sender!.section == 3 && sender!.row == 0 {
            let destinationVC = segue.destinationViewController as! AboutMeDetailTableViewController
            destinationVC.detailType = FavoriteTypeEnum.Dish
        } else if sender!.section == 3 && sender!.row == 1 {
            let destinationVC = segue.destinationViewController as! AboutMeDetailTableViewController
            destinationVC.detailType = FavoriteTypeEnum.Restaurant
        } else if sender!.section == 3 && sender!.row == 2 {
            let destinationVC = segue.destinationViewController as! AboutMeDetailTableViewController
            destinationVC.detailType = FavoriteTypeEnum.List
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
            imagePicker.allowsEditing = false
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
        
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        let base64_code: String = (imageData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength))!
        let request : UploadPictureRequest = UploadPictureRequest(base64_code: base64_code)
        DataAccessor(serviceConfiguration: ParseConfiguration()).uploadPicture(request) { (response) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                
            });
        }
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

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
