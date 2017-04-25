//
//  FileUploader.swift
//  Lightning
//
//  Created by Shi Yan on 10/15/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class PhotoUploadOperation: AsynchronousOperation {
    
    fileprivate var success = false
    
    fileprivate var photo: UIImage?
    
    fileprivate var retryTimes = 0
    
    fileprivate var uploaded: Picture?
    
    init(photo : UIImage, retryTimes: Int, completion: @escaping (Bool, Picture?) -> Void) {
        super.init()
        self.photo = photo
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
    
    fileprivate func upload() {
        let maxLength = 100000 // 100KB
        var imageData = UIImageJPEGRepresentation(photo!, 1.0) //1.0 is compression ratio
        if imageData?.count > maxLength {
            let compressionRatio: CGFloat = CGFloat(maxLength) / CGFloat((imageData?.count)!)
            imageData = UIImageJPEGRepresentation(photo!, compressionRatio)
        }
        let base64_code: String = (imageData?.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters))!
        let request : UploadPictureRequest = UploadPictureRequest(base64_code: base64_code)
        DataAccessor(serviceConfiguration: ParseConfiguration()).uploadPicture(request) { (response) -> Void in
            if self.isCancelled {
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
