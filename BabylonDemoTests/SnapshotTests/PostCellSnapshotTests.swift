import XCTest
import SnapshotTesting
@testable import BabylonDemo

final class PostCellSnapshotTests: XCTestCase {

    var sut: PostCell?

    struct Constants {
        static var normalTitle = "Normal title for post"
        static var size = CGSize(width: ViewImageConfig.iPhone8.size!.width, height: PostCell.defaultSize.height)
    }

    override func setUp() {
        sut = PostCell()
        super.setUp()
        record = false
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testWithTitle() {
        // Arrange
        sut?.title = Constants.normalTitle

        // Act & Assert
        assertSnapshot(matching: sut!, as: .image(size: Constants.size))
    }

    func testWithLongTitle() {
        // Arrange
        sut?.title = "\(Constants.normalTitle)\(Constants.normalTitle)\(Constants.normalTitle)\(Constants.normalTitle)"

        // Act & Assert
        assertSnapshot(matching: sut!, as: .image(size: Constants.size))
    }
}
