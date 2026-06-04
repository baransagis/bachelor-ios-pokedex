import Foundation
import Observation

@MainActor
@Observable
final class ListViewModel {
    private(set) var isLoading = false

    @ObservationIgnored
    private let repository: PokedexRepository
    @ObservationIgnored
    private var hasLoaded = false

    init(repository: PokedexRepository) {
        self.repository = repository
    }

    func loadPokemon() async {
        guard !hasLoaded else {
            return
        }

        isLoading = true
        defer {
            isLoading = false
        }

        do {
            try await repository.loadPokemonList()
            hasLoaded = true
        } catch {
            debugPrint("Failed to load Pokemon list: \(error)")
        }
    }
}
