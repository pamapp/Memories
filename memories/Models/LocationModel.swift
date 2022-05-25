//
//  LocationModel.swift
//  memories
//
//  Created by Alina Potapova on 27.04.2022.
//

import Foundation
import CoreData
import SwiftUI
import MapKit

extension LocationSelectView {
    final class LocationModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        private let controller :  NSFetchedResultsController<Location>

        public var alert = false
        public var alertMessage = ""
        
        init(moc: NSManagedObjectContext) {
            let sortDescriptors = [NSSortDescriptor(keyPath: \Location.name, ascending: false)]
            controller = Location.resultsController(moc: moc, sortDescriptors: sortDescriptors)
            super.init()
            
            controller.delegate = self
            
            do {
                try controller.performFetch()
                alert = false
            } catch{
                alert =  true
                alertMessage = "Saving data error"
            }
        }
        
        var locations: [Location] {
            return controller.fetchedObjects ?? []
        }
        
        func removeLocation(location: Location) {
            controller.managedObjectContext.delete(location)
            saveContext()
        }

        func saveContext() {
            do{
                try controller.managedObjectContext.save()
                alert = false
            }catch {
                alert =  true
                alertMessage = "Saving data error"
            }
        }
         
        func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            objectWillChange.send()
        }
    
        
        func addLocation(name: String, longitude: Double, latitude: Double) -> Location {
            let location = Location(context: controller.managedObjectContext)
            location.name = name
            location.id = UUID()
            location.longitude = longitude
            location.latitude = latitude
            
            saveContext()
            return location
        }
        
        func changeLocationCoordinates(location: Location, name: String, longitude: Double, latitude: Double) -> Location {
            location.name = name
            location.longitude = longitude
            location.latitude = latitude
            saveContext()
            return location
        }

        func locationPinConvert() -> [MyAnnotationItem] {
            var annotationItems: [MyAnnotationItem] = []
            for (index, location) in locations.enumerated() {
                annotationItems.insert(MyAnnotationItem(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)), at: index)
                            }
            return annotationItems
        }

        func getPlacesNumder() -> Int {
            let uniqueBasedOnName = locations.unique{$0.name}
            return uniqueBasedOnName.count
        }
    }
}
