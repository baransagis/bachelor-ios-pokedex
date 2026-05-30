import Foundation

struct AppContainer {
    let pokedexRepository: PokedexRepository

    static func makeDefault() -> AppContainer {
        let apiClient = PokedexAPIClient()
        let repository = PokedexRepositoryImpl(api: apiClient)
        return AppContainer(pokedexRepository: repository)
    }
}
