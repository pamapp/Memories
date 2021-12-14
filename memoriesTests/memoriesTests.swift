//
//  memoriesTests.swift
//  memoriesTests
//
//  Created by Alina Potapova on 07.12.2021.
//

import XCTest
import CoreData
@testable import memories

public class TestCoreDataStack: CoreDataStack {
  public override init() {
    super.init()

    let persistentStoreDescription = NSPersistentStoreDescription()
    persistentStoreDescription.type = NSInMemoryStoreType

    let container = NSPersistentCloudKitContainer(name: "Memories")

    container.persistentStoreDescriptions = [persistentStoreDescription]

    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
      
    storeContainer = container
  }
}



class memoriesTests: XCTestCase {

    var coreDataStack: CoreDataStack!
    
    lazy var context = self.coreDataStack.mainContext
    
//    var model = FoldersView.FolderModel.init(moc: context)
    
    override func setUp() {
        coreDataStack = TestCoreDataStack()
    }

    override func tearDown() {
      super.tearDown()
      coreDataStack = nil
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testAddFolder() {
        let folder = Folder(context: context)
        folder.name = "TestFolder"
        folder.isFavorite = false
        folder.id = UUID()
        XCTAssertEqual(folder.name, "TestFolder")
        XCTAssertEqual(folder.isFavorite, false)
        XCTAssertNotNil(folder.id, "id should not be nil")
    }
    
    func testAddMemory() {
        let folder = Folder(context: context)
        folder.name = "TestFolder"
        folder.isFavorite = false
        folder.id = UUID()
    
        let memory = Memory(context: context)
        memory.content = "Something"
        memory.place = "Somewhere"
        memory.date = Date()
        memory.isFavorite = false
        memory.id = UUID()
        memory.is_in = folder
        
        XCTAssertEqual(memory.content, "Something")
        XCTAssertEqual(memory.place, "Somewhere")
        XCTAssertEqual(folder.isFavorite, false)
        XCTAssertNotNil(memory.id, "id should not be nil")
        XCTAssertEqual(memory.is_in, folder)
    }
    
}

