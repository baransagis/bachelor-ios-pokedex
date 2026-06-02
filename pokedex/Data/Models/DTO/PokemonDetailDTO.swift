import Foundation

struct PokemonDetailDTO: Codable {
    let id: Int
    let name: String
    let types: [String]
    let heightDm: Int
    let weightHg: Int
    let heightMeters: Double
    let weightKg: Double
    let abilities: [String]
    let baseStats: PokemonBaseStatsDTO
    let genus: String
    let description: String
    let color: String?
    let habitat: String?
}

struct PokemonBaseStatsDTO: Codable {
    let hp: Int
    let attack: Int
    let defense: Int
    let specialAttack: Int
    let specialDefense: Int
    let speed: Int
}
