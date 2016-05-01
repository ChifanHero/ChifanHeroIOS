//
//  GetSelectedCollectionsRequest.swift
//  Lightning
//
//  Created by Zhang, Alex on 4/27/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class GetSelectedCollectionsByLatAndLonRequest: GetRequestProtocol{
    
    var lat: Int
    var lon: Int
    
    init(latitude: Int, longitude: Int){
        self.lat = latitude
        self.lon = longitude
    }
    
    func getRelativeURL() -> String {
        return "selectedCollections?lat=" + String(lat) + "lon=" + String(lon)
    }
}