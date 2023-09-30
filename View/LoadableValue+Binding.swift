import SwiftUI

@MainActor extension Binding {
    func loadAsync<T>(_ asyncFunc: @MainActor @Sendable () async throws -> T) async where Value == LoadableValue<T> {
        withAnimation {
            wrappedValue.state = .loading
        }
        do {
            let value = try await asyncFunc()
            withAnimation {
                wrappedValue.value = value
                wrappedValue.state = .idle
            }
        }
        catch is CancellationError {}
        catch {
            withAnimation {
                wrappedValue.error = error
                wrappedValue.state = .idle
            }
        }
    }

    func loadTask<T>(_ asyncFunc: @MainActor @escaping @Sendable () async throws -> T) -> Task<Void, Never> where Value == LoadableValue<T> {
        Task {
            await loadAsync(asyncFunc)
        }
    }
}
