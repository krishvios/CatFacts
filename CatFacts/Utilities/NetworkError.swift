import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case unexpectedStatuscode
    case invalidData
    case unknown
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid Response"
        case .unexpectedStatuscode:
            return "Unexpected Statuscode"
        case .invalidData:
            return "Invalid Data"
        case .unknown:
            return "Unknown Error"
        }
    }
}
