final class TaskCancellable: Sendable {
    private let block: @Sendable () -> Void
    init(block: @escaping @Sendable () -> Void) { self.block = block }
    deinit { block() }
    static func taskCancelation<S: Sendable, F: Error>(_ task: Task<S, F>) -> TaskCancellable {
        TaskCancellable {
            guard !task.isCancelled else { return }
            task.cancel()
        }
    }
}

struct LoadableValue<T: Any & Sendable>: Sendable {
    enum State {
        case idle
        case loading(TaskCancellable?)
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
