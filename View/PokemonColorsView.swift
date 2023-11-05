import SwiftUI

struct PokemonColorsView: View {
    @PokemonColorsViewModel var viewModel

    var body: some View {
        NavigationView {
            VStack {
                TimerView()
                Button("Reload") {
                    _viewModel.load()
                }
                List(viewModel.value?.results ?? [], id: \.name) { pokemonColor in
                    NavigationLink {
                        PokemonColorView(colorName: pokemonColor.name)
                    } label: {
                        Text(pokemonColor.name)
                            .accessibilityIdentifier(pokemonColor.name)
                    }
                }
            }
            .refreshable {
                await _viewModel.loadAsync()
            }
            .taskOnce {
                await _viewModel.loadAsync()
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .alert(Text("Error"), isPresented: .boolify(_viewModel.$pokemonColors.error)) {
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
