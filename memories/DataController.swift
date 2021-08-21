//
//  PersistenceController.swift
//  memories
//
//  Created by Alina Potapova on 11.08.2021.
//

import Foundation
import SwiftUI
import CoreData

class DataController: ObservableObject {
    private let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Commentarium")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Fatal error while loading data: \(error.localizedDescription)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // TODO: Display an error alert to the user and send a log crash to me
                fatalError("Fatal error while saving changes: \(error.localizedDescription)")
            }
        }
    }
    
    func delete(_ object: NSManagedObject) {
        context.delete(object)
    }
    
    func deleteAllNotes() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Memory")
        let batchRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.executeAndMergeChanges(using: batchRequest)
        } catch {
            fatalError("Fatal error while deleting folder: \(error.localizedDescription)")
        }
    }
}
