import Foundation
import Combine

@MainActor
final class DetailViewModel: ObservableObject {
    @Published private(set) var isLoading = false
    @Published private(set) var pokemon: PokemonDetailDTO?

    private let repository: PokedexRepository
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
