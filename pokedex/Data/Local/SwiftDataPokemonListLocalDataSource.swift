import Foundation
import SwiftData

@ModelActor
actor SwiftDataPokemonListLocalDataSource: PokemonListLocalDataSource {
    func pokemonCount() async throws -> Int {
        let descriptor = FetchDescriptor<PokemonListItemEntity>()
        return try modelContext.fetchCount(descriptor)
    }

    func insertPokemon(_ pokemon: [PokemonListItemDTO]) async throws {
        var existingPokemonById = try fetchExistingPokemonById()

        for item in pokemon {
            if let existingItem = existingPokemonById[item.id] {
                existingItem.update(with: item)
            } else {
                let newItem = PokemonListItemEntity(dto: item)
                modelContext.insert(newItem)
                existingPokemonById[item.id] = newItem
            }
        }

        try modelContext.save()
    }

    private func fetchExistingPokemonById() throws -> [Int: PokemonListItemEntity] {
        let descriptor = FetchDescriptor<PokemonListItemEntity>()
        let existingPokemon = try modelContext.fetch(descriptor)

        return Dictionary(uniqueKeysWithValues: existingPokemon.map { ($0.id, $0) })
    }
}
