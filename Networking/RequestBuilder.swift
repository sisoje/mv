import Foundation

protocol DictionarySerializable: Encodable {
    func asDictionary(_ encoder: JSONEncoder) -> [String: String?]
}

extension DictionarySerializable {
    func asDictionary(_ encoder: JSONEncoder = .init()) -> [String: String?] {
        guard
            let data = try? encoder.encode(self),
            let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        else {
            return [:]
        }
        return jsonObject.mapValues { value in
            if
                let nsnumber = value as? NSNumber,
                nsnumber.objCType == NSNumber(booleanLiteral: true).objCType,
                let boolBalue = nsnumber as? Bool
            {
                return boolBalue.description
            }
            guard let paramValue = value as? CustomStringConvertible else {
                return nil
            }
            return paramValue.description
        }
    }
}

extension URL {
    func appendingQueryItem(name: String, value: String? = nil, resolvingAgainstBaseURL: Bool = false) -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: resolvingAgainstBaseURL)!
        components.queryItems = (components.queryItems ?? []) + [URLQueryItem(name: name, value: value)]
        return components.url!
    }

    mutating func appendQueryItem(name: String, value: String? = nil, resolvingAgainstBaseURL: Bool = false) {
        self = appendingQueryItem(name: name, value: value, resolvingAgainstBaseURL: resolvingAgainstBaseURL)
    }
}

extension URL {
    private func request(method: String, path: String?, @RequestBuilder content: () -> [RequestBuilderProtocol]) -> URLRequest {
        let url = path.flatMap { URL(string: $0, relativeTo: self) } ?? self
        var request = URLRequest(url: url)
        request.httpMethod = method
        content().forEach { builder in
            builder.build(&request)
        }
        return request
    }

    func get(_ path: String? = nil, @RequestBuilder content: () -> [RequestBuilderProtocol] = { [] }) -> URLRequest {
        request(method: "GET", path: path, content: content)
    }

    func post(_ path: String? = nil, @RequestBuilder content: () -> [RequestBuilderProtocol] = { [] }) -> URLRequest {
        request(method: "POST", path: path, content: content)
    }

    func put(_ path: String? = nil, @RequestBuilder content: () -> [RequestBuilderProtocol] = { [] }) -> URLRequest {
        request(method: "PUT", path: path, content: content)
    }

    func patch(_ path: String? = nil, @RequestBuilder content: () -> [RequestBuilderProtocol] = { [] }) -> URLRequest {
        request(method: "PATCH", path: path, content: content)
    }

    func delete(_ path: String? = nil, @RequestBuilder content: () -> [RequestBuilderProtocol] = { [] }) -> URLRequest {
        request(method: "DELETE", path: path, content: content)
    }
}

@resultBuilder enum RequestBuilder {
    static func buildBlock() -> [RequestBuilderProtocol] { [] }
    static func buildBlock(_ components: RequestBuilderProtocol...) -> [RequestBuilderProtocol] { components }
    static func buildBlock(_ components: [RequestBuilderProtocol]...) -> [RequestBuilderProtocol] {
        components.flatMap { $0 }
    }
}




protocol RequestBuilderProtocol {
    func build(_ request: inout URLRequest)
}

struct Query: RequestBuilderProtocol {
    private let params: [String: String?]

    init(_ params: [String: String?]) {
        self.params = params
    }

    init<T: DictionarySerializable>(_ encodable: T, encoder: JSONEncoder = .init()) {
        self.init(encodable.asDictionary(encoder))
    }

    func build(_ request: inout URLRequest) {
        params.forEach { name, value in
            request.url?.appendQueryItem(name: name, value: value)
        }
    }
}

struct Headers: RequestBuilderProtocol {
    private let headers: [String: String?]

    init(_ headers: [String: String?]) {
        self.headers = headers
    }

    init<T: DictionarySerializable>(_ encodable: T, encoder: JSONEncoder = .init()) {
        self.init(encodable.asDictionary(encoder))
    }

    func build(_ request: inout URLRequest) {
        headers.forEach { param in
            request.setValue(param.value, forHTTPHeaderField: param.key)
        }
    }
}

struct PostData: RequestBuilderProtocol {
    private let data: Data?

    init(_ data: Data?) {
        self.data = data
    }

    func build(_ request: inout URLRequest) {
        request.httpBody = data
    }
}

struct JsonData: RequestBuilderProtocol {
    private let data: Data?

    init<T: Encodable>(_ encodable: T, encoder: JSONEncoder = .init()) {
        self.data = try? encoder.encode(encodable)
    }

    func build(_ request: inout URLRequest) {
        request.httpBody = data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    }
}

struct URLEncodedData: RequestBuilderProtocol {
    private let data: Data?

    init(_ params: [String: String?]) {
        var components = URLComponents()
        components.queryItems = params.map {
            URLQueryItem(name: $0, value: $1)
        }
        self.data = components.query?.data(using: .utf8)
    }

    init<T: DictionarySerializable>(_ encodable: T, encoder: JSONEncoder = .init()) {
        self.init(encodable.asDictionary(encoder))
    }

    func build(_ request: inout URLRequest) {
        request.httpBody = data
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    }
}

class Dzenerik: RequestBuilderProtocol {
    init(block: @escaping (inout URLRequest) -> Void) {
        self.block = block
    }

    func build(_ request: inout URLRequest) { block(&request) }

    private let block: (inout URLRequest) -> Void
}

final class AcceptJson: Dzenerik {
    init() {
        super.init {
            $0.addValue("application/json", forHTTPHeaderField: "Accept")
        }
    }
}

final class UserAgent: Dzenerik {
    init(_ agent: String) {
        super.init {
            $0.setValue(agent, forHTTPHeaderField: "User-Agent")
        }
    }
}

final class AcceptGzipDeflate: Dzenerik {
    init() {
        super.init {
            $0.addValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
        }
    }
}

final class BearerTokenAuthorization: Dzenerik {
    init(_ token: String) {
        super.init {
            $0.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
    }
}
