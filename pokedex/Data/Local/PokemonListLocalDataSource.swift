import Foundation

protocol PokemonListLocalDataSource {
    func fetchPokemonList() async throws -> [PokemonListItemDTO]
    func pokemonCount() async throws -> Int
    func insertPokemon(_ pokemon: [PokemonListItemDTO]) async throws
}
