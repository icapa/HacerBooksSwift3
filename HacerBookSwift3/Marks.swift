//
//  Marks.swift
//  HacerBookSwift3
//
//  Created by Iván Cayón Palacio on 4/10/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit
import MapKit

class Marks: NSObject, MKAnnotation{

    let title : String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init (title: String, locationName: String, coordinate: CLLocationCoordinate2D){
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        super.init()
    }
    
    var subtitle: String?{
        return self.locationName
    }
    
}
