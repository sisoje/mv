import Combine
import Foundation
import SwiftUI

struct RestApi {
    let urlSession: URLSession

    struct BadResponseError: Error {
        var request: URLRequest?
        let response: URLResponse
        let data: Data
    }
}

private extension RestApi {
    func loadDecodable<T: Decodable>(request: URLRequest) async throws -> T {
        try await decodeData(data: loadData(request: request))
    }

    func decodeData<T: Decodable>(data: Data, _ decoder: JSONDecoder = .init()) throws -> T {
        try decoder.decode(T.self, from: data)
    }

    func loadData(request: URLRequest) async throws -> Data {
        let (data, response) = try await urlSession.data(for: request)
        guard
            let response = response as? HTTPURLResponse,
            (200 ... 299).contains(response.statusCode)
        else {
            throw BadResponseError(request: request, response: response, data: data)
        }
        return data
    }
}

extension RestApi {
    func getPokemonColors() async throws -> PokemonColorsResponse {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon-color")!
        let request = URLRequest(url: url)
        return try await loadDecodable(request: request)
    }

    func getPokemonColor(colorName: String) async throws -> PokemonColorResponse {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon-color/\(colorName)")!
        let request = URLRequest(url: url)
        return try await loadDecodable(request: request)
    }
}
