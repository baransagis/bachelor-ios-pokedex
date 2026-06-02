import Foundation

struct PokedexRepositoryImpl: PokedexRepository {
    private let api: PokedexAPI
    private let pokemonListLocalDataSource: PokemonListLocalDataSource

    init(api: PokedexAPI, pokemonListLocalDataSource: PokemonListLocalDataSource) {
        self.api = api
        self.pokemonListLocalDataSource = pokemonListLocalDataSource
    }

    func loadPokemonList() async throws -> [PokemonListItemDTO] {
        try await api.getPokemonList()
    }

    func loadPokemonDetail(id: Int) async throws -> PokemonDetailDTO {
        try await api.getPokemonDetail(id: id)
    }
}
