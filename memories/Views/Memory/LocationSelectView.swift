//
//  LocationSelectView.swift
//  memories
//
//  Created by Alina Potapova on 19.02.2022.
//
 
import SwiftUI
import CoreLocation

struct LocationSelectView: View {
    @Environment(\.presentationMode) var isPresented
    
    @StateObject var mapData = MapViewModel()

    @State var locationManager = CLLocationManager()
    
    @Binding var longitude: Double
    @Binding var latitude: Double
    @Binding var locationName: String
    
    var body: some View {
        ZStack {
            //MapView
            MapView()
                //using it as environmentObject so that it can be used in its subViews
                .environmentObject(mapData)
                .ignoresSafeArea(.all, edges: .all)
            
            VStack {
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Search", text: $mapData.searchText)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(Color.cellColor)
                    .cornerRadius(10)
                    
                    //Displaying results
                    
                    if !mapData.places.isEmpty && mapData.searchText != "" {
                        ScrollView(showsIndicators: false){
                            VStack(spacing: 15){
                                ForEach(mapData.places){ place in
                                    
                                    Text(place.placemark.name ?? "")
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading)
                                        .onTapGesture{
                                            mapData.selectPlace(place: place)
                                        }
                                    
                                    Divider()
                                }
                            }
                            .cornerRadius(10)
                            .padding(.top)
                        }
                        .background(
                            Color.cellColor
                        )
                    }
                }
                .padding()
                
                Spacer()
                
                HStack {
                    Button(action: {
                        latitude = mapData.latitude
                        longitude = mapData.longitude
                        locationName = mapData.name
                        self.isPresented.wrappedValue.dismiss()
                    }, label: {
                        Text("Save")
                        .font(.title2)
                        .padding(10)
                        .foregroundColor(.tabButtonColor)
                        .background(Color.cellColor)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        
                    })
                    
                    Button(action: {
                        mapData.focusLocation()
                    }, label: {
                        Image(systemName: "location.fill")
                            .font(.title2)
                            .padding(10)
                            .foregroundColor(.tabButtonColor)
                            .background(Color.cellColor)
                            .clipShape(Circle())
                    })
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
                
            }
                
        }
        .onAppear(perform: {
            //setting delegate
            locationManager.delegate = mapData
            locationManager.requestWhenInUseAuthorization()
            
        })
        //Permisssion denied alert
//        .alert(isPresented: $mapData.permissionDenied, content: {
//            Alert(title: Text("Permission Denied"), message: Text("Please enable permission in app settings."), dismissButton: .default(Text("Goto seettings."), action: {
//                //Redirecting to user seettings
//                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
//            }))
//        })
        .onChange(of: mapData.searchText, perform: { value in
            //Searching places
            let delay = 0.8
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                if value == mapData.searchText {
                    //Search
                    self.mapData.searchQuery()
                }
            }
        })
    }
}
