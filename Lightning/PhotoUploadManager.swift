//
//  FileUploader.swift
//  Lightning
//
//  Created by Shi Yan on 10/15/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class PhotoUploadManager {
    lazy var uploadQueue : OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Upload queue"
        queue.maxConcurrentOperationCount = 5
        return queue
    }()
    
}
