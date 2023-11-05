import SwiftUI

struct PokemonColorsView: View {
    @PokemonColorsViewModel var pokemonColors

    var body: some View {
        NavigationView {
            VStack {
                TimerView()
                Button("Reload") {
                    _pokemonColors.load()
                }
                List(pokemonColors.value?.results ?? [], id: \.name) { pokemonColor in
                    NavigationLink {
                        PokemonColorView(colorName: pokemonColor.name)
                    } label: {
                        Text(pokemonColor.name)
                            .accessibilityIdentifier(pokemonColor.name)
                    }
                }
            }
            .refreshable {
                await _pokemonColors.loadAsync()
            }
            .taskOnce {
                await _pokemonColors.loadAsync()
            }
            .overlay {
                if pokemonColors.isLoading {
                    ProgressView()
                }
            }
            .alert(Text("Error"), isPresented: .boolify(_pokemonColors.errorBinding)) {
                Button("OK", role: .cancel) {}
            }
            .navigationTitle("Colors")
        }
    }
}

#Preview {
    PokemonColorsView()
        .environment(\.pokemonData, PokemonPreviewData())
        .environment(\.timerScheduler) { _, _ in {} }
}
