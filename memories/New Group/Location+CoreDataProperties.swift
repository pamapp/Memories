//
//  Location+CoreDataProperties.swift
//  memories
//
//  Created by Alina Potapova on 27.04.2022.
//


import Foundation
import CoreData
import SwiftUI

extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @nonobjc public class func resultsController(moc: NSManagedObjectContext, sortDescriptors: [NSSortDescriptor]) -> NSFetchedResultsController<Location> {
        let request =  NSFetchRequest<Location>(entityName: "Location")
        request.sortDescriptors = sortDescriptors
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var memory: NSSet?
    
//    public var safePlaceNameContent: String {
//        get { name ?? "" }
//        set { name = newValue }
//    }
//    
//    public var safePlaceName: String {
//        return safePlaceNameContent != ""
//                ? String(safePlaceNameContent.split(whereSeparator: \.isNewline)[0])
//                : "Somewhere"
//    }
//    
}

