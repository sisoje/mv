import Combine

extension Future where Failure == Error {
    convenience init(asyncFunction: @escaping () async throws -> Output) {
        self.init { promise in
            Task {
                do {
                    promise(.success(try await asyncFunction()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
}
