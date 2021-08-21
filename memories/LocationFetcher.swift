//
//  LocationFetcher.swift
//  memories
//
//  Created by Alina Potapova on 11.08.2021.
//

//import CoreLocation
//
//class LocationFetcher: NSObject, CLLocationManagerDelegate {
//    let manager = CLLocationManager()
//    var lastKnownLocation: CLLocationCoordinate2D?
//
//    override init() {
//        super.init()
//        manager.delegate = self
//    }
//
//    func start() {
//        manager.requestWhenInUseAuthorization()
//        manager.startUpdatingLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        lastKnownLocation = locations.first?.coordinate
//    }
//}
