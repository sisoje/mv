import Foundation
import OSLog

@MainActor final class InterceptURLProtocol: URLProtocol {
    public static var file: String?
    private static let interceptHeader = "X-Intercepted-By"
    
    private static var requests: [URLRequest] = [] {
        didSet {
            if let request = requests.last {
                Logger().info("Last request: \(request)")
            }
        }
    }
    
    private static var responses: [Int: (Data?, URLResponse?, Error?)] = [:]
    
    static func saveResponses() throws {
        guard let file else {
            return
        }
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
        let task = URLSession.shared.dataTask(with: interceptRequest) { data, response, error in
            DispatchQueue.main.async {
                Self.responses[index] = (data, response, error)
                try? Self.saveResponses()
            }
            if let error = error {
                self.client?.urlProtocol(self, didFailWithError: error)
            }
            if let data = data {
                self.client?.urlProtocol(self, didLoad: data)
            }
            if let response = response {
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            self.client?.urlProtocolDidFinishLoading(self)
        }
        task.resume()
    }
}
