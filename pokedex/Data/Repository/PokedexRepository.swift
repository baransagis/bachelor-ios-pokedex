import Foundation

protocol PokedexRepository {
    func loadPokemonList() async throws
    func loadPokemonDetail(id: Int) async throws -> PokemonDetailDTO
}
