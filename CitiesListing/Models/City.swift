//
//  City.swift
//  CitiesListing
//
//  Created by Rodrigo Bueno Tomiosso on 12/03/2018.
//  Copyright © 2018 mourodrigo. All rights reserved.
//

import Foundation

class City {
    let id: Int
    let name: String
    let country: String
    let latitude: Double
    let longitude: Double

    init(id: Int, name: String, country: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
    }
}
