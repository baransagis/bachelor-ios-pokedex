import SwiftUI

struct ListScreen: View {
    private let repository: PokedexRepository
    @StateObject private var viewModel: ListViewModel
    @Environment(\.colorScheme) private var colorScheme

    init(repository: PokedexRepository) {
        self.repository = repository
        _viewModel = StateObject(wrappedValue: ListViewModel(repository: repository))
    }

    var body: some View {
        ZStack {
            PokedexListStyle.background(for: colorScheme)
                .ignoresSafeArea()

            if viewModel.pokemonList.isEmpty {
                ProgressView()
            } else {
                PokemonListView(
                    pokemonList: viewModel.pokemonList,
                    colorScheme: colorScheme
                )
            }
        }
        .task {
            await viewModel.loadPokemon()
        }
        .navigationTitle("Pokédex")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(PokedexListStyle.background(for: colorScheme), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(colorScheme, for: .navigationBar)
        .navigationDestination(for: Int.self) { id in
            DetailScreen(id: id, repository: repository)
        }
    }
}

private struct PokemonListView: View {
    let pokemonList: [PokemonListItemDTO]
    let colorScheme: ColorScheme

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array(pokemonList.enumerated()), id: \.element.id) { index, pokemon in
                    PokemonRow(
                        pokemon: pokemon,
                        colorScheme: colorScheme
                    )

                    if index != pokemonList.count - 1 {
                        Divider()
                            .overlay(PokedexListStyle.divider(for: colorScheme))
                    }
                }
            }
        }
        .background(PokedexListStyle.background(for: colorScheme))
    }
}

private struct PokemonRow: View {
    let pokemon: PokemonListItemDTO
    let colorScheme: ColorScheme

    var body: some View {
        NavigationLink(value: pokemon.id) {
            HStack(alignment: .center, spacing: 0) {
                Text(PokedexListStyle.numberText(for: pokemon.id))
                    .font(.system(size: 24, weight: .semibold))
                    .monospacedDigit()
                    .foregroundStyle(PokedexListStyle.secondaryText(for: colorScheme))

                Spacer()
                    .frame(width: 24)

                VStack(alignment: .leading, spacing: 4) {
                    Text(pokemon.name)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(PokedexListStyle.primaryText(for: colorScheme))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    HStack(spacing: 4) {
                        ForEach(pokemon.types, id: \.self) { type in
                            PokemonTypeChip(type: type, colorScheme: colorScheme)
                        }
                    }
                }

                Spacer(minLength: 16)

                Image(PokedexListStyle.spriteName(for: pokemon.id))
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                    .accessibilityHidden(true)
            }
            .padding(16)
            .contentShape(Rectangle())
            .background(PokedexListStyle.background(for: colorScheme))
        }
        .buttonStyle(.plain)
    }
}

private struct PokemonTypeChip: View {
    let type: String
    let colorScheme: ColorScheme

    var body: some View {
        let color = PokedexListStyle.typeColor(for: type, colorScheme: colorScheme)

        Text(type)
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(color)
            .lineLimit(1)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(color.opacity(0.25), in: Capsule())
    }
}

#Preview {
    NavigationStack {
        ListScreen(repository: PokedexRepositoryImpl(api: PokedexAPIClient()))
    }
}

#Preview("Loaded dark") {
    NavigationStack {
        PokemonListView(
            pokemonList: [
                PokemonListItemDTO(id: 1, name: "Bisasam", types: ["Pflanze", "Gift"]),
                PokemonListItemDTO(id: 2, name: "Bisaknosp", types: ["Pflanze", "Gift"]),
                PokemonListItemDTO(id: 3, name: "Bisaflor", types: ["Pflanze", "Gift"]),
                PokemonListItemDTO(id: 4, name: "Glumanda", types: ["Feuer"]),
                PokemonListItemDTO(id: 5, name: "Glutexo", types: ["Feuer"]),
                PokemonListItemDTO(id: 6, name: "Glurak", types: ["Feuer", "Flug"]),
                PokemonListItemDTO(id: 7, name: "Schiggy", types: ["Wasser"]),
                PokemonListItemDTO(id: 8, name: "Schillok", types: ["Wasser"])
            ],
            colorScheme: .dark
        )
        .navigationTitle("Pokédex")
    }
    .preferredColorScheme(.dark)
}

#Preview("Loaded light") {
    NavigationStack {
        PokemonListView(
            pokemonList: [
                PokemonListItemDTO(id: 1, name: "Bisasam", types: ["Pflanze", "Gift"]),
                PokemonListItemDTO(id: 4, name: "Glumanda", types: ["Feuer"]),
                PokemonListItemDTO(id: 7, name: "Schiggy", types: ["Wasser"])
            ],
            colorScheme: .light
        )
        .navigationTitle("Pokédex")
    }
    .preferredColorScheme(.light)
}
