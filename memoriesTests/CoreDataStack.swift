//
//  CoreDataStack.swift
//  memoriesTests
//
//  Created by Alina Potapova on 14.12.2021.
//

import CoreData

open class CoreDataStack {
    public static let modelName = "Memories"

    public lazy var model: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: CoreDataStack.modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    public lazy var mainContext: NSManagedObjectContext = {
        return storeContainer.viewContext
    }()

    public lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataStack.modelName, managedObjectModel: model)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    public func newDerivedContext() -> NSManagedObjectContext {
        let context = storeContainer.newBackgroundContext()
        return context
    }

    public func saveContext() {
        saveContext(mainContext)
    }

    public func saveContext(_ context: NSManagedObjectContext) {
        if context != mainContext {
            saveDerivedContext(context)
            return
        }

        context.perform {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    public func saveDerivedContext(_ context: NSManagedObjectContext) {
        context.perform {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }

            self.saveContext(self.mainContext)
        }
    }
}

