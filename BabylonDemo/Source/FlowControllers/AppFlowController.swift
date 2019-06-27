import UIKit

final class AppFlowController: FlowController {
    typealias RootViewController = UINavigationController
    let rootViewController = UINavigationController()

    private let postViewController = PostsViewController()

    func configuredMainViewController() -> UINavigationController {
        rootViewController.viewControllers = [postViewController]
        return rootViewController
    }

    func embedRootViewController(in window: UIWindow) {
        window.rootViewController = configuredMainViewController()
        window.makeKeyAndVisible()
    }
    
}
