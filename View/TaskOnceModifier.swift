import SwiftUI

struct TaskOnceModifier: ViewModifier {
    @State private var neverShown = true
    let asyncFunc: () async -> Void

    func body(content: Content) -> some View {
        content.task {
            guard neverShown else {
                return
            }
            neverShown = false
            await asyncFunc()
        }
    }
}

extension View {
    func taskOnce(asyncFunc: @escaping () async -> Void) -> some View {
        modifier(TaskOnceModifier(asyncFunc: asyncFunc))
    }
}
