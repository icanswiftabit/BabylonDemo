import Foundation
import RxCocoa
import RxSwift
import World

protocol NetworkTaskKitProtocol {
}

protocol NetworkControllerProtocol {
    associatedtype TaskKitType
    var taskKit: TaskKitType { get }
    var session: URLSession { get }
}

protocol PostTaskKitProtocol: NetworkTaskKitProtocol {
    func getPostsRequest() -> URLRequest
}

protocol PostsNetworkCotrollerProtocol: NetworkControllerProtocol {
    func fetchPosts() -> Observable<Any> // to be change to `Observable<[Post]>`
}

final class PostTaskKit: PostTaskKitProtocol {
    func getPostsRequest() -> URLRequest {
        let url = URL(string: "\(String(describing: Current.baseURL()))/posts")! // Use guard or something
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)

        return request
    }
}

final class PostsNetworkController: PostsNetworkCotrollerProtocol {
    typealias TaskKitType = PostTaskKitProtocol
    let taskKit: TaskKitType
    let session: URLSession

    init(with taskKit: TaskKitType = PostTaskKit(), in session: URLSession = .shared) {
        self.taskKit = taskKit
        self.session = session
    }

    func fetchPosts() -> Observable<Any> {
       return session.rx
            .json(request: taskKit.getPostsRequest())
    }
}
