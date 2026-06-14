import Foundation
import SwiftData

@ModelActor
actor SwiftDataPokemonListLocalDataSource: PokemonListLocalDataSource {
    func pokemonCount() async throws -> Int {
        let descriptor = FetchDescriptor<PokemonListItemEntity>()
        return try modelContext.fetchCount(descriptor)
    }

    func insertPokemon(_ pokemon: [PokemonListItemDTO]) async throws {
        for item in pokemon {
                let newItem = PokemonListItemEntity(dto: item)
                modelContext.insert(newItem)
        }

        try modelContext.save()
    }
}
