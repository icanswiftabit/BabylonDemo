import Foundation
import RxSwift
import RxCocoa

final class PostsViewModel: NSObject {

    let posts = BehaviorSubject<[Post]>(value: [])
    fileprivate let shouldReloadPosts = BehaviorRelay<Bool>(value: true)

    private let networkController: PostsNetworkCotrollerProtocol
    private let bag = DisposeBag()

    init(networkController: PostsNetworkCotrollerProtocol) {
        self.networkController = networkController
    }

    func fetchPosts() {
        networkController
            .fetchPosts()
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
                self.posts.onNext(fetchedPosts)
            }
            .disposed(by: bag)
    }
}

extension Reactive where Base: PostsViewModel {
    var reloadPosts: ControlEvent<Bool> {
        return ControlEvent(events: base.shouldReloadPosts)
    }
}
