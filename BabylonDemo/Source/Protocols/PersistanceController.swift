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

protocol PostsPersistanceControllerProtocol: PersistanceControllerProtocol {
    func save(_ posts: [Post])
    func load() -> [Post]
}

final class PostsPersistanceController: PostsPersistanceControllerProtocol {
    let userDefaults = UserDefaults.standard

    struct Constants {
        static let postsKey = "persistedPosts"
    }

    func save(_ posts: [Post]) {
        guard let postsData = try? JSONEncoder().encode(posts) else { return }
        save(postsData, with: Constants.postsKey )
    }

    func load() -> [Post] {
        guard let postsData = load(with: Constants.postsKey),
              let posts = try? JSONDecoder().decode([Post].self, from: postsData)
        else {
            return [Post]()
        }
        return posts
    }
}
