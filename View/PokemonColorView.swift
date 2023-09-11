import SwiftUI

struct PokemonColorView: View {
    let colorName: String
    @Environment(\.getPokemonColor) private var getPokemonColor
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
                try await getPokemonColor(colorName)
            }
        }
        .task {
            await $pokemonColor.loadAsync {
                try await getPokemonColor(colorName)
            }
        }
        .alert(Text("Error"), isPresented: .boolify($pokemonColor.error)) {
            Button("OK", role: .cancel) { }
        }
        .navigationTitle("Species")
        .overlay {
            if
                !pokemonColor.hasValue,
                pokemonColor.state.isLoading
            {
                ProgressView()
            }
        }
    }
}

struct PokemonColorView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonColorView(colorName: "black")
    }
}
