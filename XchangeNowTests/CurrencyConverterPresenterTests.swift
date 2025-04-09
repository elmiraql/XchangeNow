//
//  CurrencyConverterPresenterTests.swift
//  XchangeNowTests
//
//  Created by Elmira Qurbanova on 08.04.25.
//

import XCTest
@testable import XchangeNow

final class CurrencyConverterPresenterTests: XCTestCase {

    final class MockView: CurrencyConverterDisplayLogic {
        
        var displayedAmount: String?
        var displayedCurrencies: [Currency]?
        var displayedError: String?

        func displayConvertedAmount(_ amount: String) {
            displayedAmount = amount
        }

        func displayCurrencyList(_ currencies: [Currency]) {
            displayedCurrencies = currencies
        }

        func displayError(_ message: String) {
            displayedError = message
        }
    }

    func testPresentConversionResult() {

        let view = MockView()
        let presenter = CurrencyConverterPresenter()
        presenter.viewController = view
        
        presenter.presentConversionResult(9.5)
        
        XCTAssertEqual(view.displayedAmount, "≈ 9.50")
    }

    func testPresentCurrencyList() {
        let view = MockView()
        let presenter = CurrencyConverterPresenter()
        presenter.viewController = view

        let currencies = [
            Currency(code: "USD", name: "US Dollar"),
            Currency(code: "EUR", name: "Euro")
        ]

        presenter.presentCurrencyList(currencies)

        XCTAssertEqual(view.displayedCurrencies?.count, 2)
        XCTAssertEqual(view.displayedCurrencies?.first?.code, "USD")
    }

    func testPresentError() {
        let view = MockView()
        let presenter = CurrencyConverterPresenter()
        presenter.viewController = view

        presenter.presentError("something wrong")

        XCTAssertEqual(view.displayedError, "something wrong")
    }
}
