import Foundation

final class PersistanceController: PersistanceControllerProtocol {

    let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    // Saves Storeable object of type
    func save<T: Storeable>(_ objectsForSave: [T]) throws {
        let uniqueObjects = objectsForSave.lastUnique()

        var loadedObjects = try load(T.self)

        loadedObjects.removeAll { loadedObject in
            uniqueObjects.contains {  $0.id == loadedObject.id }
        }
        loadedObjects.append(contentsOf: uniqueObjects)

        let dataToStore = try JSONEncoder().encode(loadedObjects)
        userDefaults.set(dataToStore, forKey: T.storeKey)
    }

    // Loads all Storeable of type
    func load<T: Storeable>(_ type: T.Type) throws -> [T]{
        guard let dataToDecode = userDefaults.data(forKey: T.storeKey) else {
            return [T]()
        }
        return try JSONDecoder().decode([T].self, from: dataToDecode)
    }

    // Loads Storeable object of type with ID
    func load<T: Storeable>(_ type: T.Type, id: Int) throws -> T? {
        let loadedObjects = try load(T.self)
        return loadedObjects.first { $0.id == id }

    }

    // Removes Storeable objects of type with ID
    func remove<T: Storeable>(_ type: T.Type, id: Int) throws {
        var loadedObjects = try load(T.self)
        loadedObjects.removeAll { $0.id == id }

        let dataToStore = try JSONEncoder().encode(loadedObjects)
        userDefaults.set(dataToStore, forKey: T.storeKey)
    }

    // Removes all Storeable objects of type
    func remove<T: Storeable>(_ type: T.Type) {
        userDefaults.removeObject(forKey: T.storeKey)
    }
}
