import Foundation
import RxSwift

enum TaskKitError: Error {
    case urlError
}

protocol TaskKitProtocol {}

protocol PostTaskKitProtocol: TaskKitProtocol {
    func getPostsRequest() -> Observable<URLRequest>
}
