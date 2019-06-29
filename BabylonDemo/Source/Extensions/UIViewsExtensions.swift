import UIKit

public extension UIView {
    func disableAutoresizingMask() {
        translatesAutoresizingMaskIntoConstraints = false
        subviews.disableAutoresizingMask()
    }
}

extension Array where Element: UIView {
    func disableAutoresizingMask() {
        forEach { $0.disableAutoresizingMask() }
    }
}

