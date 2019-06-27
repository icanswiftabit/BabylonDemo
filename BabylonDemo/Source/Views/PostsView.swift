import UIKit

final class PostsView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
    }

    @available(*, unavailable, message: "Please use init(frame:) instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

