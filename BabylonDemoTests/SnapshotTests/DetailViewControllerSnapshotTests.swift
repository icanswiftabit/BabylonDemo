import SnapshotTesting
import XCTest
import RxSwift
import RxBlocking
@testable import BabylonDemo

final class DetailViewControllerSnapshotTests: XCTestCase {

    final class DetailNetworkControllerMock: DetailNetworkControllerProtocol {

        let session: URLSession
        let taskKit: DetailTaskKitProtocol
        var expectedUser = User(id: 1, username: "dd", name: "")
        var expectedComments = [Comment]()

        convenience init(expectedUser: User, expectedComments: [Comment]) {
            self.init(with: DetailTaskKit(), in: .shared)
            self.expectedUser = expectedUser
            self.expectedComments = expectedComments
        }

        init(with taskKit: DetailTaskKitProtocol = DetailTaskKit(), in session: URLSession = .shared) {
            self.taskKit = taskKit
            self.session = session
        }

        init(with session: URLSession = .shared) {
            self.taskKit = DetailTaskKit()
            self.session = session
        }

        func fetchUsers(withId: Int) -> Observable<User> {
            return .just(expectedUser)
        }

        func fetchComments(forPostId: Int) -> Observable<[Comment]> {
            return .just(expectedComments)
        }

    }

    var sut: DetailViewController!
    var model: DetailViewModel!
    var persistanceController: PersistanceController!

    override func setUp() {
        super.setUp()
        record = false
    }

    override func tearDown() {
        persistanceController.remove(User.self)
        persistanceController.remove(Comment.self)
        model = nil
        sut = nil
        super.tearDown()
    }

    func testWithEmptyDetails() {

        // Arrange
        let post = Post(userId: 1, id: 2, title: "", body: "")
        let user = User(id: 1, username: "username", name: "name")
        let comments = [Comment]()

        sut = setUpSut(post: post, user: user, comments: comments)
        let sutInNavigationController = sut.embededInNavigationController

        // Act & Assert
        assertSnapshot(matching: sutInNavigationController, as: .image(on: .iPhoneSe))
        assertSnapshot(matching: sutInNavigationController, as: .image(on: .iPhone8))
        assertSnapshot(matching: sutInNavigationController, as: .image(on: .iPhoneX))

    }

    func testWithDetails() {

        // Arrange
        let post = Post(userId: 1, id: 2, title: "title", body: "body")
        let user = User(id: 1, username: "username", name: "name")
        let comments = [
            Comment(id: 1, postId: 1),
            Comment(id: 2, postId: 1)
        ]
        sut = setUpSut(post: post, user: user, comments: comments)
        let sutInNavigationController = sut.embededInNavigationController

        // Act & Assert
        assertSnapshot(matching: sutInNavigationController, as: .image(on: .iPhoneSe))
        assertSnapshot(matching: sutInNavigationController, as: .image(on: .iPhone8))
        assertSnapshot(matching: sutInNavigationController, as: .image(on: .iPhoneX))

    }

    func testWithLongDetails() {

        // Arrange
        let post = Post(userId: 1, id: 2, title: "title", body: "body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body body ")
        let user = User(id: 1, username: "username", name: "name")
        let comments = [
            Comment(id: 1, postId: 1),
            Comment(id: 2, postId: 1)
        ]

        sut = setUpSut(post: post, user: user, comments: comments)
        let sutInNavigationController = sut.embededInNavigationController

        // Act & Assert
        assertSnapshot(matching: sutInNavigationController, as: .image(on: .iPhoneX))

    }
}

private extension DetailViewControllerSnapshotTests {
    func setUpSut(post: Post, user: User, comments: [Comment]) -> DetailViewController {
        let networkController = DetailNetworkControllerMock(expectedUser: user, expectedComments: comments)
        persistanceController = PersistanceController(userDefaults: .test)
        model = DetailViewModel(with: post, networkController: networkController, persistanceController: persistanceController)
        return DetailViewController(viewModel: model)
    }
}
