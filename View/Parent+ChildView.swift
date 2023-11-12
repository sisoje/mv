//
//  ChildView.swift
//  iosMV
//
//  Created by Lazar Otasevic on 12.11.23..
//

import SwiftUI

struct ChildView: View {
    @Environment(\.pokemonColorsModel) var model: PokemonColorsModel!
    //@PokemonColorsModel private var model
    var body: some View {
        HStack {
            Text("Results \(model.pokemonColors.value?.count ?? 0)")
            Button("Load") {
                model.load()
            }
            Button("Clear") {
                model.pokemonColors.value = nil
            }
        }
    }
}

struct ParentView: View {
    @PokemonColorsModel var model
    var body: some View {
        VStack {
            ChildView()
                .environment(\.pokemonColorsModel, model)
                
            List(model.pokemonColors.value?.results ?? [], id: \.name) { pokemonColor in
                Text(pokemonColor.name)
            }
        }
    }
}

#Preview {
    VStack {
        ChildView()
        ParentView()
    }
    .environment(\.pokemonData, PokemonPreviewData())
}
