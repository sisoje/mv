import Foundation

extension URLSession {
    func loadData(_ request: URLRequest) async throws -> Data {
        let (data, response) = try await data(for: request)
        guard
            let response = response as? HTTPURLResponse,
            (200 ... 299).contains(response.statusCode)
        else {
            throw BadResponseError(request: request, response: response, data: data)
        }
        return data
    }
}
