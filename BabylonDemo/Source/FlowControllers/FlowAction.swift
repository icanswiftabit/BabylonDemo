import RxSwift

struct FlowAction<Element>: ObserverType {
    typealias E = Element

    private let action: (Element) -> Void

    init(_ action: @escaping (Element) -> Void) {
        self.action = action
    }

    func on(_ event: Event<Element>) {
        switch event {
        case .next(let value):
            action(value)
        default: break
        }
    }
}
