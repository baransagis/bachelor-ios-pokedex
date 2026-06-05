import Foundation
import Observation

@MainActor
@Observable
final class DetailViewModel {
    private(set) var pokemon: PokemonDetailDTO?
    private(set) var isError = false

    @ObservationIgnored
    private let repository: PokedexRepository

    init(repository: PokedexRepository) {
        self.repository = repository
    }

    func loadPokemonDetail(id: Int) async {
        do {
            pokemon = try await repository.loadPokemonDetail(id: id)
            isError = false
        } catch {
            pokemon = nil
            isError = true
            debugPrint("Failed to load Pokemon detail: \(error)")
        }
    }
}
