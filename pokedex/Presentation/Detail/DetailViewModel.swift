import Foundation
import Combine

@MainActor
final class DetailViewModel: ObservableObject {
    @Published private(set) var isLoading = false
    @Published private(set) var jsonText = "No detail data loaded yet."
    @Published private(set) var errorText: String?

    private let repository: PokedexRepository

    init(repository: PokedexRepository) {
        self.repository = repository
    }

    func loadPokemonDetail(id: Int) async {
        isLoading = true
        errorText = nil

        do {
            let pokemon = try await repository.loadPokemonDetail(id: id)
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let data = try encoder.encode(pokemon)
            jsonText = String(decoding: data, as: UTF8.self)
        } catch {
            errorText = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }

        isLoading = false
    }
}
