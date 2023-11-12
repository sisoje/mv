import SwiftUI
import SwiftUIMacros

@EnvironmentStorage
extension EnvironmentValues {
    var pokemonColorsModel: PokemonColorsModel?
    var pokemonData: PokemonDataProtocol = PokemonRestApi(urlSession: .shared)
    var timerScheduler: (_ interval: TimeInterval, @escaping @Sendable () -> Void) -> () -> Void = {
        interval, block in
        let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            block()
        }
        return {
            timer.invalidate()
        }
    }
}
