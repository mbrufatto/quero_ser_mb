//
//  CoinMarketCapAPI.swift
//  QueroSerMB
//
//  Created by Marcio Habigzang Brufatto on 10/04/26.
//

import Foundation

enum CoinMarketCapAPI: APIEndpoint {
    case map(start: Int, limit: Int)
    case info(ids: String)
    case quotes(exchangeId: String)
    
    var baseURL: String { Configuration.baseUrl }
    
    var path: String {
        switch self {
        case .map: return "/v1/exchange/map"
        case .info: return "/v1/exchange/info"
        case .quotes: return "/v1/exchange/quotes/latest"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .map(let start, let limit):
            return [URLQueryItem(name: "start", value: "\(start)"),
                    URLQueryItem(name: "limit", value: "\(limit)")
//                    URLQueryItem(name: "sort", value: "volume_24h")
            ]
        case .info(let ids):
            return [URLQueryItem(name: "id", value: ids)]
        case .quotes(let id):
            return [URLQueryItem(name: "id", value: id)]
        }
    }
    
    var method: HTTPMethod { .get }
    var headers: [String: String]? {
        ["X-CMC_PRO_API_KEY": Configuration.apiKey]
    }
}
