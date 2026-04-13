//
//  Currency.swift
//  QueroSerMB
//
//  Created by Marcio Habigzang Brufatto on 13/04/26.
//

import Foundation

struct CurrencyBase: Codable {
    let data: [CurrencyData]
}

struct CurrencyData: Codable, Identifiable {
    let id: UUID = UUID()
    let currency: Currency
}

struct Currency: Codable, Identifiable {
    let id: UUID = UUID()
    let name: String
    let priceUSD: Double
    
    enum CodingKeys: String, CodingKey {
        case name
        case priceUSD = "price_usd"
    }
}


