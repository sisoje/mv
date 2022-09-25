import Combine

struct SideEffect<T: Any> {
    enum State {
        case idle
        case loading(AnyCancellable)
    }

    var value: T?
    var error: Error?
    var state: State = .idle
}

extension SideEffect.State {
    var isIdle: Bool {
        switch self {
        case .idle:
            return true
        default:
            return false
        }
    }

    var isLoading: Bool {
        !isIdle
    }
}
