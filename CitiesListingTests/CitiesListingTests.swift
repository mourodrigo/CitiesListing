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
    
    func testJsonParsing() {
        let ctvc = CitiesTableViewController()
        let jsonString = "[{\"country\": \"BR\",\"name\": \"Chapeco\",\"_id\": 1,\"coord\": {\"lon\": -52.6119352,\"lat\": -27.0971662}}, {\"country\": \"BR\",\"name\": \"Florianopolis\",\"_id\": 02,\"coord\": {\"lon\": -27.5987633,\"lat\": -48.5604456}}]"
        let result = ctvc.getCities(from: jsonString)
        assert(result.count == 2, "Get cities did not return the expected number of cities")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
