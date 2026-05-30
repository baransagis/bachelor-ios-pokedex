import Foundation

struct PokemonListItemDTO: Codable {
    let id: Int
    let name: String
    let types: [String]
}
