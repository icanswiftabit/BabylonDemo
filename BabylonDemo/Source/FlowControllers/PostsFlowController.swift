import UIKit

final class PostsFlowController: FlowController {
    typealias RootViewController = PostsViewController

    lazy var rootViewController: RootViewController = configuredMainViewController()

    func configuredMainViewController() -> RootViewController {
        return configurePostViewController()
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
