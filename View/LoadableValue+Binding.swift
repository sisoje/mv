import SwiftUI

@MainActor extension Binding {
    private func loadInternal<T>(_ asyncFunc: @MainActor @Sendable () async throws -> T) async where Value == LoadableValue<T> {
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

    func loadAsync<T>(_ asyncFunc: @MainActor @Sendable () async throws -> T) async where Value == LoadableValue<T> {
        wrappedValue.state = .loading(nil)
        await loadInternal(asyncFunc)
    }

    func loadTask<T>(_ asyncFunc: @MainActor @escaping @Sendable () async throws -> T) -> Task<Void, Never> where Value == LoadableValue<T> {
        let task = Task {
            await loadInternal(asyncFunc)
        }
        wrappedValue.state = .loading(.taskCancelation(task))
        return task
    }
}
