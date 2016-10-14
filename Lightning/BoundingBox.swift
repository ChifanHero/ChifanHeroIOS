//
//  BoundingBox.swift
//  Lightning
//
//  Created by Shi Yan on 10/13/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class BoundingBox {
    
    var maxPoint : Location?
    var minPoint : Location?
    
    init(maxPoint : Location, minPoint : Location) {
        self.maxPoint = maxPoint
        self.minPoint = minPoint
    }
    
    private static let WGS84_a : Double = 6378137.0
    private static let WGS84_b : Double = 6356752.3
    
    static func getBoundingBox(center : Location, radiusInKm : Double) -> BoundingBox {
        // Bounding box surrounding the point at given coordinates,
        // assuming local approximation of Earth surface as a sphere
        // of radius given by WGS84
        let lat = degreeToRadian(center.lat!)
        let lon = degreeToRadian(center.lon!)
        let halfSide = 1000 * radiusInKm
        
        // Radius of Earth at given latitude
        let radius = getWGS84EarthRadius(lat);
        // Radius of the parallel at given latitude
        let pradius = radius * cos(lat)
        
        let latMin = lat - halfSide / radius;
        let latMax = lat + halfSide / radius;
        let lonMin = lon - halfSide / pradius;
        let lonMax = lon + halfSide / pradius;
        
        let maxPoint = Location()
        maxPoint.lat = radianToDegree(latMax)
        maxPoint.lon = radianToDegree(lonMax)
        let minPoint = Location()
        minPoint.lat = radianToDegree(latMin)
        minPoint.lon = radianToDegree(lonMin)
        let boundingBox = BoundingBox(maxPoint: maxPoint, minPoint: minPoint)
        return boundingBox
    }
    
    private class func degreeToRadian(degrees : Double) -> Double {
        return M_PI * degrees / 180.0
    }
    
    private class func radianToDegree(radians : Double) -> Double {
        return 180.0 * radians / M_PI
    }
    
    private class func getWGS84EarthRadius(lat : Double) -> Double {
        let an = WGS84_a * WGS84_a * cos(lat)
        let bn = WGS84_b * WGS84_b * sin(lat)
        let ad = WGS84_a * cos(lat)
        let bd = WGS84_b * sin(lat)
        return sqrt((an * an + bn * bn) / (ad * ad + bd * bd))
    }
    
}
