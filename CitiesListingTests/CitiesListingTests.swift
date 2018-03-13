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
        let ctvc = citiesViewControllerInstance()
        self.measure {
            ctvc.loadAllCities()
        }
        print(ctvc.dataSource().count)
        assert(ctvc.dataSource().count == 456, "Sample data has changed or incorrect JSON parsing occurred")
    }
    
    func citiesViewControllerInstance() -> CitiesTableViewController {
        //NIBs are lazily loaded, so we must get them from storyboard and load his view.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let ctvc = storyboard.instantiateViewController(withIdentifier: "CitiesTableViewController") as! CitiesTableViewController
        ctvc.loadView()
        return ctvc
    }
    
    func setSearchString(searchText:String, on viewController:CitiesTableViewController) {
        viewController.searchBar.text = searchText
        viewController.applySearch(with: searchText)
    }
    
    func testTextSearch() {
        let ctvc = citiesViewControllerInstance()
        
        let jsonTestString = "[{\"country\": \"US\",\"name\": \"Alabama\",\"_id\": 1,\"coord\": {\"lon\": -86.8327625,\"lat\": 33.3676976}},{\"country\": \"US\",\"name\": \"Albuquerque\",\"_id\": 2,\"coord\": {\"lon\": -106.7164848,\"lat\": 35.0906166}},{\"country\": \"US\",\"name\": \"Anaheim\",\"_id\": 3,\"coord\": {\"lon\": 33.8361808,\"lat\": -117.9068632}},{\"country\": \"US\",\"name\": \"Arizona\",\"_id\": 4,\"coord\": {\"lon\": 33.6056695,\"lat\": -112.4059225}},{\"country\": \"US\",\"name\": \"Sydney\",\"_id\": 5,\"coord\": {\"lon\": 151.0514922,\"lat\": -33.9020268}}]"

        ctvc.allCities = ctvc.getCities(from: jsonTestString)
        
        // tableview datasource fetching and reloading occurs asynchronously for preventing UX freezing,
        // so i'm waiting for the results to be shown on tableview giving a maximum time for the results to be presented
        let maxAllowedTimeForFinishSearching = UInt32(1)

        self.setSearchString(searchText: "A", on: ctvc)
        sleep(maxAllowedTimeForFinishSearching)
        assert(ctvc.tableView(ctvc.tableView, numberOfRowsInSection: 0) == 4, "All rows but Sidney should appear")
        
        setSearchString(searchText: "s", on: ctvc)
        sleep(maxAllowedTimeForFinishSearching)
        assert(ctvc.tableView(ctvc.tableView, numberOfRowsInSection: 0) == 1, "Only Sydney should appear")

        setSearchString(searchText: "Al", on: ctvc)
        sleep(maxAllowedTimeForFinishSearching)
        assert(ctvc.tableView(ctvc.tableView, numberOfRowsInSection: 0) == 2, "Alabama, US and Albuquerque, US should appear")

        setSearchString(searchText: "Alb", on: ctvc)
        sleep(maxAllowedTimeForFinishSearching)
        assert(ctvc.tableView(ctvc.tableView, numberOfRowsInSection: 0) == 1, "Albuquerque only should appear")

        setSearchString(searchText: "", on: ctvc)
        sleep(maxAllowedTimeForFinishSearching)
        assert(ctvc.tableView(ctvc.tableView, numberOfRowsInSection: 0) == 5, "All results should appear")

        setSearchString(searchText: "nothing here", on: ctvc)
        sleep(maxAllowedTimeForFinishSearching)
        assert(ctvc.tableView(ctvc.tableView, numberOfRowsInSection: 0) == 0, "No results should be found")
        
        setSearchString(searchText: "!Q[3['',//.0-21^%]324]2%$*&", on: ctvc)
        sleep(maxAllowedTimeForFinishSearching)
        assert(ctvc.tableView(ctvc.tableView, numberOfRowsInSection: 0) == 0, "No results should be found")

    }
}
