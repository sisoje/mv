final class TaskCancellable: Equatable {
    static func == (lhs: TaskCancellable, rhs: TaskCancellable) -> Bool { lhs === rhs }
    private let cancelTask: () -> Void
    init<S, F>(_ task: Task<S, F>) { self.cancelTask = task.cancel }
    deinit { cancelTask() }
}

struct LoadableValue<T: Any> {
    enum State: Equatable {
        case idle
        case loading(TaskCancellable?)
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
