import UIKit

final class AppFlowController: FlowController {
    typealias RootViewController = UINavigationController
    let rootViewController = UINavigationController()

    private(set) lazy var postsViewController: PostsViewController = {
        return configurePostViewController()
    }()

    func configuredMainViewController() -> UINavigationController {
        rootViewController.navigationBar.prefersLargeTitles = true
        rootViewController.viewControllers = [postsViewController]
        return rootViewController
    }

    func embedRootViewController(in window: UIWindow) {
        window.rootViewController = configuredMainViewController()
        window.makeKeyAndVisible()
    }

    func configurePostViewController() -> PostsViewController {
        let networkController = PostsNetworkController()
        let viewModel = PostsViewModel(networkController: networkController)
        let onPostTapAction = createOnPostTap()
        return PostsViewController(viewModel: viewModel, onPostTapAction: onPostTapAction)
    }

    func createOnPostTap() -> FlowAction<IndexPath> {
        return FlowAction<IndexPath> { indexPath in
            Logger.debug("selected post \(indexPath.row)")
        }
    }
}
