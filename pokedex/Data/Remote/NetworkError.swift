import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case requestFailed
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .requestFailed:
            return "Network request failed."
        case .invalidResponse:
            return "Invalid response received."
        case .httpError(let statusCode):
            return "Server returned status code \(statusCode)."
        case .decodingFailed:
            return "Failed to decode response data."
        }
    }
}
