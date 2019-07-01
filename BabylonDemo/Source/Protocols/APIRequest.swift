import Foundation
import World
import RxSwift

enum APIRequestError: Error {
    case urlError
}

struct APIRequest {

    let path: String

    func createRequest() -> Observable<URLRequest> {
        return Observable.deferred {
            guard let url = URL(string: "\(String(describing: Current.baseURL()))\(self.path)") else {
                return .error(APIRequestError.urlError)
            }

            var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
            request.httpMethod = "GET"

            return .just(request)
        }
    }
}
