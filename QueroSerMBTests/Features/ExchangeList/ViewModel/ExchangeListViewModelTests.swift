//
//  Untitled.swift
//  QueroSerMB
//
//  Created by Marcio Habigzang Brufatto on 13/04/26.
//

import XCTest
@testable import QueroSerMB

@MainActor
final class ExchangeListViewModelTests: XCTestCase {
    
    class ExchangeServiceMock: ExchangeServiceProtocol {
        var mockExchanges: [Exchange] = []
        var shouldFail = false
        
        func getExchanges(start: Int, limit: Int) async throws -> [Exchange] {
            if shouldFail { throw NetworkError.serverError }
            return mockExchanges
        }
        
        func getExchangeAssets(id: String) async throws -> [CurrencyData] {
            return []
        }
    }
    
    func test_load_exchanges_success_update_state() async {
        let serviceMock = ExchangeServiceMock()
        serviceMock.mockExchanges = [Exchange(id: 1, name: "Test", logo: "", description: nil, dateLaunched: nil, spotVolumeUsd: 100, makerFee: nil, takerFee: nil, urls: nil)]
        let viewModel = ExchangeListViewModel(service: serviceMock)
        
        await viewModel.loadExchanges()
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.exchanges.count, 1)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func test_load_exchanges_failure_sets_error_message() async {
        let serviceMock = ExchangeServiceMock()
        serviceMock.shouldFail = true
        let viewModel = ExchangeListViewModel(service: serviceMock)
        
        await viewModel.loadExchanges()
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, "Não foi possível carregar as exchanges.")
    }
}
