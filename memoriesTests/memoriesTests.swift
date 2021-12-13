//
//  memoriesTests.swift
//  memoriesTests
//
//  Created by Alina Potapova on 07.12.2021.
//

import XCTest
import CoreData
import memories

class TestCoreDataStack: NSObject {
    lazy var persistentContainer: NSPersistentContainer = {
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        let container = NSPersistentContainer(name: "Memories")
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
}

class memoriesTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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

    func testAddMmeory() {
      // 1
//    let memory =
//        MemoryModel.addNewMemory(
//            place: "Test Place",
//            text: "Test Text",
//            date: Date(),
//            folder: nil,
//            image: UIImage(systemName: "person")
//        )

      // 2
//      XCTAssertNotNil(memory, "Report should not be nil")
//      XCTAssertTrue(memory.place == "Test Place")
//      XCTAssertTrue(memory.text == "Test Text")
//      XCTAssertTrue(memory.date == Date())
//      XCTAssertTrue(memory.numberNegative == 1)
    }
}

