import UIKit
import RxCocoa
import RxSwift

final class DetailViewModel: NSObject {

    typealias PostDetails = (user: User, comments: [Comment])

    let post: BehaviorSubject<Post>
    let user: BehaviorSubject<User?>
    let comments: BehaviorSubject<[Comment]>
    fileprivate let errorMessage = BehaviorRelay<String>(value: "")

    private let networkController: DetailNetworkControllerProtocol
    private let persistanceController: PersistanceControllerProtocol!
    private let bag = DisposeBag()

    init(with post: Post, networkController: DetailNetworkControllerProtocol, persistanceController: PersistanceControllerProtocol = PersistanceController()) {

        self.post = BehaviorSubject<Post>(value: post)

        let storedUser = try? persistanceController
            .load(User.self, id: post.userId)

        self.user = BehaviorSubject<User?>(value: storedUser)

        let storedComments = try? persistanceController
            .load(Comment.self)
            .filter { $0.postId == post.id }
            .sorted { $0.id < $1.id }
            
        self.comments = BehaviorSubject<[Comment]>(value: storedComments ?? [Comment]())

        self.networkController = networkController
        self.persistanceController = persistanceController

        super.init()
        setUpPersistanceBinding()
    }

    func fetchDetails() {
        guard let post = try? post.value() else { return }

        let commentsFetchSignal = networkController.fetchComments(forPostId: post.id)
        let usersFetchSignal = networkController.fetchUsers(withId: post.userId)

        Observable.zip(usersFetchSignal, commentsFetchSignal) { (user: User, comments: [Comment]) -> PostDetails in
                return (user, comments)
            }
            .catchError { [weak self] error -> Observable<PostDetails> in
                guard let self = self else { return .empty() }
                self.errorMessage.accept(error.localizedDescription)
                return .empty()
            }
            .subscribe(onNext: { [weak self] postDetails in
                guard let self = self else { return }

                guard let currentUserHash = try? self.user.value().hashValue,
                      currentUserHash != postDetails.user.hashValue,
                      let currentCommentsHash = try? self.comments.value().hashValue,
                      currentCommentsHash != postDetails.comments.hashValue
                else {
                    Logger.debug("Nothing new here")
                    return
                }
                Logger.debug("Oh shiny")
                self.user.onNext(postDetails.user)
                self.comments.onNext(postDetails.comments)
            })
            .disposed(by: bag)
    }
}

private extension DetailViewModel {
    func setUpPersistanceBinding() {

        let userSignal = user.asObservable().skip(1)
        let commentsSingal = comments.asObservable().skip(1)

        Observable.combineLatest(userSignal, commentsSingal) { (user: User?, comments: [Comment]) -> (user: User?, comments: [Comment]) in
                return (user, comments)
            }
            .asObservable()
            .subscribe(onNext: {
                Logger.debug("New detail post for save")
                do {
                    if let savedUser = $0.user {
                        try self.persistanceController.save([savedUser])
                    }
                    try self.persistanceController.save($0.comments)
                } catch let error {
                    self.errorMessage.accept(error.localizedDescription)
                }
            })
            .disposed(by: bag)

    }
}

extension Reactive where Base: DetailViewModel {
    var errorOccured: ControlEvent<String> {
        return ControlEvent(events: base.errorMessage)
    }
}
