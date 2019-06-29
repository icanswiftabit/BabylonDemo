import XCTest
import RxSwift
@testable import BabylonDemo

final class PostsViewModelTests: XCTestCase {

    final class PostsNetworkControllerMock: PostsNetworkCotrollerProtocol {
        var taskKit: PostTaskKitProtocol
        var session: URLSession
        var expectedPosts: [Post]

        func fetchPosts() -> Observable<[Post]> {
            return .just(expectedPosts)
        }

        convenience init(expectedPosts: [Post]) {
            self.init()
            self.expectedPosts = expectedPosts
        }

        init(with session: URLSession = .shared) {
            self.session = session
            self.taskKit = PostTaskKitMock()
            self.expectedPosts = [Post]()
        }
    }

    final class PostsPersistanceControllerMock: PostsPersistanceControllerProtocol {
        let userDefaults = UserDefaults.standard
        var storedPosts = [Post]()

        func save(_ posts: [Post]) {
            storedPosts = posts
        }

        func load() -> [Post] {
            return storedPosts
        }

    }

    var sut: PostsViewModel!
    var networkController: PostsNetworkControllerMock!
    var persistanceController: PostsPersistanceControllerProtocol!
    let bag = DisposeBag()

    override func tearDown() {
        networkController = nil
        persistanceController = nil
        sut = nil
        super.tearDown()
    }

    func testShoudlNotifySubscribersAboutNewPosts() {

        // Arrange
        let expectedPosts = [Post.mock(id: 1)]

        setUpSut(with: expectedPosts)

        sut.posts
            .skip(1)
            .subscribe(onNext: { posts in

                // Assert
                XCTAssertEqual(posts, expectedPosts)
            })
            .disposed(by: bag)

        // Act
        sut.fetchPosts()

    }

    func testShoudlNotifySubscribersOnlyOnceAboutNewPosts_ifPostsAreNotChanged() {

        // Arrange
        let expectedPosts = [Post.mock(id: 1)]
        var postsNotificationCount = 0

        setUpSut(with: expectedPosts)

        sut.posts
            .skip(1)
            .subscribe(onNext: { _ in
                postsNotificationCount += 1
            })
            .disposed(by: bag)

        // Act
        sut.fetchPosts()
        sut.fetchPosts()
        sut.fetchPosts()

        // Assert
        XCTAssertEqual(postsNotificationCount, 1)
    }

    func testShoudlNotifySubscribersAboutNewPosts_ifPostsChanged() {

        // Arrange
        let expectedFirstPosts = [Post.mock(id: 1)]
        let expectedSecondPosts = [Post.mock(id: 1), Post.mock(id: 2)]
        var postsNotificationCount = 0

        setUpSut(with: expectedFirstPosts)

        sut.posts
            .skip(1)
            .subscribe(onNext: { _ in
                postsNotificationCount += 1
            })
            .disposed(by: bag)

        // Act
        sut.fetchPosts()
        sut.fetchPosts()
        networkController.expectedPosts = expectedSecondPosts
        sut.fetchPosts()

        // Assert
        XCTAssertEqual(postsNotificationCount, 2)
    }
    
}

private extension PostsViewModelTests {
    func setUpSut(with expectedPosts: [Post]) {
        persistanceController = PostsPersistanceControllerMock()
        networkController = PostsNetworkControllerMock(expectedPosts: expectedPosts)
        sut = PostsViewModel(networkController: networkController, persistanceController: persistanceController)
    }
}
