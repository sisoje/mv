import Foundation
import OSLog

struct BadResponseError: Error {
    let request: URLRequest
    let response: URLResponse
    let data: Data
}

extension URLSession {
    func loadData(_ request: URLRequest) async throws -> Data {
        let (data, response) = try await data(for: request)
        Logger().info("Response data bytes: \(data.count)")
        guard
            let response = response as? HTTPURLResponse,
            (200 ... 299).contains(response.statusCode)
        else {
            Logger().info("Response error")
            throw BadResponseError(request: request, response: response, data: data)
        }
        Logger().info("Response ok")
        return data
    }
}
