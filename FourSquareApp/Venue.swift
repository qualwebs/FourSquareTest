//
//  Venue.swift
//  FourSquareApp
//
//  Created by Manisha  Sharma on 19/12/2017.
//  Copyright © 2017 Qualwebs. All rights reserved.
//

import UIKit

class Venue: NSObject {
    var name: String
    var address: String
    var contactNumber: String
    var id: String
    var lat: String
    var lng: String
    
    init(name: String, address: String, contactNumber: String, id: String, lat: String, lng: String) {
        self.name = name
        self.address = address
        self.contactNumber = contactNumber
        self.id = id
        self.lat = lat
        self.lng = lng
    }
}
