import Foundation

struct PokemonColorsResponse: Codable {
    let count: Int
    let results: [PokemonColor]
}

struct PokemonColor: Codable {
    let name: String
    let url: String
}

struct PokemonColorResponse: Codable {
    let id: Int
    let name: String
    let names: [PokemonColorName]
    let pokemonSpecies: [PokemonSpecy]

    enum CodingKeys: String, CodingKey {
        case id, name, names
        case pokemonSpecies = "pokemon_species"
    }
}

// MARK: - Name

struct PokemonColorName: Codable {
    let language: PokemonSpecy
    let name: String
}

// MARK: - PokemonSpecy

struct PokemonSpecy: Codable {
    let name: String
    let url: String
}
