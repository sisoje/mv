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

extension Task {
    func storeCancellation(_ taskCancellationBag: TaskCancellationBag) { taskCancellationBag.store(self) }
    func ignoreCancellation() {}
}

final class TaskCancellationBag {
    private var taskCancellations: [TaskCancellable] = []

    func store<S: Sendable, F: Error>(_ task: Task<S, F>) {
        taskCancellations.append(.taskCancelation(task))
    }

    func cancelAll() {
        taskCancellations.removeAll()
    }
}
