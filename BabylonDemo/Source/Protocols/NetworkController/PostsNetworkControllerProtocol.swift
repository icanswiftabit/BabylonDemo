import Foundation
import RxSwift

protocol PostsNetworkControllerProtocol: NetworkControllerProtocol {
    var taskKit: PostTaskKitProtocol { get }
    func fetchPosts() -> Observable<[Post]>
}

