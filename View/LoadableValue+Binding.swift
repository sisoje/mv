import SwiftUI

@MainActor extension Binding {
    func loadAsync<T>(_ asyncFunc: @MainActor @Sendable () async throws -> T) async where Value == LoadableValue<T> {
        wrappedValue.state = .loading
        do {
            let value = try await asyncFunc()
            try Task.checkCancellation()
            wrappedValue.state = .idle
            withAnimation {
                wrappedValue.value = value
            }
        }
        catch is CancellationError {}
        catch {
            guard !Task.isCancelled else { return }
            wrappedValue.state = .idle
            wrappedValue.error = error
        }
    }

    func loadTask<T>(_ asyncFunc: @MainActor @escaping @Sendable () async throws -> T) -> Task<Void, Never> where Value == LoadableValue<T> {
        Task {
            await loadAsync(asyncFunc)
        }
    }
}
