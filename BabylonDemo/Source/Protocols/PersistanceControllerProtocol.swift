import Foundation

protocol PersistanceControllerProtocol {
    var userDefaults: UserDefaults { get }

    // Saves Storeable object of type
    func save<T: Storeable>(_ objectsForSave: [T]) throws

    // Loads all Storeable of type
    func load<T: Storeable>(_ type: T.Type) throws -> [T]

    // Loads Storeable object of type with ID
    func load<T: Storeable>(_ type: T.Type, id: Int) throws -> T?

    // Removes Storeable objects of type with ID
    func remove<T: Storeable>(_ type: T.Type, id: Int) throws

    // Removes all Storeable objects of type
    func remove<T: Storeable>(_ type: T.Type)
}
