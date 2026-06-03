import Foundation

protocol PokedexRepository {
    func observePokemonList() -> AsyncStream<[PokemonListItemDTO]>
    func loadPokemonList() async throws -> [PokemonListItemDTO]
    func loadPokemonDetail(id: Int) async throws -> PokemonDetailDTO
}
