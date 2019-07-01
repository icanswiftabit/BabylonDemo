import Foundation
import RxSwift

protocol DetailTaskKitProtocol {
    func getUsersRequest() -> Observable<URLRequest>
    func getCommentsRequest() -> Observable<URLRequest>
}
