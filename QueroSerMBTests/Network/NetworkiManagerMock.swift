//
//  NetworkiManagerMock.swift
//  QueroSerMB
//
//  Created by Marcio Habigzang Brufatto on 13/04/26.
//

import Foundation
@testable import QueroSerMB

class NetworkiManagerMock: NetworkServiceProtocol {
    
    var results: [Result<Data, Error>] = []
    
    func request<T: Codable>(endpoint: APIEndpoint) async throws -> T {
        guard !results.isEmpty else {
            throw NetworkError.serverError
        }
        
        let result = results.removeFirst()
        
        switch result {
        case .success(let data):
            return try JSONDecoder().decode(T.self, from: data)
        case .failure(let error):
            throw error
        }
    }
}
