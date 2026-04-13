//
//  ExchageService.swift
//  QueroSerMB
//
//  Created by Marcio Habigzang Brufatto on 10/04/26.
//

import Foundation

protocol ExchangeServiceProtocol {
    func getExchanges(start: Int, limit: Int) async throws -> [Exchange]
    func getExchangeAssets(id: String) async throws -> [CurrencyData]
}

final class ExchangeService: ExchangeServiceProtocol {
    private let network: NetworkServiceProtocol
    
    init(network: NetworkServiceProtocol = NetworkManager()) {
        self.network = network
    }
    
    func getExchanges(start: Int, limit: Int) async throws -> [Exchange] {
        let mapResponse: MapResponse = try await network.request(endpoint: CoinMarketCapAPI.map(start: start, limit: limit))
        
        let ids = mapResponse.data.map { String($0.id) }.joined(separator: ",")
        let infoResponse: InfoResponse = try await network.request(endpoint: CoinMarketCapAPI.info(ids: ids))
        
        let list = infoResponse.data.values.compactMap { $0 }
        return list.sorted { ($0.spotVolumeUsd ?? 0) > ($1.spotVolumeUsd ?? 0) }
    }
    
    func getExchangeAssets(id: String) async throws -> [CurrencyData] {
        let currenciesResponse: CurrencyBase = try await network.request(endpoint: ExchangeAssetsAPI.assets(id: id))
        return currenciesResponse.data
    }
}
