import SwiftUI

struct TaskOnceModifier: ViewModifier {
    @State private var wasNeverShown = true
    let asyncFunc: @Sendable () async -> Void

    func body(content: Content) -> some View {
        content.task {
            guard wasNeverShown else {
                return
            }
            wasNeverShown = false
            await asyncFunc()
        }
    }
}

extension View {
    func taskOnce(priority: TaskPriority = .userInitiated, _ asyncFunc: @MainActor @escaping @Sendable () async -> Void) -> some View {
        modifier(TaskOnceModifier(asyncFunc: asyncFunc))
    }
}
