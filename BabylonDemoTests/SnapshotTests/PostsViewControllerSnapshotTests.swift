import SnapshotTesting
import XCTest
import RxSwift
@testable import BabylonDemo


final class PostsViewControllerSnapshotTests: XCTestCase {

    final class PostsNetworkControllerMock: PostsNetworkCotrollerProtocol {

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

    override func setUp() {
        super.setUp()
        record = false
    }

    override func tearDown() {
        model = nil
        sut = nil
        super.tearDown()
    }

    func testWithEmptyListOfPost() {
        // Arrange
        model = PostsViewModel(networkController: PostsNetworkControllerMock())
        sut = setUpSut(with: model)
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
        model = PostsViewModel(networkController: PostsNetworkControllerMock(expectedPosts: expectedPosts))
        sut = setUpSut(with: model)
        let sutInNavigationController = sut.embededInNavigationController

        // Act & Arrange
        assertSnapshot(matching: sutInNavigationController, as: .image(on: .iPhoneSe))
        assertSnapshot(matching: sutInNavigationController, as: .image(on: .iPhone8))
        assertSnapshot(matching: sutInNavigationController, as: .image(on: .iPhoneX))
    }

}

private extension PostsViewControllerSnapshotTests {
    func setUpSut(with model: PostsViewModel) -> PostsViewController {
        return PostsViewController(viewModel: model, onPostTapAction: FlowAction<Post>{_ in })
    }
}
