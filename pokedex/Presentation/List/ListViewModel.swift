import Foundation
import Combine

@MainActor
final class ListViewModel: ObservableObject {
    @Published private(set) var isLoading = false
    @Published private(set) var pokemonList: [PokemonListItemDTO] = []

    private let repository: PokedexRepository
    private var hasLoaded = false
    private var observationTask: Task<Void, Never>?

    init(repository: PokedexRepository) {
        self.repository = repository
    }

    deinit {
        observationTask?.cancel()
    }

    func loadPokemon() async {
        observePokemonList()

        guard !hasLoaded else {
            return
        }

        hasLoaded = true
        isLoading = true

        do {
            _ = try await repository.loadPokemonList()
        } catch {
            debugPrint("Failed to load Pokemon list: \(error)")
        }

        isLoading = false
    }

    private func observePokemonList() {
        guard observationTask == nil else {
            return
        }

        observationTask = Task { [repository] in
            let pokemonStream = repository.observePokemonList()

            for await pokemon in pokemonStream {
                pokemonList = pokemon
            }
        }
    }
}
