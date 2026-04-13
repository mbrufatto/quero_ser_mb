//
//  ExchangeAssetsAPI.swift
//  QueroSerMB
//
//  Created by Marcio Habigzang Brufatto on 13/04/26.
//

import Foundation

enum ExchangeAssetsAPI: APIEndpoint {
    case assets(id: String)
    
    var baseURL: String { Configuration.baseUrl }
    
    var path: String {
        switch self {
        case .assets: return "/v1/exchange/assets"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .assets(let id):
            return [URLQueryItem(name: "id", value: id)]
        }
    }
    
    var method: HTTPMethod { .get }
    var headers: [String: String]? {
        ["X-CMC_PRO_API_KEY": Configuration.apiKey ]
    }
}
