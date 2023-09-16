import Combine

struct LoadableValue<T: Any> {
    // TODO add @CaseDetection
    enum State {
        case idle
        case loading(AnyCancellable?)
    }

    var state: State = .idle
    var value: T?
    var error: Error?
}

extension LoadableValue.State {
    var isLoading: Bool {
        switch self {
        case .idle: false
        default: true
        }
    }

    var isIdle: Bool {
        switch self {
        case .idle: true
        default: false
        }
    }
}

extension LoadableValue {
    var hasError: Bool { error != nil }
    var hasValue: Bool { value != nil }
}
