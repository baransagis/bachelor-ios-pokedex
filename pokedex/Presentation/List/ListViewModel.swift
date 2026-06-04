import Foundation
import Observation

@MainActor
final class ListViewModel {
    private let repository: PokedexRepository

    init(repository: PokedexRepository) {
        self.repository = repository
    }

    func loadPokemon() async {
        do {
            try await repository.loadPokemonList()
        } catch {
            debugPrint("Failed to load Pokemon list: \(error)")
        }
    }
}
