//
//  GetSelectedCollectionsRequest.swift
//  Lightning
//
//  Created by Zhang, Alex on 4/27/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class GetSelectedCollectionsByLatAndLonRequest: HttpRequestProtocol{
    
    var userLocation: Location?
    
    init(){}
    
    init(location: Location){
        self.userLocation = location
    }
    
    func getRelativeURL() -> String {
        return "/selectedCollections?lat=" + String((userLocation?.lat)!) + "&lon=" + String((userLocation?.lon)!)
    }
    
    func getRequestBody() -> [String : AnyObject] {
        let parameters = Dictionary<String, String>()
        return parameters
    }
}