import Foundation
import RxSwift

enum DetailNetworkControllerError: Error {
    case userNotFound

    var localizedDescription: String {
        switch self {
        case .userNotFound: return "User not found"
        }
    }
}

final class DetailNetworkController: DetailNetworkControllerProtocol {

    var taskKit: DetailTaskKitProtocol
    var session: URLSession


    init(with taskKit: DetailTaskKitProtocol = DetailTaskKit(), in session: URLSession = .shared) {
        self.taskKit = taskKit
        self.session = session
    }

    init(with session: URLSession = .shared) {
        self.taskKit = DetailTaskKit()
        self.session = session
    }

    func fetchUsers(withId userId: Int) -> Observable<User> {
        return fetch(request: taskKit.getUsersRequest())
            .flatMap { data -> Observable<User> in
                do {
                    let users = try JSONDecoder().decode([User].self, from: data)
                    guard let requestedUser = users.first(where: { $0.id == userId }) else {
                        return .error(DetailNetworkControllerError.userNotFound)
                    }
                    
                    return .just(requestedUser)
                } catch {
                    return .error(NetworkControllerError.responseSerializationError)
                }
            }
    }

    func fetchComments(forPostId postId: Int) -> Observable<[Comment]> {
        return fetch(request: taskKit.getCommentsRequest())
            .flatMap { data -> Observable<[Comment]> in
                do {
                    let comments = try JSONDecoder().decode([Comment].self, from: data)
                    let requestedComments = comments.filter({ $0.postId == postId })

                    return .just(requestedComments)
                } catch {
                    return .error(NetworkControllerError.responseSerializationError)
                }
            }
    }

}
