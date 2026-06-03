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
            PokedexTheme.Colors.background(for: colorScheme)
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
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(PokedexTheme.Colors.background(for: colorScheme), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(colorScheme, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Pokédex")
                    .font(PokedexTheme.Typography.toolbarTitle)
                    .foregroundStyle(PokedexTheme.Colors.primaryText(for: colorScheme))
            }
        }
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
                            .overlay(PokedexTheme.Colors.divider(for: colorScheme))
                    }
                }
            }
        }
        .background(PokedexTheme.Colors.background(for: colorScheme))
    }
}

private struct PokemonRow: View {
    let pokemon: PokemonListItemDTO
    let colorScheme: ColorScheme

    var body: some View {
        NavigationLink(value: pokemon.id) {
            HStack(alignment: .center, spacing: 0) {
                Text(PokedexTheme.Format.pokemonNumber(id: pokemon.id))
                    .font(PokedexTheme.Typography.listNumber)
                    .monospacedDigit()
                    .foregroundStyle(PokedexTheme.Colors.secondaryText(for: colorScheme))

                Spacer()
                    .frame(width: 24)

                VStack(alignment: .leading, spacing: 4) {
                    Text(pokemon.name)
                        .font(PokedexTheme.Typography.listTitle)
                        .foregroundStyle(PokedexTheme.Colors.primaryText(for: colorScheme))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    HStack(spacing: 4) {
                        ForEach(pokemon.types, id: \.self) { type in
                            PokemonTypeChip(type: type, colorScheme: colorScheme)
                        }
                    }
                }

                Spacer(minLength: 16)

                Image(PokedexTheme.Assets.pokemonSpriteName(for: pokemon.id))
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                    .accessibilityHidden(true)
            }
            .padding(16)
            .contentShape(Rectangle())
            .background(PokedexTheme.Colors.background(for: colorScheme))
        }
        .buttonStyle(.plain)
    }
}

private struct PokemonTypeChip: View {
    let type: String
    let colorScheme: ColorScheme

    var body: some View {
        let color = PokedexTheme.Colors.typeColor(for: type, colorScheme: colorScheme)

        Text(type)
            .font(PokedexTheme.Typography.typeChip)
            .foregroundStyle(color)
            .lineLimit(1)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(color.opacity(0.25), in: Capsule())
    }
}

#Preview {
    NavigationStack {
        ListScreen(repository: AppContainer.makeDefault().pokedexRepository)
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
