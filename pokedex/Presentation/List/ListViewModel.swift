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
        await observePokemonList()

        guard !hasLoaded else {
            return
        }

        isLoading = true
        defer {
            isLoading = false
        }

        do {
            _ = try await repository.loadPokemonList()
            hasLoaded = true
        } catch {
            debugPrint("Failed to load Pokemon list: \(error)")
        }
    }

    private func observePokemonList() async {
        guard observationTask == nil else {
            return
        }

        await withCheckedContinuation { continuation in
            observationTask = Task { [weak self, repository] in
                var didObserveInitialSnapshot = false
                let pokemonStream = repository.observePokemonList()

                for await pokemon in pokemonStream {
                    await MainActor.run {
                        self?.pokemonList = pokemon

                        if !didObserveInitialSnapshot {
                            didObserveInitialSnapshot = true
                            continuation.resume()
                        }
                    }
                }

                await MainActor.run {
                    if !didObserveInitialSnapshot {
                        continuation.resume()
                    }

                    self?.observationTask = nil
                }
            }
        }
    }
}
