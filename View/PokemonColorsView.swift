import SwiftUI

struct PokemonColorsView: View {
    @PokemonColorsViewModel var viewModel
    var body: some View {
        NavigationView {
            VStack {
                AgeView()
                TimerView()
                Button("Reload") {
                    viewModel.load()
                }
                .disabled(viewModel.pokemonColors.isLoading)
                List(viewModel.pokemonColors.value?.results ?? [], id: \.name) { pokemonColor in
                    NavigationLink {
                        PokemonColorView(colorName: pokemonColor.name)
                    } label: {
                        Text(pokemonColor.name)
                            .accessibilityIdentifier(pokemonColor.name)
                    }
                }
            }
            .refreshable {
                await viewModel.loadAsync()
            }
            .taskOnce {
                await viewModel.loadAsync()
            }
            .overlay {
                if viewModel.pokemonColors.isLoading {
                    ProgressView()
                }
            }
            .alert(Text("Error"), isPresented: .boolify(viewModel.$pokemonColors.error)) {
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
