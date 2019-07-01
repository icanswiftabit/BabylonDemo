import UIKit

final class AppController {

    let rootViewController = UINavigationController()
    private let postsFlowController = PostsFlowController()

    func embedRootViewController(in window: UIWindow) {
        window.rootViewController = configuredRootViewController()
        window.makeKeyAndVisible()
    }
}

private extension AppController {

    func configuredRootViewController() -> UINavigationController {
        rootViewController.navigationBar.prefersLargeTitles = true
        rootViewController.viewControllers = [postsFlowController.rootViewController]
        return rootViewController
    }
}
