//
//  MapResponse.swift
//  QueroSerMB
//
//  Created by Marcio Habigzang Brufatto on 10/04/26.
//

struct MapResponse: Codable {
    let data: [ExchangeMapItem]
}

struct ExchangeMapItem: Codable {
    let id: Int
    let name: String
}
