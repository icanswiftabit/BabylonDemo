import UIKit
import RxSwift

final class PostsViewController: UIViewController {

    private let postsView = PostsView()
    private let networkController = PostsNetworkController()
    private let bag = DisposeBag()

    override func loadView() {
        view = postsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Should be moved to model, there saved and updated in here?
    networkController.fetchPosts()
        .debug()
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { json in
            print(json)
        }, onError: { error in
            print(error)
        })
        .disposed(by: bag)

    }

}
