//
//  CurrencyConverterInteractorTests.swift
//  XchangeNowTests
//
//  Created by Elmira on 07.04.25.
//

import XCTest
@testable import XchangeNow

final class CurrencyConverterInteractorTests: XCTestCase {
    
    var presenter: MockPresenter!
    
    override func setUp() {
        super.setUp()
        presenter = MockPresenter()
    }
    
    final class MockPresenter: CurrencyConverterPresentationLogic {
        
        var convertedAmount: String?
        var errorMessage: String?
        var presentedCurrencies: [Currency]?
        
        func presentCurrencyList(_ currencies: [XchangeNow.Currency]) {
            presentedCurrencies = currencies
        }
        
        func presentConversionResult(_ result: Double) {
            convertedAmount = String(format: "%.2f", result)
        }
        
        func presentError(_ message: String) {
            errorMessage = message
        }
        
    }
    
    final class MockWorker: CurrencyConverterWorking {
        
        func fetchCurrencyList() async throws -> [Currency] {
            return [Currency(code: "USD", name: "US Dollar"),
                    Currency(code: "EUR", name: "Euro")]
        }
        
        func fetchRate(from baseCurrency: String, date: String) async throws -> [CurrencyRate] {
            return [
                CurrencyRate(from: "USD", to: "EUR", result: 0.9, date: "2025-04-07")
            ]
        }
    }
    
    final class MockWorkerWithError: CurrencyConverterWorking {
        func fetchCurrencyList() async throws -> [Currency] {
            throw URLError(.notConnectedToInternet)
        }

        func fetchRate(from baseCurrency: String, date: String) async throws -> [CurrencyRate] {
                throw URLError(.badServerResponse)
            }
    }
    
    final class MockWorkerMissingRate: CurrencyConverterWorking {
        func fetchCurrencyList() async throws -> [Currency] {
            return []
        }

        func fetchRate(from baseCurrency: String, date: String) async throws -> [CurrencyRate] {
            return [
                CurrencyRate(from: "USD", to: "EUR", result: 0.9, date: "2025-04-07")
            ]
        }
    }
    
    func testConvertCurrency() async {
        let worker = MockWorker()
        let interactor = CurrencyConverterInteractor(worker: worker, presenter: presenter)
        
        await interactor.convertCurrency(from: "USD", to: "EUR", amount: 10)
        
        XCTAssertEqual(presenter.convertedAmount, "9.00")
        XCTAssertNil(presenter.errorMessage)
    }
    
    func testLoadCurrencyListSuccess() async {
        let worker = MockWorker()
        let interactor = CurrencyConverterInteractor(worker: worker, presenter: presenter)
        
        await interactor.loadCurrencyList()
        
        XCTAssertEqual(presenter.presentedCurrencies?.count, 2)
        XCTAssertEqual(presenter.presentedCurrencies?.first?.code, "USD")
        XCTAssertNil(presenter.errorMessage)
    }
    
    func testLoadCurrencyListFail() async {
        let worker = MockWorkerWithError()
        let interactor = CurrencyConverterInteractor(worker: worker, presenter: presenter)

        await interactor.loadCurrencyList()

        XCTAssertNil(presenter.presentedCurrencies)
        XCTAssertEqual(presenter.errorMessage, "failed to load currency list")
    }
    
    func testConvertCurrencyRateNotFound() async {
        let worker = MockWorkerMissingRate()
        let interactor = CurrencyConverterInteractor(worker: worker, presenter: presenter)

        await interactor.convertCurrency(from: "USD", to: "AZN", amount: 10)

        XCTAssertNil(presenter.convertedAmount)
        XCTAssertEqual(presenter.errorMessage, "rate not found for USD → AZN")
    }
    
    func testConvertCurrencyFail() async {
        let worker = MockWorkerWithError()
        let interactor = CurrencyConverterInteractor(worker: worker, presenter: presenter)

        await interactor.convertCurrency(from: "USD", to: "EUR", amount: 10)

        XCTAssertNil(presenter.convertedAmount)
        XCTAssertTrue(presenter.errorMessage?.contains("conversion failed") == true)
    }
    
}
