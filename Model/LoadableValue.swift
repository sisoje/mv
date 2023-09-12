import Combine

struct LoadableValue<T: Any> {
    enum State: Equatable {
        case idle
        case loading(AnyCancellable?)
    }
    var state: State = .idle
    var value: T?
    var error: Error?
}

extension LoadableValue.State {
    var isLoading: Bool { self != .idle }
    var isIdle: Bool { self == .idle }
}

extension LoadableValue {
    var hasError: Bool { error != nil }
    var hasValue: Bool { value != nil }
}
