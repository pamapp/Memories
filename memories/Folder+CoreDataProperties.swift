//
//  Folder+CoreDataProperties.swift
//  memories
//
//  Created by Alina Potapova on 16.08.2021.
//


import Foundation
import CoreData


extension Folder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Folder> {
        return NSFetchRequest<Folder>(entityName: "Folder")
    }
    
    @nonobjc public class func resultsController(moc: NSManagedObjectContext, sortDescriptors: [NSSortDescriptor]) -> NSFetchedResultsController<Folder> {
        let request =  NSFetchRequest<Folder>(entityName: "Folder")
        request.sortDescriptors = sortDescriptors
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
    }

    @NSManaged public var name: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var contains: NSSet?
    
//    public var wContains: [Memory]{
//        let notes = contains as? Set<Memory> ?? []
//        return notes.sorted(by: {firstNote, secondNote -> Bool in
//            return firstNote.date < secondNote.date
//        })
//    }
    
    public var safeNameContent: String {
        get { name ?? "Unnamed Folder" }
        set { name = newValue }
    }
    
    public var safeName: String {
        return safeNameContent != ""
            ? String(safeNameContent.split(whereSeparator: \.isNewline)[0])
            : "Folder"
    }
    
    public var safeMemoriesNumber: Int {
        let memories = contains as? Set<Memory> ?? []
        return memories.count
    }
}

// MARK: Generated accessors for contains
extension Folder {
    
    @objc(addContainsObject:)
    @NSManaged public func addToContains(_ value: Memory)

    @objc(removeContainsObject:)
    @NSManaged public func removeFromContains(_ value: Memory)

    @objc(addContains:)
    @NSManaged public func addToContains(_ values: NSSet)

    @objc(removeContains:)
    @NSManaged public func removeFromContains(_ values: NSSet)

}

extension Folder : Identifiable {

}
