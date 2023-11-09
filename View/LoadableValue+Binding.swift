import SwiftUI
import OSLog

@MainActor extension Binding {
    func loadAsync<T>(_ asyncFunc: @MainActor @Sendable () async throws -> T) async where Value == LoadableValue<T> {
        Logger().info("start loadAsync")
        wrappedValue.isLoading = true
        do {
            let value = try await asyncFunc()
            try Task.checkCancellation()
            Logger().info("finish loadTask")
            wrappedValue.isLoading = false
            withAnimation {
                wrappedValue.value = value
            }
        }
        catch is CancellationError {}
        catch {
            Logger().info("catch loadTask")
            guard !Task.isCancelled else { return }
            wrappedValue.isLoading = false
            wrappedValue.error = error
        }
    }

    func loadTask<T>(_ asyncFunc: @MainActor @escaping @Sendable () async throws -> T) -> Task<Void, Never> where Value == LoadableValue<T> {
        Logger().info("start loadTask")
        return Task {
            await loadAsync(asyncFunc)
        }
    }
}
