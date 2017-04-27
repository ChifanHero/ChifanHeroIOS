//
//  PhotoOperations.swift
//  SoHungry
//
//  Created by Shi Yan on 10/17/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit
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


enum PhotoRecordState {
    case new, downloaded, failed, native
}

class PhotoRecord {
    
    static let DEFAULT = PhotoRecord(name: "", url: URL(string: "")!, defaultImage: nil)
    
    let name : String
    let url : URL
    var state = PhotoRecordState.new
    var image = UIImage(named: "food placeholder2")
    
    init(name : String, url : URL) {
        self.name = name
        self.url = url
    }
    
    init(name : String, url : URL, defaultImage : UIImage?) {
        if defaultImage == nil {
            self.image = UIImage()
        } else {
            self.image = defaultImage
        }
        self.name = name
        self.url = url
    }
}

class PendingOperations {
    
    // A lazy stored property is a property whose initial value is not calculated until the first time it is used.
    lazy var downloadsInProgress = [IndexPath : Operation]()
    lazy var downloadQueue : OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        return queue
    }()
}

class ImageDownloader : Operation {
    
    let photoRecord : PhotoRecord
    
    init(photoRecord : PhotoRecord) {
        self.photoRecord = photoRecord
    }
    
    override func main() {
        
        // Check for cancellation before starting. Operations should regularly check if they have been cancelled before attempting long or intensive work
        if self.isCancelled {
            return
        }
        
        let imageData = try? Data(contentsOf: self.photoRecord.url)
        
        // Check again for cancellation
        if self.isCancelled {
            return
        }
        
        if imageData?.count > 0 {
            self.photoRecord.image = UIImage(data: imageData!)
            self.photoRecord.state = .downloaded
        } else {
            self.photoRecord.state = .failed
        }
    }
    
}
