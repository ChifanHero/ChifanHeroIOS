//
//  PostReviewOperation.swift
//  Lightning
//
//  Created by Shi Yan on 10/22/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class PostReviewOperation: AsynchronousOperation {
    
    private var success = false
    
    private var rating: Int = 0
    private var content: String?
    
    private var savedReview: Review?
    private var error: CFHError?
    
    var reviewId: String?
    private var restaurantId: String!
    
    init(rating: Int, content: String, restaurantId: String, completion: @escaping (Bool, CFHError?, Review?) -> Void) {
        super.init()
        self.rating = rating
        self.content = content
        self.restaurantId = restaurantId
        self.completionBlock = {
            if self.isCancelled {
                completion(false, nil, nil)
            } else {
                completion(self.success, self.error, self.savedReview)
            }
        }
    }
    
    override func main() {
        super.main()
        upsertReview()
    }
    
    private func upsertReview() {
        let request = UpsertReviewRequest()
        request.content = content
        request.rating = rating
        request.restaurantId = restaurantId
        request.reviewId = reviewId
        DataAccessor(serviceConfiguration: ParseConfiguration()).upsertReview(request) { (response) in
            if let result = response?.result {
                self.savedReview = result
                self.success = true
            } else if let error = response?.error {
                self.success = false
                self.error = error
            } else {
                self.success = false
                self.savedReview = nil
                self.error = nil
            }
            self.state = .finished
        }
    }
}
