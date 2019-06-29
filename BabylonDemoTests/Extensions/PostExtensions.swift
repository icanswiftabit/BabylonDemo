@testable import BabylonDemo

extension Post {
    static func mock(id: Int) -> Post {
        return Post(userId: 1, id: id, title: "title \(id)", body: "body \(id)")
    }
}
