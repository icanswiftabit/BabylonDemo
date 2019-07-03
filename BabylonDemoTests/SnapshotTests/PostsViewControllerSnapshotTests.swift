import SnapshotTesting
import XCTest
import RxSwift
@testable import BabylonDemo


final class PostsViewControllerSnapshotTests: XCTestCase {

    final class PostsNetworkControllerMock: PostsNetworkControllerProtocol {

        let session: URLSession
        let taskKit: PostTaskKitProtocol
        var expectedPosts = [Post]()

        convenience init(expectedPosts: [Post]) {
            self.init(with: PostTaskKit(), in: .shared)
            self.expectedPosts = expectedPosts
        }

        init(with taskKit: PostTaskKitProtocol = PostTaskKit(), in session: URLSession = .shared) {
            self.taskKit = taskKit
            self.session = session
        }

        init(with session: URLSession = .shared) {
            self.taskKit = PostTaskKit()
            self.session = session
        }

        func fetchPosts() -> Observable<[Post]> {
            return .just(expectedPosts)
        }
    }

    var sut: PostsViewController!
    var model: PostsViewModel!
    var persistanceController: PersistanceController!

    override func setUp() {
        super.setUp()
        record = false
    }

    override func tearDown() {
        persistanceController.remove(Post.self)
        model = nil
        sut = nil
        super.tearDown()
    }

    func testWithEmptyListOfPost() {

        // Arrange
        sut = setUpSut(with: [Post]())
        let sutInNavigationController = sut.embededInNavigationController

        // Act & Arrange
        assertSnapshot(matching: sutInNavigationController, as: .image(on: .iPhoneSe))
        assertSnapshot(matching: sutInNavigationController, as: .image(on: .iPhone8))
        assertSnapshot(matching: sutInNavigationController, as: .image(on: .iPhoneX))
    }

    func testWithListOfPosts() {

        // Arrange
        let expectedPosts = [
            Post.mock(id: 1),
            Post.mock(id: 2),
            Post.mock(id: 3),
            Post.mock(id: 4)
        ]

        sut = setUpSut(with: expectedPosts)
        let sutInNavigationController = sut.embededInNavigationController

        // Act & Arrange
        assertSnapshot(matching: sutInNavigationController, as: .image(on: .iPhoneSe))
        assertSnapshot(matching: sutInNavigationController, as: .image(on: .iPhone8))
        assertSnapshot(matching: sutInNavigationController, as: .image(on: .iPhoneX))
    }

}

private extension PostsViewControllerSnapshotTests {
    func setUpSut(with posts: [Post]) -> PostsViewController {
        let networkController = PostsNetworkControllerMock(expectedPosts: posts)
        persistanceController = PersistanceController(userDefaults: .test)
        model = PostsViewModel(networkController: networkController, persistanceController: persistanceController)
        return PostsViewController(viewModel: model, onPostTapAction: FlowAction<Post>{_ in })
    }
}
