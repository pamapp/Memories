//
//  Memory+CoreDataProperties.swift
//  memories
//
//  Created by Alina Potapova on 16.08.2021.
//

import Foundation
import CoreData


extension Memory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memory> {
        return NSFetchRequest<Memory>(entityName: "Memory")
    }

    @nonobjc public class func resultsController(moc: NSManagedObjectContext, sortDescriptors: [NSSortDescriptor],predicate: NSPredicate) -> NSFetchedResultsController<Memory> {
        let request =  NSFetchRequest<Memory>(entityName: "Memory")
        request.sortDescriptors = sortDescriptors
        request.predicate = predicate
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
    }
    @NSManaged public var place: String?
    @NSManaged public var content: String?
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var is_in: Folder?

    
    public var safeTextContent: String {
        get { content ?? "" }
        set { content = newValue }
    }
    
    public var safePlaceContent: String {
        get { place ?? "" }
        set { place = newValue }
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
