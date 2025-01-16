//
//  NetworkManagerProtocol.swift
//  CatFacts
//
//  Created by ANSK Vivek on 15/01/25.
//

import Foundation

protocol NetworkManagerProtocol {
    func getData<T: Decodable>(urlString: String, type: T.Type) async throws -> T
}

final class NetworkManager: NetworkManagerProtocol {
    
    private let session = URLSession.shared
    static let shared = NetworkManager()
    
    private init() { }
    
    func getData<T: Decodable>(urlString: String, type: T.Type) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            let urlComponents = URLComponents(string: urlString)!
            
            guard let url = urlComponents.url else {
                continuation.resume(throwing: NetworkError.invalidURL)
                return
            }

            
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let data else {
                    continuation.resume(throwing: NetworkError.invalidData)
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(T.self, from: data)
                    continuation.resume(returning: response)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
            
            task.resume()
        }
    }
    
}
