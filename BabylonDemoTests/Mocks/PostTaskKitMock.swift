import Foundation
import RxSwift
@testable import BabylonDemo

final class PostTaskKitMock: PostTaskKitProtocol {
    let request = URLRequest(url: URL(string: "http://fixed.url")!)
    func getPostsRequest() -> Observable<URLRequest> { return .just(request) }
}
