//
//  Memory+CoreDataProperties.swift
//  memories
//
//  Created by Alina Potapova on 16.08.2021.
//

import Foundation
import CoreData
import SwiftUI

extension Memory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memory> {
        return NSFetchRequest<Memory>(entityName: "Memory")
    }

    @nonobjc public class func resultsController(
        moc: NSManagedObjectContext,
        sortDescriptors: [NSSortDescriptor],
        predicate: NSPredicate) -> NSFetchedResultsController<Memory>
    {
        let request =  NSFetchRequest<Memory>(entityName: "Memory")
        request.sortDescriptors = sortDescriptors
        request.predicate = predicate
        return NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: moc,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }
    
    @NSManaged public var content: String?
    @NSManaged public var title: String?
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var color: Int16
    @NSManaged public var is_in: Folder?
    @NSManaged public var place: Location
    
    public var safeTextContent: String {
        get { content ?? "" }
        set { content = newValue }
    }
    
    public var safeTitleContent: String {
        get { title ?? "" }
        set { title = newValue }
    }
    
    public var safePlaceContent: String {
        get { place.name ?? "" }
        set { place.name = newValue }
    }
    
    public var safeID: UUID {
        get { id ?? UUID() }
        set { id = newValue }
    }
    
    public var safeText: String {
        return safeTextContent != ""
                ? String(safeTextContent.split(whereSeparator: \.isNewline)[0])
                : "Something"
    }
    
    public var safeTitle: String {
        return safeTitleContent != ""
                ? String(safeTitleContent.split(whereSeparator: \.isNewline)[0])
                : "Untitled"
    }
    
    public var safePlace: String {
        return safePlaceContent != ""
                ? String(safePlaceContent.split(whereSeparator: \.isNewline)[0])
                : "Somewhere"
    }
    
    public var contentWithoutTitle: String {
        let splitContent = safeTextContent.split(whereSeparator: \.isNewline)
        return safeTextContent != ""
                ? splitContent[1..<splitContent.count].joined(separator: "\n")
                : "Add some text"
    }
}

extension Memory : Identifiable {

}

