import Foundation

protocol PersistanceControllerProtocol {
    var userDefaults: UserDefaults { get }
    func save(_ data: Data, with key: String)
    func load(with key: String) -> Data?
}

extension PersistanceControllerProtocol {
    func save(_ data: Data, with key: String) {
        userDefaults.set(data, forKey: key)
    }

    func load(with key: String) -> Data? {
        return userDefaults.data(forKey: key)
    }
}
