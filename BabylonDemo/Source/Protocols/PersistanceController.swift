import Foundation

protocol PersistanceControllerProtocol {
    func save(_ data: Data)
    func load() -> Data
}
