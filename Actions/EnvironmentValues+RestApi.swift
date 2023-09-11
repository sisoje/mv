import SwiftUI

extension EnvironmentValues {
    struct GetPokemonColorsKey: EnvironmentKey {
        static let defaultValue = RestApi(urlSession: .shared).getPokemonColors
    }

    var getPokemonColors: GetPokemonColorsKey.Value {
        get {
            self[GetPokemonColorsKey.self]
        }
        set {
            self[GetPokemonColorsKey.self] = newValue
        }
    }
}

extension EnvironmentValues {
    struct GetPokemonColorKey: EnvironmentKey {
        static let defaultValue = RestApi(urlSession: .shared).getPokemonColor
    }

    var getPokemonColor: GetPokemonColorKey.Value {
        get {
            self[GetPokemonColorKey.self]
        }
        set {
            self[GetPokemonColorKey.self] = newValue
        }
    }
}
