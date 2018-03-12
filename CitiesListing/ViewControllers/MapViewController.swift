//
//  MapViewController.swift
//  CitiesListing
//
//  Created by Rodrigo Bueno Tomiosso on 12/03/2018.
//  Copyright © 2018 mourodrigo. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    var latitude:Double?
    var longitude:Double?
    
    override func viewDidAppear(_ animated: Bool) {
        if let lat = latitude, let long = longitude {
            let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            mapView.setRegion(region, animated: true)
        }
    }
}
