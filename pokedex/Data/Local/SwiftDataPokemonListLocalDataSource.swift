import Foundation
import SwiftData

@ModelActor
actor SwiftDataPokemonListLocalDataSource: PokemonListLocalDataSource {
    func fetchPokemonList() async throws -> [PokemonListItemDTO] {
        var descriptor = FetchDescriptor<PokemonListItemEntity>(
            sortBy: [SortDescriptor(\PokemonListItemEntity.id)]
        )
        descriptor.includePendingChanges = true

        return try modelContext.fetch(descriptor).map { $0.toDTO() }
    }

    func pokemonCount() async throws -> Int {
        let descriptor = FetchDescriptor<PokemonListItemEntity>()
        return try modelContext.fetchCount(descriptor)
    }

    func insertPokemon(_ pokemon: [PokemonListItemDTO]) async throws {
        for item in pokemon {
            if let existingItem = try fetchPokemon(id: item.id) {
                existingItem.update(with: item)
            } else {
                modelContext.insert(PokemonListItemEntity(dto: item))
            }
        }

        try modelContext.save()
    }

    private func fetchPokemon(id: Int) throws -> PokemonListItemEntity? {
        var descriptor = FetchDescriptor<PokemonListItemEntity>(
            predicate: #Predicate { $0.id == id }
        )
        descriptor.fetchLimit = 1

        return try modelContext.fetch(descriptor).first
    }
}
