import SwiftUI

@MainActor extension Binding {
    private func doLoad<T>(_ asyncFunc: @Sendable () async throws -> T) async where Value == LoadableValue<T> {
        wrappedValue.state = .loading
        do {
            let value = try await asyncFunc()
            wrappedValue.state = .idle
            wrappedValue.error = nil
            withAnimation {
                wrappedValue.value = value
            }
        } catch {
            wrappedValue.state = .idle
            wrappedValue.error = error
        }
    }

    func loadAsync<T>(_ asyncFunc: @Sendable () async throws -> T) async where Value == LoadableValue<T> {
        await doLoad(asyncFunc)
    }

    func loadTask<T>(_ asyncFunc: @MainActor @escaping @Sendable () async throws -> T) -> Task<Void, Never> where Value == LoadableValue<T> {
        Task {
            await doLoad(asyncFunc)
        }
    }
}
