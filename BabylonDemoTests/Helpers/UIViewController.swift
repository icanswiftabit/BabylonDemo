import UIKit

extension UIViewController {
    var embededInNavigationController: UINavigationController {
        let navigationController = UINavigationController(rootViewController: self)
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }
}
