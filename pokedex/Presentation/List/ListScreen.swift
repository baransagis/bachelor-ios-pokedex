import SwiftData
import SwiftUI

struct ListScreen: View {
    private let repository: PokedexRepository
    @Query(sort: \PokemonListItemEntity.id) private var pokemonList: [PokemonListItemEntity]
    @State private var viewModel: ListViewModel

    init(repository: PokedexRepository) {
        self.repository = repository
        _viewModel = State(initialValue: ListViewModel(repository: repository))
    }

    var body: some View {
        ZStack {
            PokedexTheme.Colors.background
                .ignoresSafeArea()

            if !pokemonList.isEmpty {
                PokemonListView(pokemonList: pokemonList)
            } else if viewModel.isError {
                ErrorView {
                    await viewModel.loadPokemon()
                }
            } else {
                ProgressView()
            }
        }
        .task {
            await viewModel.loadPokemon()
        }
        .navigationTitle("Pokédex")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(PokedexTheme.Colors.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Pokédex")
                    .font(PokedexTheme.Typography.toolbarTitle)
                    .foregroundStyle(PokedexTheme.Colors.primaryText)
            }
        }
        .navigationDestination(for: Int.self) { id in
            DetailScreen(id: id, repository: repository)
        }
    }
}

private struct PokemonListView: View {
    let pokemonList: [PokemonListItemEntity]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array(pokemonList.enumerated()), id: \.element.id) { index, pokemon in
                    PokemonRow(pokemon: pokemon)

                    if index != pokemonList.count - 1 {
                        Divider()
                            .overlay(PokedexTheme.Colors.divider)
                    }
                }
            }
        }
        .background(PokedexTheme.Colors.background)
    }
}

private struct PokemonRow: View {
    let pokemon: PokemonListItemEntity

    var body: some View {
        NavigationLink(value: pokemon.id) {
            HStack(alignment: .center, spacing: 0) {
                Text(PokedexTheme.Format.pokemonNumber(id: pokemon.id))
                    .font(PokedexTheme.Typography.listNumber)
                    .monospacedDigit()
                    .foregroundStyle(PokedexTheme.Colors.secondaryText)

                Spacer()
                    .frame(width: 24)

                VStack(alignment: .leading, spacing: 4) {
                    Text(pokemon.name)
                        .font(PokedexTheme.Typography.listTitle)
                        .foregroundStyle(PokedexTheme.Colors.primaryText)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    HStack(spacing: 4) {
                        ForEach(pokemon.types, id: \.self) { type in
                            PokemonTypeChip(type: type)
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
            .background(PokedexTheme.Colors.background)
        }
        .buttonStyle(.plain)
    }
}

private struct PokemonTypeChip: View {
    let type: String

    var body: some View {
        let color = PokedexTheme.Colors.typeColor(for: type)

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
    let container = AppContainer.makeDefault()
    NavigationStack {
        ListScreen(repository: container.pokedexRepository)
    }
    .modelContainer(container.modelContainer)
}

#Preview("Loaded dark") {
    NavigationStack {
        PokemonListView(
            pokemonList: [
                PokemonListItemEntity(id: 1, name: "Bisasam", types: ["Pflanze", "Gift"]),
                PokemonListItemEntity(id: 2, name: "Bisaknosp", types: ["Pflanze", "Gift"]),
                PokemonListItemEntity(id: 3, name: "Bisaflor", types: ["Pflanze", "Gift"]),
                PokemonListItemEntity(id: 4, name: "Glumanda", types: ["Feuer"]),
                PokemonListItemEntity(id: 5, name: "Glutexo", types: ["Feuer"]),
                PokemonListItemEntity(id: 6, name: "Glurak", types: ["Feuer", "Flug"]),
                PokemonListItemEntity(id: 7, name: "Schiggy", types: ["Wasser"]),
                PokemonListItemEntity(id: 8, name: "Schillok", types: ["Wasser"])
            ]
        )
        .navigationTitle("Pokédex")
    }
    .preferredColorScheme(.dark)
}

#Preview("Loaded light") {
    NavigationStack {
        PokemonListView(
            pokemonList: [
                PokemonListItemEntity(id: 1, name: "Bisasam", types: ["Pflanze", "Gift"]),
                PokemonListItemEntity(id: 4, name: "Glumanda", types: ["Feuer"]),
                PokemonListItemEntity(id: 7, name: "Schiggy", types: ["Wasser"])
            ]
        )
        .navigationTitle("Pokédex")
    }
    .preferredColorScheme(.light)
}
