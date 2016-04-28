//
//  SelectedCollection.swift
//  Lightning
//
//  Created by Zhang, Alex on 4/27/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class SelectedCollection: Model{
    
    var id: String?
    var title: String?
    var description: String?
    var typeId: Int?
    var memberCount: Int?
    var userFavoriteCount: Int?
    var cellImage: Picture?
    var coverageCenterGeo: Location?
    var coverageRadius: Int?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        id <-- data["id"]
        title <-- data["title"]
        description <-- data["description"]
        typeId <-- data["type_id"]
        memberCount <-- data["member_count"]
        userFavoriteCount <-- data["user_favorite_count"]
        cellImage <-- data["cell_image"]
        coverageCenterGeo <-- data["coverage_center_geo"]
        coverageRadius <-- data["coverage_radius"]
    }
}