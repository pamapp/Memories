//
//  MapModel.swift
//  memories
//
//  Created by Alina Potapova on 28.04.2022.
//

import SwiftUI
import MapKit
import CoreLocation
import Contacts

struct Place: Identifiable {
    var id = UUID().uuidString
    var placemark: CLPlacemark
}

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var mapView = MKMapView()
    
    //Region
    @Published var region: MKCoordinateRegion!
    
    //Alert
    @Published var permissionDenied = false
    
    //map type
    @Published var mapType: MKMapType = MKMapType.standard
    
    //SearchText
    @Published var searchText = ""
    
    //Searched places
    @Published var places: [Place] = []
    
    @Published var longitude: Double = 0
    
    @Published var latitude: Double = 0
    
    @Published var name = ""
    
    //focus location
    func focusLocation(){
        guard let _ = region else {
             return
        }
        
        mapView.setRegion(region, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
        longitude = mapView.centerCoordinate.longitude
        latitude = mapView.centerCoordinate.latitude
    }
    
    //Search places
    func searchQuery() {
        
        places.removeAll()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        //Fetch
        MKLocalSearch(request: request).start { (response, err) in
            guard let result = response else {
                return
            }
            
            self.places = result.mapItems.compactMap({ (item) -> Place? in
                return Place(placemark: item.placemark)
            })
            
        }
    }
    
    
    // pick search results
    
    func selectPlace(place: Place) {
        //Showing pin on map
        searchText = ""
        
        guard let coordinate = place.placemark.location?.coordinate else {
            return
        }
        
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coordinate
        pointAnnotation.title = place.placemark.name ?? "No name"
        
        name = place.placemark.name ?? "No name"
        longitude = pointAnnotation.coordinate.longitude
        latitude = pointAnnotation.coordinate.latitude
        
        //Removing all old ones
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(pointAnnotation)
        
        //moving map to that new location
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
    }
  
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        //Cheking permissions
        switch manager.authorizationStatus {
        case .denied:
            //Alert
            permissionDenied.toggle()
        case .notDetermined:
            // request
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            //if permission given
            manager.requestLocation()
        default:
            ()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //error
        print(error.localizedDescription)
    }
    
    //getting user Region
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        
        self.region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))

        self.mapView.setRegion(self.region, animated: true)
        
        self.latitude = mapView.centerCoordinate.latitude
        self.longitude = mapView.centerCoordinate.longitude
        
        location.placemark { placemark, error in
            guard let placemark = placemark else {
                print("Error:", error ?? "nil")
                return
            }
            self.name = placemark.postalAddressFormatted ?? ""
        }
        

        self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
    }
}

extension CLPlacemark {
    var streetName: String? { thoroughfare }
    var streetNumber: String? { subThoroughfare }

    @available(iOS 11.0, *)
    var postalAddressFormatted: String? {
        guard let postalAddress = postalAddress else { return nil }
        return CNPostalAddressFormatter().string(from: postalAddress)
    }
}

extension CLLocation {
    func placemark(completion: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }
    }
}
