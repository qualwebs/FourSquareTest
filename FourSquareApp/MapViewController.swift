//
//  MapViewController.swift
//  FourSquareApp
//
//  Created by Manisha  Sharma on 19/12/2017.
//  Copyright © 2017 Qualwebs. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var marker:GMSMarker = GMSMarker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let camera = GMSCameraPosition.camera(withLatitude: (latitude)!, longitude: (longitude)!, zoom: 17.0)
        mapView.camera = camera
        marker.position = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        marker.map = mapView
    }
}
