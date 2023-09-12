import Foundation

protocol PokemonDataProtocol {
    func getPokemonColors() async throws -> PokemonColorsResponse
    func getPokemonColor(colorName: String) async throws -> PokemonColorResponse
}
