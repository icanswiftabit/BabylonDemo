import UIKit
import RxCocoa
import RxSwift

enum NetworkControllerError: Error {
    case responseSerializationError
    case undefindeError
}

protocol NetworkControllerProtocol {
    init(with session: URLSession)

    var session: URLSession { get }
    func fetch(request: Observable<URLRequest>) -> Observable<Data>
}

extension NetworkControllerProtocol {
    func fetch(request: Observable<URLRequest>) -> Observable<Data> {
        UIApplication.shared.showNetworkActivityIndicator()
        return request
            .catchError { error -> Observable<URLRequest> in
                UIApplication.shared.hideNetworkActivityIndicator()
                return .error(error)
            }
            .flatMap { self.session.rx.response(request: $0) }
            .flatMap { response -> Observable<Data> in
                UIApplication.shared.hideNetworkActivityIndicator()
                switch response.response.statusCode {
                case 200..<300:
                    return .just(response.data)
                default:
                    return .error(NetworkControllerError.undefindeError)
                }
        }
    }
}

private extension UIApplication {
    func showNetworkActivityIndicator() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }

    func hideNetworkActivityIndicator() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}
