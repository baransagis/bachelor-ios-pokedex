import Foundation

struct PokedexRepositoryImpl: PokedexRepository {
    private let api: PokedexAPI
    private let pokemonListLocalDataSource: PokemonListLocalDataSource

    init(api: PokedexAPI, pokemonListLocalDataSource: PokemonListLocalDataSource) {
        self.api = api
        self.pokemonListLocalDataSource = pokemonListLocalDataSource
    }

    func loadPokemonList() async throws {
        if try await pokemonListLocalDataSource.pokemonCount() == 0 {
            let pokemon = try await api.getPokemonList()
            try await pokemonListLocalDataSource.insertPokemon(pokemon)
        }
    }

    func loadPokemonDetail(id: Int) async throws -> PokemonDetailDTO {
        try await api.getPokemonDetail(id: id)
    }
}
