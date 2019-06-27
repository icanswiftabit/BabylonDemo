import Foundation

public protocol WorldProtocol {
    var baseURL: String { get }
}

public struct World {
    public var baseURL = { "" }
}

public var Current = World()
