import SnapshotTesting
import XCTest
@testable import BabylonDemo

final class AppFlowControllerSnapshotTests: XCTestCase {

    var sut: AppFlowController!

    override func setUp() {
        super.setUp()
        sut = AppFlowController()
        record = false
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testRootViewController() {
        // Arrange
        let rootViewController = sut.configuredMainViewController()

        // Act & Arrange
        snapshot(matching: rootViewController)
    }

}
