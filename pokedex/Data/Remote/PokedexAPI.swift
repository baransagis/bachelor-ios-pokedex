import Foundation

protocol PokedexAPI {
    func getPokemonList() async throws -> [PokemonListItemDTO]
    func getPokemonDetail(id: Int) async throws -> PokemonDetailDTO
}
