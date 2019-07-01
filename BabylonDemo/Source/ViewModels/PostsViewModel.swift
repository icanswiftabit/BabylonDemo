import Foundation
import RxSwift
import RxCocoa

final class PostsViewModel: NSObject {

    let posts: BehaviorSubject<[Post]>
    fileprivate let shouldReloadPosts = BehaviorRelay<Bool>(value: true)
    fileprivate let errorMessage = BehaviorRelay<String>(value: "")

    private let networkController: PostsNetworkCotrollerProtocol
    private let persistanceController: PostsPersistanceControllerProtocol
    private let bag = DisposeBag()

    init(networkController: PostsNetworkCotrollerProtocol,
         persistanceController: PostsPersistanceControllerProtocol = PostsPersistanceController()) {

        self.networkController = networkController
        self.persistanceController = persistanceController

        let storedPosts = persistanceController.load()
        posts = BehaviorSubject<[Post]>(value: storedPosts)
    }

    func fetchPosts() {
        networkController
            .fetchPosts()
            .catchError { [weak self] error -> Observable<[Post]> in
                guard let self = self else { return .empty() }
                self.errorMessage.accept(error.localizedDescription)
                return self.posts.asObservable()
            }
            .subscribe { [weak self] eventPosts in
                guard let self = self else { return }

                guard let fetchedPosts = eventPosts.element,
                      let currentPostsHash = try? self.posts.value().hashValue,
                      currentPostsHash != fetchedPosts.hashValue
                else {
                    Logger.debug("Nothing new here")
                    self.shouldReloadPosts.accept(true)
                    return
                }
                Logger.debug("Oh shiny")
                self.shouldReloadPosts.accept(true)
                self.persistanceController.save(fetchedPosts)
                self.posts.onNext(fetchedPosts)
            }
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

extension Reactive where Base: PostsViewModel {
    var reloadPosts: ControlEvent<Bool> {
        return ControlEvent(events: base.shouldReloadPosts)
    }

    var errorOcure: ControlEvent<String> {
        return ControlEvent(events: base.errorMessage)
    }
}
