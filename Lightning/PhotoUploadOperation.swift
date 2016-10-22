//
//  FileUploader.swift
//  Lightning
//
//  Created by Shi Yan on 10/15/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class PhotoUploadOperation: AsynchronousOperation {
    
    private var success = false
    
    private var photo: UIImage?
    
    private var retryTimes = 0
    
    private var uploaded: Picture?
    
    init(photo : UIImage, retryTimes: Int, completion: (Bool, Picture?) -> Void) {
        super.init()
        self.photo = photo
        self.retryTimes = retryTimes
        self.completionBlock = {
            if self.cancelled {
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
        let maxLength = 100000 // 100KB
        var imageData = UIImageJPEGRepresentation(photo!, 1.0) //1.0 is compression ratio
        if imageData?.length > maxLength {
            let compressionRatio: CGFloat = CGFloat(maxLength) / CGFloat((imageData?.length)!)
            imageData = UIImageJPEGRepresentation(photo!, compressionRatio)
        }
        let base64_code: String = (imageData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength))!
        let request : UploadPictureRequest = UploadPictureRequest(base64_code: base64_code)
        DataAccessor(serviceConfiguration: ParseConfiguration()).uploadPicture(request) { (response) -> Void in
            if self.cancelled {
                self.state = .Finished
            } else {
                if response != nil && response?.result != nil {
                    self.uploaded = response!.result
                } else {
                    if self.retryTimes > 0 {
                        self.retryTimes = self.retryTimes - 1
                        self.upload()
                    }
                }
                self.state = .Finished
            }
            
        }
    }
    
}
