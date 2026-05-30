import Foundation

struct PokedexAPIClient: PokedexAPI {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let baseURLString: String

    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder(),
        baseURLString: String = "http://192.168.188.34:8080"
    ) {
        self.session = session
        self.decoder = decoder
        self.baseURLString = baseURLString
    }

    func getPokemonList() async throws -> [PokemonListItemDTO] {
        try await performRequest(path: "pokemon")
    }

    func getPokemonDetail(id: Int) async throws -> PokemonDetailDTO {
        try await performRequest(path: "pokemon/\(id)")
    }

    private func performRequest<T: Decodable>(path: String) async throws -> T {
        guard let url = URL(string: "\(baseURLString)/\(path)") else {
            throw NetworkError.invalidURL
        }

        let request = URLRequest(url: url)
        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw NetworkError.requestFailed
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard 200 ... 299 ~= httpResponse.statusCode else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
