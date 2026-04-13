//
//  Exchange.swift
//  QueroSerMB
//
//  Created by Marcio Habigzang Brufatto on 10/04/26.
//

import Foundation

struct Exchange: Codable, Identifiable {
    let id: Int
    let name: String
    let logo: String
    let description: String?
    let dateLaunched: String?
    let spotVolumeUsd: Double?
    let makerFee: Double?
    let takerFee: Double?
    let urls: ExchangeURLs?
    
    struct ExchangeURLs: Codable {
        let website: [String]?
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, logo, description, urls
        case dateLaunched = "date_launched"
        case spotVolumeUsd = "spot_volume_usd"
        case makerFee = "maker_fee"
        case takerFee = "taker_fee"
    }
}
