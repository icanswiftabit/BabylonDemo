import UIKit

final class PostCell: UICollectionViewCell {

    private let titleLabel = UILabel()
    var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        decorate()
    }

    @available(*, unavailable, message: "Please use init(frame:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PostCell {
    func layout() {
        addSubview(titleLabel)
        translatesAutoresizingMaskIntoConstraints = false
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }


        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2)
        ])
    }

    func decorate() {
        backgroundColor = .white
        titleLabel.style(as: .caption)
    }
}

extension PostCell: Reusable {
    static var defaultSize: CGSize {
        return CGSize(width: 300, height: 50)
    }
}
