//
//  ExchangeDetailViewModel.swift
//  QueroSerMB
//
//  Created by Marcio Habigzang Brufatto on 13/04/26.
//

import Foundation
import Combine

@MainActor
class ExchangeDetailViewModel: ObservableObject {
    @Published var exchange: Exchange
    @Published var currencies: [CurrencyData] = []
    @Published var isLoading: Bool = false
    
    private let service: ExchangeServiceProtocol
    
    init(exchange: Exchange, service: ExchangeServiceProtocol = ExchangeService()) {
        self.exchange = exchange
        self.service = service
    }
    
    func loadCurrencies() async {
        isLoading = true
        
        do {
            self.currencies = try await service.getExchangeAssets(id: String(exchange.id))
        } catch {
            print("Erro ao carregar moedas: \(error)")
        }
        
        isLoading = false
    }
}
