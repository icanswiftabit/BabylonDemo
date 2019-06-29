import UIKit

protocol Reusable {
    static var identifier: String { get }
    static var defaultSize: CGSize { get }
}

extension Reusable {
    static var identifier: String {
        return String(describing: Self.self)
    }
}

extension UICollectionView {
    func register<T: Reusable>(_ cell: T.Type) where T: UICollectionViewCell {
        register(T.self, forCellWithReuseIdentifier: T.identifier)
    }

    func dequeue<T: Reusable>(_ cell: T.Type, at indexPath: IndexPath) -> T where T: UICollectionViewCell {
        return dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
}
