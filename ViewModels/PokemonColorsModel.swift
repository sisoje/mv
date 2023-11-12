//
//  PokemonColorsViewModel.swift
//  iosMV
//
//  Created by Lazar Otasevic on 5.11.23..
//

import Combine
import SwiftUI
import ViewModelify

@ViewModelify
@propertyWrapper @MainActor struct PokemonColorsModel: DynamicProperty {
    @Environment(\.pokemonData) private var pokemonData
    @State var pokemonColors: LoadableValue<PokemonColorsResponse> = .init()
    @State private var cancellable: AnyCancellable?

    func load() {
        cancellable = $pokemonColors.loadTask {
            try await pokemonData.getPokemonColors()
        }.cancellable()
    }

    func loadAsync() async {
        await $pokemonColors.loadAsync {
            try await pokemonData.getPokemonColors()
        }
    }
}
