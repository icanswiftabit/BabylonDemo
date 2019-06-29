import XCTest
import RxSwift
import RxTest
@testable import BabylonDemo

final class NetworkControllerTests: XCTestCase {

    final class NetworkControllerMock: NetworkControllerProtocol {
        var session: URLSession

        init(with session: URLSession = .shared) {
            self.session = session
        }
    }

    var sut: NetworkControllerProtocol?
    let bag = DisposeBag()

    override func setUp() {
        super.setUp()
        sut = NetworkControllerMock()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testShouldReturnError_forIncorrectURLInRequest() {
        // Arrange
        let expectedError = TaskKitError.urlError
        let request = Observable<URLRequest>.error(expectedError)

        // Act
        sut!.fetch(request: request)
            .subscribe(onNext: { _ in }, onError: { error in

                // Assert
                guard case TaskKitError.urlError = error else {
                    XCTFail()
                    return
                }
            })
            .disposed(by: bag)
    }

    // add more test cases
}
