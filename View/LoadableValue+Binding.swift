import SwiftUI

@MainActor extension Binding {
    func loadAsync<T>(_ asyncFunc: @MainActor @Sendable () async throws -> T) async where Value == LoadableValue<T> {
        wrappedValue.isLoading = true
        do {
            let value = try await asyncFunc()
            try Task.checkCancellation()
            wrappedValue.isLoading = false
            withAnimation {
                wrappedValue.value = value
            }
        }
        catch is CancellationError {}
        catch {
            guard !Task.isCancelled else { return }
            wrappedValue.isLoading = false
            wrappedValue.error = error
        }
    }

    func loadTask<T>(_ asyncFunc: @MainActor @escaping @Sendable () async throws -> T) -> Task<Void, Never> where Value == LoadableValue<T> {
        Task {
            await loadAsync(asyncFunc)
        }
    }
}
