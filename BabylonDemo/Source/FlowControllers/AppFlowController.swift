import UIKit

final class AppFlowController: FlowController {
    typealias RootViewController = UINavigationController
    let rootViewController = UINavigationController()

    private(set) lazy var postViewController: PostsViewController = {
        let networkController = PostsNetworkController()
        let viewModel = PostsViewModel(networkController: networkController)
        return PostsViewController(viewModel: viewModel)
    }()

    func configuredMainViewController() -> UINavigationController {
        rootViewController.navigationBar.prefersLargeTitles = true
        rootViewController.viewControllers = [postViewController]
        return rootViewController
    }

    func embedRootViewController(in window: UIWindow) {
        window.rootViewController = configuredMainViewController()
        window.makeKeyAndVisible()
    }
}
