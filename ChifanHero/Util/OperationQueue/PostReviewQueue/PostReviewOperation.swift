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
    
    private var error: CFHError?
    
    var reviewId: String?
    
    var restaurantId: String!
    
    init(rating: Int, content: String, retryTimes: Int, completion: @escaping (Bool, CFHError?, Review?) -> Void) {
        super.init()
        self.rating = rating
        self.content = content
        self.retryTimes = retryTimes
        self.completionBlock = {
            if self.isCancelled {
                completion(false, nil, nil)
            } else {
                completion(self.success, self.error, self.savedReview)
            }
        }
    }
    
    override func main() {
        upsertReview()
    }
    
    private func upsertReview() {
        let request = UpsertReviewRequest()
        request.content = content
        request.rating = rating
        request.restaurantId = restaurantId
        request.reviewId = reviewId
        DataAccessor(serviceConfiguration: ParseConfiguration()).upsertReview(request) { (response) in
            if self.isCancelled {
                self.state = .finished
            } else {
                if response == nil {
                    if self.retryTimes > 0 {
                        self.retryTimes = self.retryTimes - 1
                        self.upsertReview()
                    } else {
                        self.success = false
                    }
                } else if response!.result != nil {
                    self.savedReview = response!.result!
                    self.success = true
                } else if response!.error != nil {
                    if self.retryTimes > 0 {
                        self.retryTimes = self.retryTimes - 1
                        self.upsertReview()
                    } else {
                        self.success = false
                        self.error = response!.error!
                    }
                } else {
                    if self.retryTimes > 0 {
                        self.retryTimes = self.retryTimes - 1
                        self.upsertReview()
                    } else {
                        self.success = false
                    }
                }
                self.state = .finished
            }
        }
    }
}
