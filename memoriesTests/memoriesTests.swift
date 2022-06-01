import XCTest
import SwiftUI
@testable import memories
import CoreData

class FolderTests: XCTestCase {
    // MARK: - Properties
    // swiftlint:disable implicitly_unwrapped_optional
    var folders: FoldersView.FolderModel!
    var coreDataStack: CoreDataStack!
    // swiftlint:enable implicitly_unwrapped_optional

    override func setUp() {
        super.setUp()
        coreDataStack = TestCoreDataStack()
        folders = FoldersView.FolderModel.init(moc: coreDataStack.mainContext)
    }

    override func tearDown() {
        super.tearDown()
        folders = nil
        coreDataStack = nil
    }

    func testDefaultFolder() {
        let folder = folders.getDefaultFolder()
        XCTAssertNotNil(folder, "Folder should not be nil")
        XCTAssertNotNil(folder.id, "Id should not be nil")
    }
    
    func testAddFolder() {
        folders.addNewFolder(name: "Test", isFav: false, color: 1)
        XCTAssertNotNil(folders.folders[0], "Folder should not be nil")
        XCTAssertNotNil(folders.folders[0].id, "Id should not be nil")
        XCTAssertTrue(folders.folders[0].name == "Test")
    }
    
    func testRemoveFolder() {
        folders.addNewFolder(name: "Test", isFav: false, color: 1)
        XCTAssertNotNil(folders.folders[0].id, "Id should not be nil")
        folders.removeFolder(folder: folders.folders[0])
        XCTAssertTrue(folders.folders.isEmpty)
    }
    
    func testEditFolder() {
        folders.addNewFolder(name: "Test1", isFav: false, color: 1)
        XCTAssertTrue(folders.folders[0].name == "Test1")
        XCTAssertTrue(folders.folders[0].isFavorite == false)
        XCTAssertTrue(folders.folders[0].color == 1)
        
        folders.editFolder(folder: folders.folders[0], name: "Test2", isFav: true, color: 2)
        XCTAssertTrue(folders.folders[0].name == "Test2")
        XCTAssertTrue(folders.folders[0].isFavorite == true)
        XCTAssertTrue(folders.folders[0].color == 2)
    }
}


class MemoryTests: XCTestCase {
    // MARK: - Properties
    // swiftlint:disable implicitly_unwrapped_optional
    var testFolder: Folder!
    var testLocation: Location!
    var inputImage: UIImage!
    var memories: MemoriesView.MemoryModel!
    var coreDataStack: CoreDataStack!
    // swiftlint:enable implicitly_unwrapped_optional

    override func setUp() {
        super.setUp()
        inputImage = UIImage(systemName: "cloud")
        coreDataStack = TestCoreDataStack()
        testFolder = FoldersView.FolderModel.init(moc: coreDataStack.mainContext).getDefaultFolder()
        testLocation = LocationSelectView.LocationModel.init(moc: coreDataStack.mainContext).getDefaultLocation()
        memories = MemoriesView.MemoryModel.init(moc: coreDataStack.mainContext, folder: testFolder)
    }

    override func tearDown() {
        super.tearDown()
        inputImage = nil
        memories = nil
        testFolder = nil
        testLocation = nil
        coreDataStack = nil
    }
    
    func testAddMemory() {
        memories.addNewMemory(title: "Memory", place: testLocation, text: "Something", date: Date(), folder: testFolder, image: inputImage, color: 1)
        XCTAssertNotNil(memories.memories[0], "Memory should not be nil")
        XCTAssertNotNil(memories.memories[0].id, "Id should not be nil")
    }

    func testRemoveMemory() {
        memories.addNewMemory(title: "Memory", place: testLocation, text: "Something", date: Date(), folder: testFolder, image: inputImage, color: 1)
        XCTAssertNotNil(memories.memories[0].id, "Id should not be nil")
        memories.removeMemory(memory: memories.memories[0])
        XCTAssertTrue(memories.memories.isEmpty)
    }

    func testEditMemory() {
        memories.addNewMemory(title: "Memory1", place: testLocation, text: "Something1", date: Date(), folder: testFolder, image: inputImage, color: 1)
        XCTAssertTrue(memories.memories[0].title == "Memory1")
        XCTAssertTrue(memories.memories[0].content == "Something1")
        XCTAssertTrue(memories.memories[0].color == 1)

        memories.editMemory(memory: memories.memories[0], text: "Something2", title: "Memory2", place: testLocation, date: Date(), folder: testFolder, color: 2, image: inputImage)
        XCTAssertTrue(memories.memories[0].title == "Memory2")
        XCTAssertTrue(memories.memories[0].content == "Something2")
        XCTAssertTrue(memories.memories[0].color == 2)
    }
}


class LocationTests: XCTestCase {
    // MARK: - Properties
    // swiftlint:disable implicitly_unwrapped_optional
    var locations: LocationSelectView.LocationModel!
    var coreDataStack: CoreDataStack!
    // swiftlint:enable implicitly_unwrapped_optional

    override func setUp() {
        super.setUp()
        coreDataStack = TestCoreDataStack()
        locations = LocationSelectView.LocationModel.init(moc: coreDataStack.mainContext)
    }

    override func tearDown() {
        super.tearDown()
        locations = nil
        coreDataStack = nil
    }
    
    func testAddLocation() {
        let location = locations.addLocation(name: "Test", longitude: 0.0, latitude: 0.0)
        XCTAssertTrue(locations.locations[0] == location)
        XCTAssertNotNil(location, "Location should not be nil")
        XCTAssertNotNil(location.id, "Id should not be nil")
    }

    func testRemoveLocation() {
        let location = locations.addLocation(name: "Test", longitude: 0.0, latitude: 0.0)
        XCTAssertTrue(locations.locations[0] == location)
        locations.removeLocation(location: location)
        XCTAssertTrue(locations.locations.isEmpty)
    }

    func testChangeLocationCoordinates() {
        var location = locations.addLocation(name: "Test1", longitude: 0.0, latitude: 0.0)
        XCTAssertTrue(locations.locations[0].name == "Test1")
        XCTAssertTrue(locations.locations[0].longitude == 0.0)
        XCTAssertTrue(locations.locations[0].latitude == 0.0)

        location = locations.changeLocationCoordinates(location: location, name: "Test2", longitude: 0.1, latitude: 0.1)
        XCTAssertTrue(locations.locations[0].name == "Test2")
        XCTAssertTrue(locations.locations[0].longitude == 0.1)
        XCTAssertTrue(locations.locations[0].latitude == 0.1)
        
    }
}


class UserTests: XCTestCase {
    // MARK: - Properties
    // swiftlint:disable implicitly_unwrapped_optional
    var userData: ProfileView.UserModel!
    var coreDataStack: CoreDataStack!
    var inputImage: UIImage!
    var user: User!
    // swiftlint:enable implicitly_unwrapped_optional

    override func setUp() {
        super.setUp()
        inputImage = UIImage(systemName: "cloud")
        coreDataStack = TestCoreDataStack()
        userData = ProfileView.UserModel.init(moc: coreDataStack.mainContext)
        user = userData.getDefaultUser()
    }

    override func tearDown() {
        super.tearDown()
        inputImage = nil
        user = nil
        userData = nil
        coreDataStack = nil
    }
    
    func testDefaultUser() {
        XCTAssertNotNil(user, "User should not be nil")
        XCTAssertNotNil(user.id, "Id should not be nil")
        XCTAssertTrue(user.name == "User")
    }
    
    func testEditUserData() {
        userData.editUserData(user: user, name: "Test", image: inputImage)
        XCTAssertNotNil(user, "User should not be nil")
        XCTAssertNotNil(user.id, "Id should not be nil")
        XCTAssertTrue(user.name == "Test")
    }

}

