import Foundation

protocol PokedexRepository {
    func loadPokemonList() async throws -> [PokemonListItemDTO]
    func loadPokemonDetail(id: Int) async throws -> PokemonDetailDTO
}
