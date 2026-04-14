//
//  ExchangeServiceTests.swift
//  QueroSerMB
//
//  Created by Marcio Habigzang Brufatto on 13/04/26.
//

import XCTest
@testable import QueroSerMB

final class ExchangeServiceTests: XCTestCase {
    var sut: ExchangeService!
    var networkMock: NetworkiManagerMock!
    
    override func setUp() {
        super.setUp()
        networkMock = NetworkiManagerMock()
        sut = ExchangeService(network: networkMock)
    }
    
    func test_get_exchanges_success() async throws {
        let mapJson = """
            {
              "data": [{ "id": 270, "name": "Binance" }]
            }
            """.data(using: .utf8)!
        
        let infoJson = """
            {
              "data": {
                "270": {
                  "id": 270,
                  "name": "Binance",
                  "logo": "https://url.com/logo.png",
                  "spot_volume_usd": 1000000
                }
              }
            }
            """.data(using: .utf8)!
        
        networkMock.results = [.success(mapJson), .success(infoJson)]
        
        let exchanges = try await sut.getExchanges(start: 1, limit: 1)
        
        XCTAssertEqual(exchanges.count, 1)
        XCTAssertEqual(exchanges.first?.name, "Binance")
        XCTAssertEqual(exchanges.first?.id, 270)
    }
    
    func test_get_exchanges_network_failure() async {
        networkMock.results = [.failure(NetworkError.serverError)]
        
        do {
            _ = try await sut.getExchanges(start: 1, limit: 1)
            XCTFail("Deveria ter lançado erro")
        } catch {
            XCTAssertEqual(error as? NetworkError, .serverError)
        }
    }
    
    func test_get_exchange_assets_success() async throws {
        let assetsJson = """
            {
                  "data": [
                    {
                      "currency": {
                        "name": "Bitcoin",
                        "price_usd": 65000.0
                      }
                    },
                    {
                      "currency": {
                        "name": "Ethereum",
                        "price_usd": 3500.0
                      }
                    }
                  ]
                }
            """.data(using: .utf8)!
        
        networkMock.results = [.success(assetsJson)]
        
        let assets = try await sut.getExchangeAssets(id: "270")
        
        XCTAssertEqual(assets.count, 2)
        XCTAssertEqual(assets.first?.currency.name, "Bitcoin")
        XCTAssertEqual(assets.last?.currency.priceUSD, 3500.0)
    }
}
