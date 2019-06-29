import Foundation

struct Post: Codable, Hashable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
