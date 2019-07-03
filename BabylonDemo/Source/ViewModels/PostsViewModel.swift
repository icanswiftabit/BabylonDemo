import Foundation
import RxSwift
import RxCocoa

final class PostsViewModel: NSObject {

    let posts: BehaviorSubject<[Post]>
    fileprivate let shouldReloadPosts = BehaviorRelay<Bool>(value: true)
    fileprivate let errorMessage = BehaviorRelay<String>(value: "")

    private let networkController: PostsNetworkControllerProtocol
    private let persistanceController: PersistanceControllerProtocol!
    private let bag = DisposeBag()

    init(networkController: PostsNetworkControllerProtocol, persistanceController: PersistanceControllerProtocol = PersistanceController()) {

        self.networkController = networkController
        self.persistanceController = persistanceController

        let storedPosts = try? persistanceController
            .load(Post.self)
            .sorted { $0.id < $1.id }

        posts = BehaviorSubject<[Post]>(value: storedPosts ?? [Post]() )

        super.init()
        setUpPersistanceBinding()
    }

    func fetchPosts() {
        networkController
            .fetchPosts()
            .catchError { [weak self] error -> Observable<[Post]> in
                guard let self = self else { return .empty() }
                self.errorMessage.accept(error.localizedDescription)
                return self.posts.asObservable()
            }
            .subscribe(onNext: { [weak self] fetchedPosts in
                guard let self = self else { return }

                guard let currentPostsHash = try? self.posts.value().hashValue,
                      currentPostsHash != fetchedPosts.hashValue
                else {
                    Logger.debug("Nothing new here")
                    self.shouldReloadPosts.accept(false)
                    return
                }
                Logger.debug("Oh shiny")
                self.shouldReloadPosts.accept(true)
                self.posts.onNext(fetchedPosts)
            })
            .disposed(by: bag)
    }

    func post(at index: Int) -> Observable<Post> {
        return Observable.deferred {
            do {
                return .just(try self.posts.value()[index])
            } catch let error {
                return .error(error)
            }
        }
    }
}

private extension PostsViewModel {
    func setUpPersistanceBinding() {

        posts
            .asObservable()
            .subscribe(onNext: {
                Logger.debug("New post for save")
                do {
                    try self.persistanceController.save($0)
                } catch let error {
                    self.errorMessage.accept(error.localizedDescription)
                }
            })
            .disposed(by: bag)

    }
}

extension Reactive where Base: PostsViewModel {
    var reloadPosts: ControlEvent<Bool> {
        return ControlEvent(events: base.shouldReloadPosts)
    }

    var errorOccured: ControlEvent<String> {
        return ControlEvent(events: base.errorMessage)
    }
}
