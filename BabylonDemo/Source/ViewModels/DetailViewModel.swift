import UIKit
import RxCocoa
import RxSwift

final class DetailViewModel: NSObject {

    let post: BehaviorSubject<Post>
    let user: PublishSubject<User?>
    let commentsCount: PublishSubject<Int>

    private let networkController: DetailNetworkControllerProtocol
    private let bag = DisposeBag()

    init(with post: Post, networkController: DetailNetworkControllerProtocol) {
        self.post = BehaviorSubject<Post>(value: post)
        self.user = PublishSubject<User?>()
        self.commentsCount = PublishSubject<Int>()
        self.networkController = networkController
    }

    func fetchDetails() {
        guard let post = try? post.value() else { return }

        let commentsFetchSignal = networkController.fetchComments(forPostId: post.id)
        let usersFetchSignal = networkController.fetchUsers(withId: post.userId)

        Observable.zip(usersFetchSignal, commentsFetchSignal) { (user: User, comments: [Comment]) -> (user: User, comments: [Comment]) in
                return (user, comments)
            }
            .bind { result in

                self.user.onNext(result.user)
                self.commentsCount.onNext(result.comments.count)
            }
            .disposed(by: bag)
    }
}
