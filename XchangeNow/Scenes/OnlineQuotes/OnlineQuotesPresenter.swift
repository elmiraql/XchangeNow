//
//  OnlineQuotesPresenter.swift
//  XchangeNow
//
//  Created by Elmira Qurbanova on 03.04.25.
//

import Foundation

protocol OnlineQuotesPresentationLogic {
    func presentQuotes(_ quotes: [OnlineQuote])
    func presentConnectionStatus(isConnected: Bool)
}

final class OnlineQuotesPresenter: OnlineQuotesPresentationLogic {
    
    weak var viewController: OnlineQuotesDisplayLogic?
    
    func presentQuotes(_ quotes: [OnlineQuote]) {
        let viewModels = quotes.map {
            OnlineQuoteViewModel(
                symbol: $0.symbol,
                bid: $0.bidPrice,
                ask: $0.askPrice,
                spread: $0.spread,
                trend: $0.trend,
                time: $0.lastTime,
                low: $0.lowPrice,
                high: $0.highPrice
            )
        }
        viewController?.displayQuotes(viewModels)
    }
    
    func presentConnectionStatus(isConnected: Bool) {
        viewController?.displayConnectionStatus(isConnected: isConnected)
    }
}

struct OnlineQuoteViewModel {
    let symbol: String
    let bid: String
    let ask: String
    let spread: String
    let trend: String
    let time: String
    let low: String
    let high: String
}

