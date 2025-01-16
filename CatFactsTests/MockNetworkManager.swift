import Foundation
@testable import CatFacts

final class MockNetworkManager: NetworkManagerProtocol {
    var shouldThrowError: Bool = false
    var mockData: Data?

    func getData<T: Decodable>(urlString: String, type: T.Type) async throws -> T {
        if shouldThrowError {
            throw NetworkError.invalidData
        }

        guard let data = mockData else {
            throw NetworkError.invalidData
        }

        let decoded = try JSONDecoder().decode(T.self, from: data)
        return decoded
    }
}
