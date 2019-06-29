import UIKit

final class AppFlowController: FlowController {
    typealias RootViewController = UINavigationController
    let rootViewController = UINavigationController()
    private let postsFlowController = PostsFlowController()

    func configuredMainViewController() -> UINavigationController {
        rootViewController.navigationBar.prefersLargeTitles = true
        rootViewController.viewControllers = [postsFlowController.rootViewController]
        return rootViewController
    }

    func embedRootViewController(in window: UIWindow) {
        window.rootViewController = configuredMainViewController()
        window.makeKeyAndVisible()
    }
}
