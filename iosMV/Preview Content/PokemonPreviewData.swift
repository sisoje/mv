//
//  PokemonPreviewData.swift
//  iosMV
//
//  Created by Lazar Otasevic on 12.9.23..
//

import Foundation

struct PokemonPreviewData: PokemonDataProtocol {
    func getPokemonColors() async throws -> PokemonColorsResponse {
        PokemonColorsResponse(count: 1, results: [.init(name: "black", url: "")])
    }

    func getPokemonColor(colorName: String) async throws -> PokemonColorResponse {
        PokemonColorResponse(id: 1, name: "black", names: [.init(language: .init(name: "lang", url: ""), name: "black")], pokemonSpecies: [.init(name: "name", url: "")])
    }
}
