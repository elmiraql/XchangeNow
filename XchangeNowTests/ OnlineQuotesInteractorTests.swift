//
//   OnlineQuotesInteractorTests.swift
//  XchangeNowTests
//
//  Created by Elmira Qurbanova on 08.04.25.
//

import XCTest
@testable import XchangeNow

final class OnlineQuotesInteractorTests: XCTestCase {

    final class MockPresenter: OnlineQuotesPresentationLogic {
        
        var receivedQuotes: [OnlineQuoteViewModel]?
        var receivedConnectionStatus: Bool?

        func presentQuotes(_ quotes: [OnlineQuote]) {
            receivedQuotes = quotes.map{
                OnlineQuoteViewModel(symbol: $0.symbol,
                                     bid: $0.bidPrice,
                                     ask: $0.askPrice,
                                     spread: $0.spread,
                                     trend: $0.trend,
                                     time: $0.trend,
                                     low: $0.lowPrice,
                                     high: $0.highPrice)
            }
        }

        func presentConnectionStatus(isConnected: Bool) {
            receivedConnectionStatus = isConnected
        }
    }

    func testDidReceiveQuotes() {

        let presenter = MockPresenter()
        let interactor = OnlineQuotesInteractor(presenter: presenter)

        let rawQuote: [String: String] = [
            "0": "up",
            "1": "USDJPY",
            "2": "145.2",
            "3": "145.5",
            "4": "144.9",
            "5": "146.1",
            "6": "3",
            "7": "2025-04-07T12:00:00"
        ]

        guard let quote = OnlineQuote(from: rawQuote) else {
            XCTFail("не удалось создать OnlineQuote из словаря")
            return
        }

        interactor.didReceiveQuotes([quote])

        XCTAssertEqual(presenter.receivedQuotes?.count, 1)
        XCTAssertEqual(presenter.receivedQuotes?.first?.symbol, "USDJPY")
    }
    
    func testHideAndShowQuote() {

        let presenter = MockPresenter()
        let interactor = OnlineQuotesInteractor(presenter: presenter)
//        interactor.presenter = presenter

        let rawQuote: [String: String] = [
            "0": "up",
            "1": "USDJPY",
            "2": "145.2",
            "3": "145.5",
            "4": "144.9",
            "5": "146.1",
            "6": "3",
            "7": "2025-04-07T12:00:00"
        ]
        
        guard let quote = OnlineQuote(from: rawQuote) else {
            XCTFail("не удалось создать котировку")
            return
        }

        interactor.didReceiveQuotes([quote])
        XCTAssertEqual(presenter.receivedQuotes?.count, 1)
        
        interactor.toggleVisibility(for: "USDJPY")
        XCTAssertEqual(presenter.receivedQuotes?.count, 0)

        interactor.toggleVisibility(for: "USDJPY")
        XCTAssertEqual(presenter.receivedQuotes?.count, 1)
    }
    
    func testLoadCachedQuotes() {

        UserDefaults.standard.removeObject(forKey: "cachedQuotes")

        let presenter = MockPresenter()
        let quoteData: [String: String] = [
            "0": "up",
            "1": "USDJPY",
            "2": "145.2",
            "3": "145.5",
            "4": "144.9",
            "5": "146.1",
            "6": "3",
            "7": "2025-04-07T12:00:00"
        ]
        
        guard let quote = OnlineQuote(from: quoteData) else {
            XCTFail("не удалось создать OnlineQuote")
            return
        }

        let data = try! JSONEncoder().encode([quote])
        UserDefaults.standard.set(data, forKey: "cachedQuotes")
        
        let interactor = OnlineQuotesInteractor(presenter: presenter)

        XCTAssertEqual(presenter.receivedQuotes?.count, 1)
        XCTAssertEqual(presenter.receivedQuotes?.first?.symbol, "USDJPY")
    }
    
    func testShowAllHiddenQuotes() {
        let presenter = MockPresenter()
        let interactor = OnlineQuotesInteractor(presenter: presenter)

        let quoteData: [String: String] = [
            "0": "up",
            "1": "USDJPY",
            "2": "145.2",
            "3": "145.5",
            "4": "144.9",
            "5": "146.1",
            "6": "3",
            "7": "2025-04-07T12:00:00"
        ]
        
        guard let quote = OnlineQuote(from: quoteData) else {
            XCTFail("не удалось создать OnlineQuote")
            return
        }
        interactor.didReceiveQuotes([quote])
        
        interactor.toggleVisibility(for: "USDJPY")

        XCTAssertEqual(presenter.receivedQuotes?.count, 0)

        interactor.showAllHiddenQuotes()

        XCTAssertEqual(presenter.receivedQuotes?.count, 1)
    }
}
