import Foundation

struct CodableRequestAndReponse: Codable {
    let request: CodableUrlRequest
    let response: CodableDataResponseError
}

struct CodableHttpUrlResponse: Codable {
    let url: URL
    let statusCode: Int
    let headers: [String: String]?

    init(response: HTTPURLResponse) {
        url = response.url!
        statusCode = response.statusCode
        headers = response.allHeaderFields as? [String: String]
    }

    var toUrlResponse: HTTPURLResponse {
        HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: headers
        )!
    }
}

struct CodableUrlRequest: Codable, Equatable {
    let url: URL
    let method: String
    let bodyString: String?
    let headers: [String: String]?

    init(request: URLRequest) {
        url = request.url!
        method = request.httpMethod!
        bodyString = request.httpBody.map { String(data: $0, encoding: .utf8)! }
        headers = request.allHTTPHeaderFields
    }

    var toUrlRequest: URLRequest {
        var req = URLRequest(url: url)
        req.httpMethod = method
        req.httpBody = bodyString.map { Data($0.utf8) }
        req.allHTTPHeaderFields = headers
        return req
    }
}

struct CodableDataResponseError: Codable {
    private struct CodableError: Error {
        let message: String
    }

    enum DataOrString: Codable {
        case data(Data)
        case string(String)
    }

    var dataOrString: DataOrString?
    var codableUrlResponse: CodableHttpUrlResponse?
    var errorString: String?

    init(dataResponseOrError: (Data?, URLResponse?, Error?)) {
        if let error = dataResponseOrError.2 {
            errorString = error.localizedDescription
        }
        if let data = dataResponseOrError.0 {
            if let string = String(data: data, encoding: .utf8) {
                dataOrString = .string(string)
            } else {
                dataOrString = .data(data)
            }
        }
        if let response = dataResponseOrError.1 {
            codableUrlResponse = .init(response: response as! HTTPURLResponse)
        }
    }

    var toDataResponseError: (Data?, URLResponse?, Error?) {
        (
            dataOrString.map {
                switch $0 {
                case .data(let data):
                    return data
                case .string(let string):
                    return Data(string.utf8)
                }
            },
            codableUrlResponse?.toUrlResponse,
            errorString.map { CodableError(message: $0) }
        )
    }
}
