import SwiftUI
import SwiftUIMacros

extension EnvironmentValues {
    @EnvironmentValue var pokemonData: PokemonDataProtocol = PokemonRestApi(urlSession: .shared)
}
