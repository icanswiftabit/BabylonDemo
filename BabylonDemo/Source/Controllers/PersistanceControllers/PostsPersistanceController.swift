import Foundation

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
