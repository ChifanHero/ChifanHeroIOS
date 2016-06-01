//
//  GetSelectedCollectionsRequest.swift
//  Lightning
//
//  Created by Zhang, Alex on 4/27/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class GetSelectedCollectionsByLatAndLonRequest: HttpRequest{
    
    var userLocation: Location?
    
    override init(){
        super.init()
    }
    
    init(location: Location){
        self.userLocation = location
    }
    
    override func getRelativeURL() -> String {
        return "/selectedCollections?lat=" + String((userLocation?.lat)!) + "&lon=" + String((userLocation?.lon)!)
    }
}