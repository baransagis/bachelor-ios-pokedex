import Foundation
import Observation

@MainActor
@Observable
final class DetailViewModel {
    private(set) var isLoading = false
    private(set) var pokemon: PokemonDetailDTO?

    @ObservationIgnored
    private let repository: PokedexRepository
    @ObservationIgnored
    private var loadedId: Int?

    init(repository: PokedexRepository) {
        self.repository = repository
    }

    func loadPokemonDetail(id: Int) async {
        guard loadedId != id else {
            return
        }

        loadedId = id
        isLoading = true

        do {
            pokemon = try await repository.loadPokemonDetail(id: id)
        } catch {
            debugPrint("Failed to load Pokemon detail: \(error)")
        }

        isLoading = false
    }
}
