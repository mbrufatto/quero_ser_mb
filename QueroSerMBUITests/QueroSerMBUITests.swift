//
//  QueroSerMBUITests.swift
//  QueroSerMBUITests
//
//  Created by Marcio Habigzang Brufatto on 13/04/26.
//

import XCTest

final class QueroSerMBUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launchArguments.append("-UIViewAnimationDurationScaleKey")
        app.launchArguments.append("0")
        app.launch()
    }
    
    func test_navigation_to_detail() {
        let firstCell = app.cells.containing(NSPredicate(format: "identifier BEGINSWITH 'exchange_cell_'")).firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5.0), "A lista não carregou.")
        
        var exchangeName = firstCell.label
        if exchangeName.isEmpty {
            exchangeName = firstCell.staticTexts["exchange_name_label"].label
        }
        
        exchangeName = exchangeName.components(separatedBy: ",").first ?? exchangeName
        
        print("--- DEBUG: Tentando navegar para: [\(exchangeName)] ---")
        
        firstCell.tap()
        
        let detailNameLabel = app.staticTexts["detail_exchange_name"]
        XCTAssertTrue(detailNameLabel.waitForExistence(timeout: 5.0), "Falha ao carregar a tela de detalhes.")
        
        if !exchangeName.isEmpty {
            XCTAssertEqual(detailNameLabel.label, exchangeName, "O nome na tela de detalhes não condiz com o selecionado.")
        }
        
        XCTAssertTrue(app.staticTexts["detail_website"].exists, "Campo de Website não encontrado.")
        XCTAssertTrue(app.staticTexts["detail_launch_date"].exists, "Campo de Lançamento não encontrado.")
        XCTAssertTrue(app.staticTexts["detail_about"].exists)
    }
    
    func test_search_funtionality() {
        let serachField = app.searchFields["Busca exchange"]
        XCTAssertTrue(serachField.exists)
        
        serachField.tap()
        serachField.typeText("HTX")
        
        let firstCell = app.cells.firstMatch
        XCTAssertTrue(firstCell.staticTexts["HTX"].exists)
    }
    
    func test_pagination_scroll() {
        let list = app.collectionViews.firstMatch
        
        list.swipeUp(velocity: .fast)
        list.swipeUp(velocity: .fast)
        
        XCTAssertTrue(app.cells.count > 0)
    }
}

