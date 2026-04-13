//
//  ExchangeListViewModel.swift
//  QueroSerMB
//
//  Created by Marcio Habigzang Brufatto on 10/04/26.
//

import Foundation
import Combine

@MainActor
class ExchangeListViewModel: ObservableObject {
    @Published var exchanges: [Exchange] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var currentPage = 1
    private let limit = 20
    private var canLoadMore = true
    
    private let service: ExchangeServiceProtocol
    
    init(service: ExchangeServiceProtocol = ExchangeService()) {
            self.service = service
        }
    
    func loadExchanges() async {
        
        guard !isLoading && canLoadMore else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let newExchanges = try await service.getExchanges(start: currentPage, limit: limit)
            
            if newExchanges.isEmpty {
                canLoadMore = false
            } else {
                self.exchanges.append(contentsOf: newExchanges)
                currentPage += limit
            }
            isLoading = false
        } catch {
            isLoading = false
            self.errorMessage = "Não foi possível carregar as exchanges."
            print("Error: \(error.localizedDescription)")
        }
    }
}
