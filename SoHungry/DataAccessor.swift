//
//  DataAccessor.swift
//  SoHungry
//
//  Created by Shi Yan on 8/15/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class DataAccessor {
    
    var serviceConfiguration : ServiceConfiguration
    
    init (serviceConfiguration : ServiceConfiguration) {
        self.serviceConfiguration = serviceConfiguration
    }
    
    func getPromotions(request : GetPromotionsRequest, responseHandler : (GetPromotionsResponse?) -> Void) {
        let httpClient = HttpClient()
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
        print(url)
        httpClient.get(url, headers: nil, parameters: request.getParameters()) { (data, response, error) -> Void in
            var getPromotionsResponse : GetPromotionsResponse? = nil
            if data != nil {
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                var jsonData : [String : AnyObject]
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData((strData?.dataUsingEncoding(NSUTF8StringEncoding))!, options: NSJSONReadingOptions.MutableLeaves) as! [String : AnyObject]
                    getPromotionsResponse = GetPromotionsResponse(data: jsonData)
                } catch {
                    print(error)
                }
            }
            responseHandler(getPromotionsResponse)
        }
    }
}
