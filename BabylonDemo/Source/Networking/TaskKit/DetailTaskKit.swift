import Foundation
import RxSwift

final class DetailTaskKit: DetailTaskKitProtocol {

    func getUsersRequest() -> Observable<URLRequest> {
        let path = "/users"
        return APIRequest(path: path).createRequest()
    }

    func getCommentsRequest() -> Observable<URLRequest> {
        let path = "/comments"

        return APIRequest(path: path).createRequest()
    }
}
