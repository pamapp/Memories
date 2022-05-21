//
//  LocationView.swift
//  memories
//
//  Created by Alina Potapova on 27.04.2022.
//

import SwiftUI
import MapKit

struct MyAnnotationItem: Identifiable {
    var coordinate: CLLocationCoordinate2D
    let id = UUID()
}

struct LocationView: View {
    @StateObject var mapData = LocationViewModel()

    @State var locationManager = CLLocationManager()
    
    @ObservedObject var viewLocationModel: LocationSelectView.LocationModel
    
    @State var annotationItems: [MyAnnotationItem] = []
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $mapData.region, showsUserLocation: true,
                annotationItems: annotationItems) { location in
                MapPin(coordinate: location.coordinate)
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        //mapData.focusLocation()
                    }, label: {
                        Image(systemName: "location.fill")
                            .font(.title2)
                            .padding(10)
                            .foregroundColor(.tabButtonColor)
                            .background(Color.cellColor)
                            .clipShape(Circle())
                    })
                }.padding(.trailing, 10)
            }.padding(.bottom, 95)
        }
        .ignoresSafeArea(.all)
        .onAppear {
            mapData.checkIfLocationServicesIsEnabled()
            self.annotationItems = viewLocationModel.locationPinConvert()
        }
    }
}

final class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 59.9386, longitude: 30.3141), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    var locationManager: CLLocationManager?
   
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
        } else {
            print("Off, please turn it on")
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }

        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Your location is restricted likely due to parental")
        case .denied:
            print("You have denied this app location permission")
        case .authorizedWhenInUse, .authorizedAlways:
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
