import Combine
import SwiftUI

extension Binding {
    func loadSideEffect<P: Publisher>(_ publisher: P) where Value == SideEffect<P.Output> {
        wrappedValue.state = .loading(
            publisher
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case let .failure(error):
                        wrappedValue.error = error
                    default:
                        break
                    }
                    wrappedValue.state = .idle
                } receiveValue: { value in
                    wrappedValue.value = value
                }
        )
    }

    func loadSideEffect<T>(_ asyncFunction: @escaping () async throws -> T) where Value == SideEffect<T> {
        loadSideEffect(Future(asyncFunction: asyncFunction))
    }
}
