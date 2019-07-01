import Foundation

protocol PostsPersistanceControllerProtocol: PersistanceControllerProtocol {
    func save(_ posts: [Post])
    func load() -> [Post]
}
