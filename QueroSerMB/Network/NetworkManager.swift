//
//  NetworkManager.swift
//  QueroSerMB
//
//  Created by Marcio Habigzang Brufatto on 10/04/26.
//

import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case serverError
    case decodingError
    case unauthorized
    case rateLimitExceeded
    case badRequest(String?)
}

protocol NetworkServiceProtocol {
    func request<T: Codable>(endpoint: APIEndpoint) async throws -> T
}

final class NetworkManager: NetworkServiceProtocol {
    
    private let decoder: JSONDecoder
    
    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }

    func request<T: Codable>(endpoint: APIEndpoint) async throws -> T {
        var components = URLComponents(string: endpoint.baseURL + endpoint.path)
        components?.queryItems = endpoint.queryItems
        
        guard let url = components?.url else { throw NetworkError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        endpoint.headers?.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        request.timeoutInterval = 15.0
        
        let data: Data
        let response: URLResponse
        
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw NetworkError.serverError
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.serverError
        }

        try validateResponse(httpResponse, data: data)
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Erro de Decoding: \(error)")
            throw NetworkError.decodingError
        }
    }

    private func validateResponse(_ response: HTTPURLResponse, data: Data) throws {
        switch response.statusCode {
        case 200...299:
            return
        case 400:
            let errorMessage = String(data: data, encoding: .utf8)
            throw NetworkError.badRequest(errorMessage)
        case 401:
            throw NetworkError.unauthorized
        case 429:
            throw NetworkError.rateLimitExceeded
        default:
            throw NetworkError.serverError
        }
    }
}
