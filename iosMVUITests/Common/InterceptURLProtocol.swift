import Foundation
import OSLog

final class InterceptURLProtocol: URLProtocol {
    private static let interceptHeader = "X-Intercepted-By"
    
    private static var requests: [URLRequest] = [] {
        didSet {
            if let request = requests.last {
                Logger().info("Last request: \(request)")
            }
        }
    }
    
    private static var responses: [Int: (Data?, URLResponse?, Error?)] = [:]
    
    static func saveResponses(file: String) throws {
        let mocks: [CodableRequestAndReponse] = requests.enumerated().map { index, request in
            let dataResponseError = responses[index] ?? (nil, nil, nil)
            return CodableRequestAndReponse(
                request: CodableUrlRequest(request: request),
                response: CodableDataResponseError(dataResponseOrError: dataResponseError)
            )
        }
        try TestingFileUtilities.writeEncodable(fileName: file, value: mocks)
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        request.value(forHTTPHeaderField: interceptHeader) == nil
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    
    override func stopLoading() {}

    override func startLoading() {
        let index = Self.requests.count
        Self.requests.append(request)
        var interceptRequest = request
        interceptRequest.setValue(String(describing: self), forHTTPHeaderField: Self.interceptHeader)
        let task = URLSession.shared.dataTask(with: interceptRequest) { [client] data, response, error in
            Self.responses[index] = (data, response, error)
            if let error = error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            if let response = response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            client?.urlProtocolDidFinishLoading(self)
        }
        task.resume()
    }
}
