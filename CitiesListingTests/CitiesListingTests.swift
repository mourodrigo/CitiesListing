//
//  CitiesListingTests.swift
//  CitiesListingTests
//
//  Created by Rodrigo Bueno Tomiosso on 12/03/2018.
//  Copyright © 2018 mourodrigo. All rights reserved.
//

import XCTest
@testable import CitiesListing

class CitiesListingTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testJsonCounting() {
        let ctvc = CitiesTableViewController()
        let jsonString = "[{\"country\": \"BR\",\"name\": \"Chapeco\",\"_id\": 1,\"coord\": {\"lon\": -52.6119352,\"lat\": -27.0971662}}, {\"country\": \"BR\",\"name\": \"Florianopolis\",\"_id\": 2,\"coord\": {\"lon\": -27.5987633,\"lat\": -48.5604456}}]"
        let result = ctvc.getCities(from: jsonString)
        assert(result.count == 2, "Get cities did not return the expected number of cities")
    }
    
    func testIncorrectJson() {
        let ctvc = CitiesTableViewController()
        let jsonString = "[\"country\": \"BR\",\"name\": \"Chapeco\",\"_id\": 1,\"coord\": {\"lon"
        let result = ctvc.getCities(from: jsonString)
        assert(result.count == 0, "Get cities should not add cities on wrong json serialization")
    }
    
    func testJsonMapping() {
        let ctvc = CitiesTableViewController()
        let jsonString = "[{\"country\": \"BR\",\"name\": \"Chapeco\",\"_id\": 1,\"coord\": {\"lon\": -52.6119352,\"lat\": -27.0971662}}]"
        let result = ctvc.getCities(from: jsonString)
        let chapeco = City(id: 1, name: "Chapeco", country: "BR", latitude: -27.0971662, longitude: -52.6119352)

        assert(result.first?.id == chapeco.id, "Wrong id mapping")
        assert((result.first?.name.elementsEqual(chapeco.name))!, "Wrong name mapping")
        assert((result.first?.country.elementsEqual(chapeco.country))!, "Wrong country mapping")
        assert(result.first?.latitude == chapeco.latitude, "Wrong latitude mapping")
        assert(result.first?.longitude == chapeco.longitude, "Wrong latitude mapping")
    }
    
    func testEmptyJson() {
        let ctvc = CitiesTableViewController()
        let jsonString = "[]"
        let result = ctvc.getCities(from: jsonString)
        assert(result.count == 0, "Empty json should not return new cities")
    }
    
    func testSourceCountWithSampleData() {
        let ctvc = CitiesTableViewController()
        self.measure {
            ctvc.loadAllCities()
        }
        print(ctvc.dataSource().count)
        assert(ctvc.dataSource().count == 456, "Sample data has changed or incorrect JSON parsing occurred")
    }
    
}
