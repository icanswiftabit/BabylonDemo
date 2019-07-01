import UIKit
import RxSwift

final class DetailViewController: UIViewController {

    private let detailView = DetailView()
    private let detailViewModel: DetailViewModel
    private let bag = DisposeBag()

    init(viewModel: DetailViewModel) {
        detailViewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        title = "Details"
        setUpBinding()
        setUpDetailView()
    }

    @available(*, unavailable, message: "Please use init(with:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        detailViewModel.fetchDetails()
    }
}

private extension DetailViewController {
    func setUpBinding() {
        detailViewModel.post.debug()
            .flatMap { post -> Observable<String> in
                return .just(post.title)
            }
            .bind(to: detailView.rx.title)
            .disposed(by: bag)

        detailViewModel.post.debug()
            .flatMap { post -> Observable<String> in
                return .just(post.body)
            }
            .bind(to: detailView.rx.body)
            .disposed(by: bag)

        let user = detailViewModel.user
        let commentsCount = detailViewModel.commentsCount

        Observable
            .zip(user, commentsCount) { (user, commentsCount) -> (user: User?, commentsCount: Int) in
                return (user, commentsCount)
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { result in
                self.detailView.rx.name.onNext(result.user?.name)
                self.detailView.rx.username.onNext(result.user?.username)
                self.detailView.rx.commentCount.onNext(result.commentsCount)

            }, onError: { error in
                self.handleError(with: error.localizedDescription)
            })
            .disposed(by: bag)

    }

    func setUpDetailView() {
//        view.addSubview(detaiView)
//        let refreshControl = UIRefreshControl(frame: .zero)
//        refreshControl.addTarget(self, action: #selector(reloadPosts), for: .valueChanged)
//        detailViewModel.refreshControl = refreshControl
    }

    func handleError(with msg: String) {
        let alert = UIAlertController(title: "Ups something went wrong", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}
