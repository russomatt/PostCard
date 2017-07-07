//
//  CustomAnnotation.swift
//  PostCard
//
//  Created by Matthew Russo on 7/2/17.
//  Copyright © 2017 Olya Danylova. All rights reserved.
//

import UIKit
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    var id: String
    var pinCoord: CLLocationCoordinate2D
    
    init(pinCoord: CLLocationCoordinate2D, id: String) {
        self.id = id
        self.pinCoord = pinCoord
    }
    
    var coordinate: CLLocationCoordinate2D {
        return pinCoord
    }

}
