import Foundation
import Combine

@MainActor
final class ListViewModel: ObservableObject {
    @Published private(set) var isLoading = false
    @Published private(set) var pokemonList: [PokemonListItemDTO] = []

    private let repository: PokedexRepository
    private var hasLoaded = false

    init(repository: PokedexRepository) {
        self.repository = repository
    }

    func loadPokemon() async {
        guard !hasLoaded else {
            return
        }

        hasLoaded = true
        isLoading = true

        do {
            let pokemon = try await repository.loadPokemonList()
            pokemonList = pokemon
        } catch {
            debugPrint("Failed to load Pokemon list: \(error)")
        }

        isLoading = false
    }
}
