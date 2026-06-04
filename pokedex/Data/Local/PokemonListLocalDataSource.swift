import Foundation

protocol PokemonListLocalDataSource {
    func pokemonCount() async throws -> Int
    func insertPokemon(_ pokemon: [PokemonListItemDTO]) async throws
}
