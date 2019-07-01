import UIKit

extension UILabel {
    enum Style {
        case boldedNormal
        case normal
        case author
        case caption

        var font: UIFont {
            switch self {
            case .boldedNormal, .normal: return .systemFont(ofSize: 18)
            case .author: return .systemFont(ofSize: 14, weight: .light)
            case .caption: return .systemFont(ofSize: 12)
            }
        }
    }

    func style(as style: Style) {
        wordWrapping()
        font = style.font
    }
}

private extension UILabel {

    func wordWrapping() {
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
    }
}
