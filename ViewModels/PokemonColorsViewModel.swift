//
//  PokemonColorsViewModel.swift
//  iosMV
//
//  Created by Lazar Otasevic on 5.11.23..
//

import SwiftUI

@propertyWrapper @MainActor struct PokemonColorsViewModel: DynamicProperty {
    @Environment(\.pokemonData) private var pokemonData
    @State private var pokemonColors: LoadableValue<PokemonColorsResponse> = .init()

    var wrappedValue: LoadableValue<PokemonColorsResponse> { pokemonColors }

    func load() {
        $pokemonColors.loadTask {
            try await pokemonData.getPokemonColors()
        }.ignoreCancellation()
    }

    func loadAsync() async {
        await $pokemonColors.loadAsync {
            try await pokemonData.getPokemonColors()
        }
    }

    var errorBinding: Binding<Error?> {
        Binding<Error?> { pokemonColors.error } set: { pokemonColors.error = $0 }
    }
}
