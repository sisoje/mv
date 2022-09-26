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
        guard case .idle = self else {
            return false
        }
        return true
    }

    var isLoading: Bool {
        !isIdle
    }
}
