import SwiftUI

struct PokemonColorsView: View {
    @Environment(\.pokemonData) private var pokemonData
    @State private var pokemonColors: LoadableValue<PokemonColorsResponse> = .init()

    var body: some View {
        NavigationView {
            List(pokemonColors.value?.results ?? [], id: \.name) { pokemonColor in
                NavigationLink {
                    PokemonColorView(colorName: pokemonColor.name)
                } label: {
                    Text(pokemonColor.name)
                        .accessibilityIdentifier(pokemonColor.name)
                }
            }
            .refreshable {
                await $pokemonColors.loadAsync(pokemonData.getPokemonColors)
            }
            .taskOnce {
                await $pokemonColors.loadAsync(pokemonData.getPokemonColors)
            }
            .overlay {
                if pokemonColors.state.isLoading {
                    ProgressView()
                }
            }
            .alert(Text("Error"), isPresented: .boolify($pokemonColors.error)) {
                Button("OK", role: .cancel) {}
            }
            .navigationTitle("Colors")
        }
    }
}

#Preview {
    PokemonColorsView()
        .environment(\.pokemonData, PokemonPreviewData())
}
