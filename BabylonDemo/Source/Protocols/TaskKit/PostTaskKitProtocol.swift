import Foundation
import RxSwift

protocol PostTaskKitProtocol {
    func getPostsRequest() -> Observable<URLRequest>
}
