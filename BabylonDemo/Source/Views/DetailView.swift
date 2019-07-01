import UIKit
import RxCocoa
import RxSwift

final class DetailView: UIView {

    fileprivate let titleLable = UILabel()
    fileprivate let bodyLable = UILabel()
    fileprivate let nameLabel = UILabel()
    fileprivate let usernameLabel = UILabel()
    fileprivate let commentsCountLabel = UILabel()

    private let bodyView = UIView()
    private let stackView = UIStackView()
    private let scrollView = UIScrollView()

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

private extension DetailView {
    func layout() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        bodyView.addSubview(bodyLable)
        [titleLable, nameLabel, usernameLabel, commentsCountLabel, bodyView].forEach { stackView.addArrangedSubview($0) }
        [scrollView, stackView, titleLable, bodyLable, nameLabel, usernameLabel, commentsCountLabel, bodyView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        let margin = CGFloat(8.0)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: margin),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -margin),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: margin),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -margin),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1.0, constant: -(margin * 2)),

            bodyLable.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor),
            bodyLable.topAnchor.constraint(equalTo: bodyView.topAnchor),
            bodyLable.trailingAnchor.constraint(equalTo: bodyView.trailingAnchor),
            bodyLable.bottomAnchor.constraint(lessThanOrEqualTo: bodyView.bottomAnchor)
        ])
    }

    func decorate() {
        titleLable.style(as: .boldedNormal)
        bodyLable.style(as: .normal)
        nameLabel.style(as: .author)
        usernameLabel.style(as: .caption)
        commentsCountLabel.style(as: .caption)

        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 8.0

        backgroundColor = .white
    }
}

extension Reactive where Base: DetailView {
    var title: Binder<String?> {
        return base.titleLable.rx.text
    }

    var body: Binder<String?> {
        return base.bodyLable.rx.text
    }

    var username: Binder<String?> {
        let binder = Binder<String?>(base) { view, value in
            let text = value != nil ? "@\(value!)" : nil
            view.usernameLabel.text = text
        }
        return binder
    }

    var name: Binder<String?> {
        return base.nameLabel.rx.text
    }

    var commentCount: Binder<Int> {
        let binder = Binder<Int>(base) { view, value in
            view.commentsCountLabel.text = "Comments: \(value)"
        }
        return binder
    }
}
