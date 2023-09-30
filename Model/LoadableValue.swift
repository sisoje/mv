struct LoadableValue<T: Sendable>: Sendable {
    enum State {
        case idle
        case loading
    }

    var state: State = .idle
    var value: T?
    var error: Error?
}

extension LoadableValue.State {
    var isLoading: Bool { !isIdle }
    var isIdle: Bool { if case .idle = self { true } else { false } }
}

extension LoadableValue {
    var hasError: Bool { error != nil }
    var hasValue: Bool { value != nil }
}
