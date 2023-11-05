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

extension EnvironmentValues {
    struct TimerSchedulerKey: EnvironmentKey {
        static let defaultValue: (_ interval: TimeInterval, @escaping @Sendable () -> Void) -> () -> Void = { interval, block in
            let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
                block()
            }
            return {
                timer.invalidate()
            }
        }
    }

    var timerScheduler: TimerSchedulerKey.Value {
        get {
            self[TimerSchedulerKey.self]
        }
        set {
            self[TimerSchedulerKey.self] = newValue
        }
    }
}
