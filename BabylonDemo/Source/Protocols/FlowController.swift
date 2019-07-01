import UIKit

protocol FlowController {
    associatedtype RootViewController
    var rootViewController: RootViewController { get }
}
