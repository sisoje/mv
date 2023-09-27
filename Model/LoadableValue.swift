struct LoadableValue<T: Any & Sendable> {
    enum State {
        case idle
        case loading
    }

    var state: State = .idle
    var value: T?
    var error: Error?
}

extension LoadableValue.State {
    var isLoading: Bool { self == .loading }
    var isIdle: Bool { self == .idle }
}

extension LoadableValue {
    var hasError: Bool { error != nil }
    var hasValue: Bool { value != nil }
}
