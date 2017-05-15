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
    
    private var reviewId: String?
    
    private var restaurantId = ""
    
    private var photos: [String]?
    
    init(rating: Int, content: String?, restaurantId: String, retryTimes: Int, completion: @escaping (Bool, Review?) -> Void) {
        super.init()
        self.rating = rating
        self.content = content
        self.restaurantId = restaurantId
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
        review()
    }
    
    private func review() {
        let request: ReviewRequest = ReviewRequest()
        request.content = content
        request.rating = rating
        request.restaurantId = restaurantId
        request.photos = photos
        DataAccessor(serviceConfiguration: ParseConfiguration()).review(request) { (response) in
            if self.isCancelled {
                self.state = .finished
            } else {
                if response != nil && response?.result != nil {
                    self.savedReview = response!.result
                    self.success = true
                } else {
                    if self.retryTimes > 0 {
                        self.retryTimes = self.retryTimes - 1
                        self.review()
                    }
                }
                self.state = .finished
            }
        }

    }
    
}
