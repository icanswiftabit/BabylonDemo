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
            .catchError { error -> Observable<[Post]> in
                self.errorMessage.accept(error.localizedDescription)
                return self.posts.asObservable()
            }
            .subscribe { eventPosts in
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
}

extension Reactive where Base: PostsViewModel {
    var reloadPosts: ControlEvent<Bool> {
        return ControlEvent(events: base.shouldReloadPosts)
    }

    var errorOcure: ControlEvent<String> {
        return ControlEvent(events: base.errorMessage)
    }
}
