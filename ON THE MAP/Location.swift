//
//  Location.swift
//  ON THE MAP
//
//  Created by liang on 4/16/16.
//  Copyright © 2016 liang. All rights reserved.
//

import Foundation
import UIKit

struct Location {
    let objectId:String
    let uniqueKey:String
    let firstName:String
    let lastName:String
    let mapString:String
    let mediaURL:String
    let latitude:Double
    let longitude:Double
    init(objectId:String, uniqueKey:String, firstName:String, lastName:String, mapString:String, mediaURL:String, latitude:Double, longitude:Double){
        self.objectId = objectId
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.latitude = latitude
        self.longitude = longitude
    }
}
