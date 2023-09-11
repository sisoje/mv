import SwiftUI

struct PokemonColorsView: View {
    @Environment(\.getPokemonColors) private var getPokemonColors
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
                await $pokemonColors.loadAsync(getPokemonColors)
            }
            .task {
                await $pokemonColors.loadAsync(getPokemonColors)
            }
            .overlay {
                if
                    !pokemonColors.hasValue,
                    pokemonColors.state.isLoading
                {
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

struct PokemonColorsView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonColorsView()
    }
}
