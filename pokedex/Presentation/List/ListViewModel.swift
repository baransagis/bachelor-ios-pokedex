import Foundation
import Observation

@MainActor
@Observable
final class ListViewModel {
    private(set) var isError = false

    @ObservationIgnored
    private let repository: PokedexRepository

    init(repository: PokedexRepository) {
        self.repository = repository
    }

    func loadPokemon() async {
        do {
            try await repository.loadPokemonList()
            isError = false
        } catch {
            isError = true
            debugPrint("Failed to load Pokemon list: \(error)")
        }
    }
}
