import Foundation
import RxSwift

protocol DetailNetworkControllerProtocol: NetworkControllerProtocol {
    var taskKit: DetailTaskKitProtocol { get }
    func fetchUsers(withId: Int) -> Observable<User>
    func fetchComments(forPostId: Int) -> Observable<[Comment]>
}
