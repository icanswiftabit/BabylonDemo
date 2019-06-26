import XCTest
import SnapshotTesting

extension XCTestCase {

    func snapshot(matching viewController: UIViewController) {

        assertSnapshot(matching: viewController, as: .image(on: .iPhoneSe))
        assertSnapshot(matching: viewController, as: .image(on: .iPhone8))
        assertSnapshot(matching: viewController, as: .image(on: .iPhoneX))
    }
}
