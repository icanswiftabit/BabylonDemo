import Foundation
import RxSwift
import World

class PostTaskKit: PostTaskKitProtocol {
    func getPostsRequest() -> Observable<URLRequest> {
        let path = "/posts"

        return Observable.deferred {
            guard let url = URL(string: "\(String(describing: Current.baseURL()))\(path)") else {
                return .error(TaskKitError.urlError)
            }

            var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
            request.httpMethod = "GET"

            return .just(request)
        }
    }
}
