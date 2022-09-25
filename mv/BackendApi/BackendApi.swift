import Foundation
import SwiftUI

final class BackendApi {
    static var makeApi: () -> BackendApi = { BackendApi(urlSession: .shared) }
    
    static let shared = makeApi()
        
    enum BackendError: Error {
        case responseError(Data, URLResponse)
        case imageError(Data)
        case decodeError(Data, Error)
    }
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    private let urlSession: URLSession
    
    func getCleanData(_ request: URLRequest) async throws -> Data {
        let (data, response) = try await urlSession.data(for: request)
        
        guard
            let httpResponse = response as? HTTPURLResponse,
            (200 ... 299).contains(httpResponse.statusCode)
        else {
            throw BackendError.responseError(data, response)
        }
        
        return data
    }
}

extension BackendApi {
    static func decode<T: Decodable>(data: Data, decoder: JSONDecoder = .init()) throws -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw BackendError.decodeError(data, error)
        }
    }
    
    func getProducts() async throws -> [Product] {
        let data = try await getCleanData(URLRequest(url: URL(string: "https://dummyjson.com/products")!))
        
        struct P: Decodable { let products: [Product] }
        
        let p: P = try Self.decode(data: data)
        
        return p.products
    }
    
    func getImage(url: URL) async throws -> Image {
        let data = try await getCleanData(URLRequest(url: url))
        
        guard let uiImage = UIImage(data: data) else {
            throw BackendError.imageError(data)
        }
        
        return Image(uiImage: uiImage)
    }
}
