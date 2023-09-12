import SwiftUI

extension Binding {
    func loadAsync<T: Any>(_ asyncFunc: () async throws -> T) async where Value == LoadableValue<T> {
        wrappedValue.state = .loading(nil)
        do {
            let value = try await asyncFunc()
            wrappedValue.state = .idle
            withAnimation {
                wrappedValue.value = value
            }
        } catch {
            wrappedValue.error = error
            wrappedValue.state = .idle
        }
    }
}
