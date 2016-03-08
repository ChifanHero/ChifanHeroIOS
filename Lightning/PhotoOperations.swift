//
//  PhotoOperations.swift
//  SoHungry
//
//  Created by Shi Yan on 10/17/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

enum PhotoRecordState {
    case New, Downloaded, Failed, Native
}

class PhotoRecord {
    
    let name : String
    let url : NSURL
    var state = PhotoRecordState.New
    var image = UIImage(named: "food placeholder2")
    
    init(name : String, url : NSURL) {
        self.name = name
        self.url = url
    }
    
    init(name : String, url : NSURL, defaultImage : UIImage) {
        self.image = defaultImage
        self.name = name
        self.url = url
    }
}

class PendingOperations {
    
    // A lazy stored property is a property whose initial value is not calculated until the first time it is used.
    lazy var downloadsInProgress = [NSIndexPath : NSOperation]()
    lazy var downloadQueue : NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Download queue"
        return queue
    }()
}

class ImageDownloader : NSOperation {
    
    let photoRecord : PhotoRecord
    
    init(photoRecord : PhotoRecord) {
        self.photoRecord = photoRecord
    }
    
    override func main() {
        
        // Check for cancellation before starting. Operations should regularly check if they have been cancelled before attempting long or intensive work
        if self.cancelled {
            return
        }
        
        let imageData = NSData(contentsOfURL: self.photoRecord.url)
        
        // Check again for cancellation
        if self.cancelled {
            return
        }
        
        if imageData?.length > 0 {
            self.photoRecord.image = UIImage(data: imageData!)
            self.photoRecord.state = .Downloaded
        } else {
            self.photoRecord.state = .Failed
//            self.photoRecord.image = UIImage(named: "Failed")
        }
    }
    
}
