import OSLog

protocol TaskCancellationBag {
    func store<S, F>(_ task: Task<S, F>)
    func cancelAll()
}

extension Task {
    func storeCancellation(_ taskCancellationBag: TaskCancellationBag) {
        taskCancellationBag.store(self)
    }

    func ignoreCancellation() {}
}

final class TaskCancellationBagObservable: ObservableObject, TaskCancellationBag {
    private var taskCancellations: [TaskCancellable] = []

    func store<S: Sendable, F: Error>(_ task: Task<S, F>) {
        taskCancellations.append(.taskCancelation(task))
    }

    func cancelAll() {
        taskCancellations.removeAll()
    }
}
