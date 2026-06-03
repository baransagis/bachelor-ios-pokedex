import Foundation
import SwiftData

@ModelActor
actor SwiftDataPokemonListLocalDataSource: PokemonListLocalDataSource {
    private var continuations: [UUID: AsyncStream<[PokemonListItemDTO]>.Continuation] = [:]

    nonisolated func observePokemonList() -> AsyncStream<[PokemonListItemDTO]> {
        AsyncStream { continuation in
            let id = UUID()

            Task {
                await self.addContinuation(continuation, id: id)
            }

            continuation.onTermination = { _ in
                Task {
                    await self.removeContinuation(id: id)
                }
            }
        }
    }

    func fetchPokemonList() async throws -> [PokemonListItemDTO] {
        try fetchPokemonListSnapshot()
    }

    private func fetchPokemonListSnapshot() throws -> [PokemonListItemDTO] {
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
        try publishPokemonList()
    }

    private func fetchExistingPokemonById() throws -> [Int: PokemonListItemEntity] {
        let descriptor = FetchDescriptor<PokemonListItemEntity>()
        let existingPokemon = try modelContext.fetch(descriptor)

        return Dictionary(uniqueKeysWithValues: existingPokemon.map { ($0.id, $0) })
    }

    private func addContinuation(
        _ continuation: AsyncStream<[PokemonListItemDTO]>.Continuation,
        id: UUID
    ) {
        continuations[id] = continuation

        do {
            continuation.yield(try fetchPokemonListSnapshot())
        } catch {
            debugPrint("Failed to observe Pokemon list: \(error)")
            continuation.yield([])
        }
    }

    private func removeContinuation(id: UUID) {
        continuations[id] = nil
    }

    private func publishPokemonList() throws {
        let pokemonList = try fetchPokemonListSnapshot()

        for continuation in continuations.values {
            continuation.yield(pokemonList)
        }
    }
}
