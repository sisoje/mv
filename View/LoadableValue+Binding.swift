import SwiftUI

extension Binding {
    func loadAsync<T: Any>(_ asyncFunc: () async throws -> T) async where Value == LoadableValue<T> {
        wrappedValue.state = .loading
        do {
            let value = try await asyncFunc()
            withAnimation {
                wrappedValue.value = value
            }
        } catch {
            wrappedValue.error = error
        }
        wrappedValue.state = .idle
    }
}
