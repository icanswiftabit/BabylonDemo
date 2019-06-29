import UIKit
import RxSwift
import RxCocoa

final class PostsViewController: UIViewController {

    private let postsView: UICollectionView
    private let postsViewModel: PostsViewModel
    private let onPostTap: FlowAction<IndexPath>
    private let bag = DisposeBag()

    init(viewModel: PostsViewModel, onPostTapAction: FlowAction<IndexPath>) {
        postsViewModel = viewModel

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 8.0
        postsView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)

        onPostTap = onPostTapAction

        super.init(nibName: nil, bundle: nil)

        title = "Posts"
        setUpPostsView()
        setUpBinding()
    }

    @available(*, unavailable, message: "Please use init() instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = postsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        postsViewModel.fetchPosts()
    }


    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard case UIEvent.EventSubtype.motionShake = motion else { return }
        Logger.debug("shake")
        postsViewModel.fetchPosts()
    }
}

extension PostsViewController: UICollectionViewDataSource & UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (try? postsViewModel.posts.value().count) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(PostCell.self, at: indexPath)
        cell.title = try? postsViewModel.posts.value()[indexPath.row].title
        return cell
    }
}

extension PostsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: postsView.frame.width, height: PostCell.defaultSize.height)
    }
}

private extension PostsViewController {
    func setUpBinding() {
        postsViewModel.rx.reloadPosts.observeOn(MainScheduler.instance).bind { shouldReloadPost in
            self.postsView.refreshControl?.endRefreshing()

            guard shouldReloadPost else { return }
            self.postsView.reloadData()
        }
        .disposed(by: bag)

        postsView.rx
            .itemSelected
            .asDriver()
            .drive(onPostTap)
            .disposed(by: bag)
    }

    func setUpPostsView() {
        postsView.delegate = self
        postsView.dataSource = self
        postsView.alwaysBounceVertical = true
        postsView.backgroundColor = .gray
        postsView.register(PostCell.self)

        let refreshControl = UIRefreshControl(frame: .zero)
        refreshControl.addTarget(self, action: #selector(reloadPosts), for: .valueChanged)
        postsView.refreshControl = refreshControl
    }

    @objc func reloadPosts() {
        Logger.debug("reload")
        postsViewModel.fetchPosts()
    }
}
