//
//  LocationView.swift
//  memories
//
//  Created by Alina Potapova on 03.02.2022.
//
import CoreLocationUI
import SwiftUI
import MapKit


struct MyAnnotationItem: Identifiable {
    var coordinate: CLLocationCoordinate2D
    let id = UUID()
}

struct LocationView: View {
    @StateObject private var viewModel = ContentViewModel()
    var annotationItems: [MyAnnotationItem] = [
        MyAnnotationItem(coordinate: CLLocationCoordinate2D(latitude: 60.182582, longitude: 29.757049)),
        MyAnnotationItem(coordinate: CLLocationCoordinate2D(latitude: 60.012164, longitude: 30.389382)),
    ]
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: annotationItems) { item in
                MapPin(coordinate: item.coordinate)
            }
            .ignoresSafeArea()
            .tint(.purple)
            .onAppear {
                viewModel.checkIfLocationServicesIsEnabled()
            }
            
            LocationButton(.currentLocation) {
                viewModel.checkIfLocationServicesIsEnabled()
            }
            .foregroundColor(.white)
            .cornerRadius(30)
            .labelStyle(.iconOnly)
            .symbolVariant(.fill)
            .tint(.purple)
//            .opacity(0.8)
            .padding(.bottom, 70)
            .padding(.trailing, 20)
        }
    }
}


final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

    var locationManager: CLLocationManager?
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
        } else {
            print("Show an alert letting know this is off and to go turn it on.")
        }
    }
    
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else {
            return
        }
        
        switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                print("Your location is restricted likely due to parental controls.")
            case .denied:
                print("You have denied this app location permission. Go into settings to change it.")
            case .authorizedAlways, .authorizedWhenInUse:
                region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))
            @unknown default:
                break
        }

    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
