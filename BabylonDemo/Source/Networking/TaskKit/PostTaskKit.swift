import Foundation
import RxSwift
import World

final class PostTaskKit: PostTaskKitProtocol {

    func getPostsRequest() -> Observable<URLRequest> {
        let path = "/posts"

        return APIRequest(path: path).createRequest()
    }
}
