//
//  TuningParams.swift
//  SoHungry
//
//  Created by Shi Yan on 12/3/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class TuningParams: Serializable {
    
    var relevanceScoreThreshold : Float?
    
    func getProperties() -> [String : AnyObject] {
        var parameters = Dictionary<String, AnyObject>()
        parameters["relevance_score_threshold"] = relevanceScoreThreshold as AnyObject
        return parameters
    }
}
