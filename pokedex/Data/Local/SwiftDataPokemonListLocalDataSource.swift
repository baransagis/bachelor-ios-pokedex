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
        for item in pokemon {
            if let existingItem = try fetchPokemon(id: item.id) {
                existingItem.update(with: item)
            } else {
                modelContext.insert(PokemonListItemEntity(dto: item))
            }
        }

        try modelContext.save()
        try publishPokemonList()
    }

    private func fetchPokemon(id: Int) throws -> PokemonListItemEntity? {
        var descriptor = FetchDescriptor<PokemonListItemEntity>(
            predicate: #Predicate { $0.id == id }
        )
        descriptor.fetchLimit = 1

        return try modelContext.fetch(descriptor).first
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
