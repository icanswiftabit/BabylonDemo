import Foundation
import RxSwift

protocol PostsNetworkCotrollerProtocol: NetworkControllerProtocol {
    var taskKit: PostTaskKitProtocol { get }
    func fetchPosts() -> Observable<[Post]>
}

