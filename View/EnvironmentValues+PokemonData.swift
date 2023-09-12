import SwiftUI

extension EnvironmentValues {
    struct PokemonDataKey: EnvironmentKey {
        static let defaultValue: PokemonDataProtocol = PokemonRestApi(urlSession: .shared)
    }

    var pokemonData: PokemonDataKey.Value {
        get {
            self[PokemonDataKey.self]
        }
        set {
            self[PokemonDataKey.self] = newValue
        }
    }
}
