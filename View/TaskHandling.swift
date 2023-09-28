import Combine
import SwiftUI

extension Task {
    func cancellable() -> AnyCancellable {
        AnyCancellable {
            guard !isCancelled else { return }
            print("canceling task")
            cancel()
        }
    }

    func storeTaskCancellation(_ taskBag: TaskBagObservable) {
        taskBag.add(cancellable())
    }
}

final class TaskBagObservable: ObservableObject {
    private var taskCancellations: Set<AnyCancellable> = []

    func add(_ canc: AnyCancellable) {
        taskCancellations.insert(canc)
    }

    func removeall() {
        taskCancellations.removeAll()
    }

    deinit {
        print("TaskBag deinit")
    }
}

@propertyWrapper struct TaskBag: DynamicProperty {
    @StateObject private var taskBag: TaskBagObservable = .init()
    var wrappedValue: TaskBagObservable { get { taskBag } }
}
