//
//  ExchangeDetailViewModelTests.swift
//  QueroSerMBTests
//
//  Created by Marcio Habigzang Brufatto on 13/04/26.
//

import XCTest
@testable import QueroSerMB

@MainActor
final class ExchangeDetailViewModelTests: XCTestCase {
    
    class ExchangeServiceMock: ExchangeServiceProtocol {
        var assetsToReturn: [CurrencyData] = []
        var shouldFail = false
        
        func getExchanges(start: Int, limit: Int) async throws -> [Exchange] {
            return []
        }
        
        func getExchangeAssets(id: String) async throws -> [CurrencyData] {
            if shouldFail { throw NetworkError.serverError }
            return assetsToReturn
        }
    }
    
    func test_load_currencies_success() async {
        let mockExchange = Exchange(id: 270, name: "Binance", logo: "", description: nil, dateLaunched: nil, spotVolumeUsd: nil, makerFee: nil, takerFee: nil, urls: nil)
        let serviceMock = ExchangeServiceMock()
        
        let mockCurrency = Currency(name: "Solana", priceUSD: 140.0)
        serviceMock.assetsToReturn = [CurrencyData(currency: mockCurrency)]
        
        let viewModel = ExchangeDetailViewModel(exchange: mockExchange, service: serviceMock)
        
        await viewModel.loadCurrencies()
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.currencies.count, 1)
        XCTAssertEqual(viewModel.currencies.first?.currency.name, "Solana")
    }
    
    func test_load_currencies_failure() async {
        let mockExchange = Exchange(id: 270, name: "Binance", logo: "", description: nil, dateLaunched: nil, spotVolumeUsd: nil, makerFee: nil, takerFee: nil, urls: nil)
        let serviceMock = ExchangeServiceMock()
        serviceMock.shouldFail = true
        
        let viewModel = ExchangeDetailViewModel(exchange: mockExchange, service: serviceMock)
        
        await viewModel.loadCurrencies()
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.currencies.isEmpty)
    }
}
