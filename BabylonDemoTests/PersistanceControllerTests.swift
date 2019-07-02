import XCTest
@testable import BabylonDemo

final class PersistanceControllerTests: XCTestCase {

    struct StoreableMock: Storeable {
        let id: Int
        let name: String
    }

    var sut: PersistanceController!
    var userDefaults: UserDefaults!

    override func setUp() {
        super.setUp()

        userDefaults = .test
        userDefaults.removeObject(forKey: StoreableMock.storeKey)
        sut = PersistanceController(userDefaults: userDefaults) 
    }

    override func tearDown() {
        userDefaults.removeObject(forKey: StoreableMock.storeKey)
        userDefaults = nil
        sut = nil
        
        super.tearDown()
    }

    func test_shouldSaveAndLoadStoreableObject() {

        // Arrange
        let expectedObjects = [
            StoreableMock(id: 1, name: "first"),
            StoreableMock(id: 2, name: "second"),
            StoreableMock(id: 3, name: "third")
        ]

        // Act
        try! sut.save(expectedObjects)
        let loadedObjects = try! sut.load(StoreableMock.self).sorted { $0.id < $1.id }

        // Assert
        XCTAssertEqual(loadedObjects, expectedObjects)
    }

    func test_shouldLoadStoreableObject_withGivenID() {

        // Arrange
        let expectedObjects = [
            StoreableMock(id: 1, name: "first"),
            StoreableMock(id: 2, name: "second"),
            StoreableMock(id: 3, name: "third")
        ]

        // Act
        try! sut.save(expectedObjects)
        let loadedObject = try! sut.load(StoreableMock.self, id: 2)

        // Assert
        XCTAssertEqual(loadedObject!, expectedObjects[1])
    }

    func testSave_shouldOmmitObject_withSimilarId() {

        // Arrange
        let objectsForSave = [
            StoreableMock(id: 1, name: "first"),
            StoreableMock(id: 2, name: "second"),
            StoreableMock(id: 3, name: "third"),
            StoreableMock(id: 1, name: "fourth"),
            StoreableMock(id: 2, name: "fifth")
        ]

        let expectedObjects = [
            StoreableMock(id: 1, name: "fourth"),
            StoreableMock(id: 2, name: "fifth"),
            StoreableMock(id: 3, name: "third")
        ]

        // Act
        try! sut.save(objectsForSave)
        let loadedObjects = try! sut.load(StoreableMock.self).sorted { $0.id < $1.id }


        // Assert
        XCTAssertEqual(loadedObjects, expectedObjects)
    }

    func testSave_shouldAppendObjects() {

        // Arrange
        let objectsForSave1 = [
            StoreableMock(id: 1, name: "first"),
            StoreableMock(id: 2, name: "second")
        ]

        let objectsForSave2 = [
            StoreableMock(id: 3, name: "first"),
            StoreableMock(id: 4, name: "second")
        ]

        let objectsForSave3 = [
            StoreableMock(id: 5, name: "first"),
            StoreableMock(id: 6, name: "second")
        ]

        let expectedObjects = [
            StoreableMock(id: 1, name: "first"),
            StoreableMock(id: 2, name: "second"),
            StoreableMock(id: 3, name: "first"),
            StoreableMock(id: 4, name: "second"),
            StoreableMock(id: 5, name: "first"),
            StoreableMock(id: 6, name: "second")
        ]

        // Act
        try! sut.save(objectsForSave1)
        try! sut.save(objectsForSave2)
        try! sut.save(objectsForSave3)

        let loadedObjects = try! sut.load(StoreableMock.self).sorted { $0.id < $1.id }


        // Assert
        XCTAssertEqual(loadedObjects, expectedObjects)
    }

    func testSave_shouldUpdateObjects() {

        // Arrange
        let objectsForSave = [
            StoreableMock(id: 1, name: "first"),
            StoreableMock(id: 2, name: "second")
        ]

        let objectsForUpdate = [
            StoreableMock(id: 1, name: "third"),
        ]

        let expectedObjects = [
            StoreableMock(id: 1, name: "third"),
            StoreableMock(id: 2, name: "second")
        ]
        let expectedObject = StoreableMock(id: 1, name: "third")

        // Act
        try! sut.save(objectsForSave)
        try! sut.save(objectsForUpdate)

        let loadedObjects = try! sut.load(StoreableMock.self).sorted { $0.id < $1.id }
        let loadedObject = try! sut.load(StoreableMock.self, id: 1)

        // Assert
        XCTAssertEqual(loadedObjects, expectedObjects)
        XCTAssertEqual(loadedObject, expectedObject)
    }


    func testLoad_shouldReturnNil_whenIDWasNotFound() {

        // Arrange
        let objectsForSave = [
            StoreableMock(id: 1, name: "first"),
            StoreableMock(id: 3, name: "third")
        ]

        // Act
        try! sut.save(objectsForSave)
        let loadedObject = try! sut.load(StoreableMock.self, id: 2)

        // Assert
        XCTAssertNil(loadedObject)
    }

    func testRemove_shouldRemoveObject_withGivenID() {
        // Arrange
        let objectsForSave = [
            StoreableMock(id: 1, name: "first"),
            StoreableMock(id: 3, name: "third")
        ]

        let expectedObjects = [
            StoreableMock(id: 1, name: "first")
        ]

        try! sut.save(objectsForSave)

        // Act
        try! sut.remove(StoreableMock.self, id: 3)
        let loadedObject = try! sut.load(StoreableMock.self)

        // Assert
        XCTAssertEqual(loadedObject, expectedObjects)
    }

    func testRemove_shouldRemoveAllObjects() {
        // Arrange
        let objectsForSave = [
            StoreableMock(id: 1, name: "first"),
            StoreableMock(id: 3, name: "third")
        ]

        let expectedObjects = [StoreableMock]()

        try! sut.save(objectsForSave)

        // Act
        sut.remove(StoreableMock.self)
        let loadedObject = try! sut.load(StoreableMock.self)

        // Assert
        XCTAssertEqual(loadedObject, expectedObjects)
    }
}
