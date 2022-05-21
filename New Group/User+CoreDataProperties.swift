//
//  User+CoreDataProperties.swift
//  memories
//
//  Created by Alina Potapova on 18.05.2022.
//



import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }
    
    @nonobjc public class func resultsController(moc: NSManagedObjectContext, sortDescriptors: [NSSortDescriptor]) -> NSFetchedResultsController<User> {
        let request =  NSFetchRequest<User>(entityName: "User")
        request.sortDescriptors = sortDescriptors
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    
    public var safeNameContent: String {
        get { name ?? "UserName" }
        set { name = newValue }
    }
    
    public var safeName: String {
        return safeNameContent != ""
            ? String(safeNameContent.split(whereSeparator: \.isNewline)[0])
            : "User"
    }
}

extension User : Identifiable {

}
