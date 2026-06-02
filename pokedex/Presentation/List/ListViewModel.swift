import Foundation
import Combine

final class ListViewModel: ObservableObject {
    @Published private(set) var isLoading = false
    @Published private(set) var jsonText = "No list data loaded yet."
    @Published private(set) var errorText: String?

    private let repository: PokedexRepository

    init(repository: PokedexRepository) {
        self.repository = repository
    }

    func loadPokemon() async {
        await MainActor.run {
            isLoading = true
            errorText = nil
        }

        do {
            let pokemon = try await repository.loadPokemonList()
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let data = try encoder.encode(pokemon)
            let jsonText = String(decoding: data, as: UTF8.self)

            await MainActor.run {
                self.jsonText = jsonText
                self.isLoading = false
            }
        } catch {
            let errorText = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription

            await MainActor.run {
                self.errorText = errorText
                self.isLoading = false
            }
        }
    }
}
