//
//  PostReviewOperation.swift
//  Lightning
//
//  Created by Shi Yan on 10/22/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class PostReviewOperation: RetryableOperation {
    
    private var success = false
    
    private var rating: Int = 0
    
    private var content: String?
    
    private var retryTimes = 0
    
    private var savedReview: Review?
    
    var reviewId: String?
    
    var restaurantId: String!
    
    init(rating: Int, content: String, retryTimes: Int, completion: @escaping (Bool, Review?) -> Void) {
        super.init()
        self.rating = rating
        self.content = content
        self.retryTimes = retryTimes
        self.completionBlock = {
            if self.isCancelled {
                completion(false, nil)
            } else {
                completion(self.success, self.savedReview)
            }
        }
    }
    
    override func main() {
        upseartReview()
    }
    
    private func upseartReview() {
        let request = UpsertReviewRequest()
        request.content = content
        request.rating = rating
        request.restaurantId = restaurantId
        request.reviewId = reviewId
        DataAccessor(serviceConfiguration: ParseConfiguration()).upsertReview(request) { (response) in
            if self.isCancelled {
                self.state = .finished
            } else {
                if let result = response?.result {
                    self.savedReview = result
                    self.success = true
                } else {
                    if self.retryTimes > 0 {
                        self.retryTimes = self.retryTimes - 1
                        self.upseartReview()
                    }
                }
                self.state = .finished
            }
        }
    }
}
