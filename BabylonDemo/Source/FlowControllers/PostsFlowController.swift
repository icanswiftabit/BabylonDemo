import UIKit

final class PostsFlowController: FlowController {

    typealias RootViewController = PostsViewController
    lazy var rootViewController: RootViewController = configurePostViewController()
}

private extension PostsFlowController {

    func configuredPostsViewController() -> RootViewController {
        return configurePostViewController()
    }

    func configurePostViewController() -> PostsViewController {
        let networkController = PostsNetworkController()
        let viewModel = PostsViewModel(networkController: networkController)
        let onPostTapAction = createOnPostTap()
        
        return PostsViewController(viewModel: viewModel, onPostTapAction: onPostTapAction)
    }

    func configureDetailsViewController(with post: Post) -> DetailViewController {
        let networkController = DetailNetworkController()
        let viewModel = DetailViewModel(with: post, networkController: networkController)

        return DetailViewController(viewModel: viewModel)
    }

    func createOnPostTap() -> FlowAction<Post> {
        return FlowAction<Post> { post in
            Logger.debug("selected post \(post.id)")
            let detailView = self.configureDetailsViewController(with: post)
            self.rootViewController.navigationController?.pushViewController(detailView, animated: true)
        }
    }
}
