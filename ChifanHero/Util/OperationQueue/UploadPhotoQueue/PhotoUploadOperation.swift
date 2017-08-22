//
//  FileUploader.swift
//  Lightning
//
//  Created by Shi Yan on 10/15/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class PhotoUploadOperation: RetryableOperation {
    
    private var success = false
    
    private var photo: UIImage?
    
    private var restaurantId: String?
    
    private var reviewId: String?
    
    private var retryTimes = 0
    
    private var uploaded: Picture?
    
    init(photo: UIImage, restaurantId: String, reviewId: String, retryTimes: Int, completion: @escaping (Bool, Picture?) -> Void) {
        super.init()
        self.photo = photo
        self.restaurantId = restaurantId
        self.reviewId = reviewId
        self.retryTimes = retryTimes
        self.completionBlock = {
            if self.isCancelled {
                completion(false, nil)
            } else {
                completion(self.success, self.uploaded)
            }
        }
    }
    
    override func main() {
        upload()
    }
    
    private func upload() {
        let newPhoto = ImageUtil.resizeImage(image: photo!)
        let imageData = UIImageJPEGRepresentation(newPhoto, 0.5) // 0.5 is compression ratio
        let base64_code: String = (imageData?.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters))!
        let request: UploadPictureRequest = UploadPictureRequest(base64_code: base64_code)
        request.restaurantId = self.restaurantId
        request.reviewId = self.reviewId
        
        DataAccessor(serviceConfiguration: ParseConfiguration()).uploadPicture(request) { (response) -> Void in
            if self.isCancelled { // isCancelled == true and isFinished == true
                self.state = .finished
            } else {
                if response != nil && response?.result != nil && response?.result?.id != nil{
                    self.uploaded = response!.result
                    self.success = true
                } else {
                    if self.retryTimes > 0 {
                        self.retryTimes = self.retryTimes - 1
                        self.upload()
                    }
                }
                self.state = .finished
            }
        }
    }
    
}
