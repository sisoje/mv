import Combine

extension Task {
    func cancellable() -> AnyCancellable {
        AnyCancellable {
            guard !isCancelled else { return }
            cancel()
        }
    }
}
