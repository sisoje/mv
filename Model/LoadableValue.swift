struct LoadableValue<T: Sendable>: Sendable {
    var isLoading: Bool = false
    var value: T?
    var error: Error?
}

extension LoadableValue {
    var hasError: Bool { error != nil }
    var hasValue: Bool { value != nil }
}
