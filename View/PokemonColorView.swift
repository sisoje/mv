import SwiftUI

struct PokemonColorView: View {
    let colorName: String
    @Environment(\.pokemonData) private var pokemonData
    @State private var pokemonColor: LoadableValue<PokemonColorResponse> = .init()
    
    var body: some View {
        List {
            ForEach(pokemonColor.value?.pokemonSpecies ?? [], id: \.name) { specie in
                Text(specie.name)
                    .accessibilityIdentifier(specie.name)
            }
        }
        .refreshable {
            await $pokemonColor.loadAsync {
                try await pokemonData.getPokemonColor(colorName: colorName)
            }
        }
        .taskOnce {
            await $pokemonColor.loadAsync {
                try await pokemonData.getPokemonColor(colorName: colorName)
            }
        }
        .alert(Text("Error"), isPresented: .boolify($pokemonColor.error)) {
            Button("OK", role: .cancel) {}
        }
        .navigationTitle("Species")
        .overlay {
            if pokemonColor.state.isLoading {
                ProgressView()
            }
        }
    }
}

#Preview {
    PokemonColorView(colorName: "black")
        .environment(\.pokemonData, PokemonPreviewData())
}
