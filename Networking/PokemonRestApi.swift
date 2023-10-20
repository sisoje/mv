import Foundation

struct PokemonRestApi {
    let urlSession: URLSession

    func loadDecodable<T: Decodable>(_ request: URLRequest) async throws -> T {
        try await Task.sleep(for: .seconds(1))
        return try await JSONDecoder().decode(T.self, from: urlSession.loadData(request))
    }
}

extension PokemonRestApi: PokemonDataProtocol {
    func getPokemonColors() async throws -> PokemonColorsResponse {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon-color")!
        let request = URLRequest(url: url)
        return try await loadDecodable(request)
    }

    func getPokemonColor(colorName: String) async throws -> PokemonColorResponse {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon-color/\(colorName)")!
        let request = URLRequest(url: url)
        return try await loadDecodable(request)
    }
}
