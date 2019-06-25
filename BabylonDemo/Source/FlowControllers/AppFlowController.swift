import UIKit

final class AppFlowController: FlowController {
    typealias RootViewController = UINavigationController
    let rootViewController = UINavigationController()

    private let firstViewController: UIViewController = {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .green
        return viewController
    }()

    func configuredMainViewController() -> UINavigationController {
        rootViewController.viewControllers = [firstViewController]
        return rootViewController
    }

    func embedRootViewController(in window: UIWindow) {
        window.rootViewController = configuredMainViewController()
        window.makeKeyAndVisible()
    }
    
}
