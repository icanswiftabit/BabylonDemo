import Foundation

protocol Storeable: Codable, Hashable {
    static var storeKey: String { get }
    var id: Int { get }
}

extension Storeable {
    static var storeKey: String {
        return String(describing: Self.self)
    }
}
