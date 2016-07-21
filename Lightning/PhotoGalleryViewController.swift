//
//  PhotoGalleryViewController.swift
//  Lightning
//
//  Created by Zhang, Alex on 7/21/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class PhotoGalleryViewController: UIViewController {

    var currentImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.configureImageView()
        self.configureBackButton()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureImageView(){
        let imageView = UIImageView(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: 400))
        imageView.image = currentImage
        self.view.addSubview(imageView)
    }
    
    private func configureBackButton(){
        let backButton = UIButton(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        backButton.backgroundColor = UIColor.whiteColor()
        backButton.setImage(UIImage(named: "Cancel_Button"), forState: .Normal)
        backButton.addTarget(self, action: #selector(self.backButtonAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(backButton)
    }
    
    func backButtonAction(){
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
