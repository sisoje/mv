import SwiftUI

@MainActor extension Binding {
    private func doLoad<T: Any>(_ asyncFunc: () async throws -> T) async where Value == LoadableValue<T> {
        do {
            let value = try await asyncFunc()
            wrappedValue.state = .idle
            withAnimation {
                wrappedValue.value = value
            }
        } catch {
            wrappedValue.state = .idle
            wrappedValue.error = error
        }
    }

    func loadAsync<T: Any>(_ asyncFunc: () async throws -> T) async where Value == LoadableValue<T> {
        wrappedValue.state = .loading(nil)
        await doLoad(asyncFunc)
    }

    func loadSync<T: Any>(_ asyncFunc: @escaping () async throws -> T) where Value == LoadableValue<T> {
        let task = Task {
            await doLoad(asyncFunc)
        }
        wrappedValue.state = .loading(.init(task))
    }
}
