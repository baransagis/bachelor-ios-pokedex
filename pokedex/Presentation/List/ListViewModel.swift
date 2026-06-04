import Foundation
import Observation

@MainActor
@Observable
final class ListViewModel {
    private(set) var isLoading = false
    private(set) var pokemonList: [PokemonListItemDTO] = []

    @ObservationIgnored
    private let repository: PokedexRepository
    @ObservationIgnored
    private var hasLoaded = false
    @ObservationIgnored
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

        observationTask = Task { [weak self, repository] in
            let pokemonStream = repository.observePokemonList()

            for await pokemon in pokemonStream {
                await MainActor.run {
                    self?.pokemonList = pokemon
                }
            }

            await MainActor.run {
                self?.observationTask = nil
            }
        }
    }
}
