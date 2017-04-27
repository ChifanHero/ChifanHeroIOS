//
//  PostReviewManager.swift
//  Lightning
//
//  Created by Shi Yan on 10/22/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class PostReviewManager {
    
    lazy var queue : OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Post Review"
        queue.maxConcurrentOperationCount = 5
        return queue
    }()
    
    var previousReviews: [String: PostReviewOperation] = [:]
    
}
