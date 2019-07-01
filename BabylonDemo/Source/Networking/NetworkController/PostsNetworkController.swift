import UIKit
import RxCocoa
import RxSwift

final class PostsNetworkController: PostsNetworkCotrollerProtocol {

    let session: URLSession
    let taskKit: PostTaskKitProtocol

    init(with taskKit: PostTaskKitProtocol = PostTaskKit(), in session: URLSession = .shared) {
        self.taskKit = taskKit
        self.session = session
    }

    init(with session: URLSession = .shared) {
        self.taskKit = PostTaskKit()
        self.session = session
    }

    func fetchPosts() -> Observable<[Post]> {
        return fetch(request: taskKit.getPostsRequest())
            .flatMap { data -> Observable<[Post]> in
                do {
                    return .just(try JSONDecoder().decode([Post].self, from: data))
                } catch {
                    return .error(NetworkControllerError.responseSerializationError)
                }
            }
    }
}
