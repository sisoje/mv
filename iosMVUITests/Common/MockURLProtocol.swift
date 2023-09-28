import Foundation
import OSLog

@MainActor final class MockURLProtocol: URLProtocol {
    private static var codableResponses: [CodableRequestAndReponse] = []
    
    private static var requests: [URLRequest] = [] {
        didSet {
            if let request = requests.last {
                Logger().info("Last request: \(request)")
            }
        }
    }
    
    static func loadResponses(file: String) throws {
        codableResponses = try TestingFileUtilities.readDecodable(fileName: file)
        requests = []
    }
    
    private static func getResponse(_ request: URLRequest) -> (Data?, URLResponse?, Error?) {
        let next = codableResponses[requests.count]
        requests.append(request)
        assert(next.request == CodableUrlRequest(request: request))
        return next.response.toDataResponseError
    }

    override class func canInit(with _: URLRequest) -> Bool { true }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    
    override func stopLoading() {}

    override func startLoading() {
        let (data, response, error) = Self.getResponse(request)
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
}

