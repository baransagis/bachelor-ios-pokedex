import Foundation

struct PokedexRepositoryImpl: PokedexRepository {
    private let api: PokedexAPI

    init(api: PokedexAPI) {
        self.api = api
    }

    func loadPokemonList() async throws -> [PokemonListItemDTO] {
        try await api.getPokemonList()
    }

    func loadPokemonDetail(id: Int) async throws -> PokemonDetailDTO {
        try await api.getPokemonDetail(id: id)
    }
}
