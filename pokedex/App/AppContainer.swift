import SwiftData

struct AppContainer {
    let pokedexRepository: PokedexRepository

    static func makeDefault() -> AppContainer {
        let apiClient = PokedexAPIClient()
        let modelContainer = try! ModelContainer(for: PokemonListItemEntity.self)
        let localDataSource = SwiftDataPokemonListLocalDataSource(modelContainer: modelContainer)
        let repository = PokedexRepositoryImpl(api: apiClient, pokemonListLocalDataSource: localDataSource)
        return AppContainer(pokedexRepository: repository)
    }
}
