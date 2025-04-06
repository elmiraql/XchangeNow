//
//  OnlineQuotesInteractor.swift
//  XchangeNow
//
//  Created by Elmira Qurbanova on 03.04.25.
//

import Foundation

protocol OnlineQuotesBusinessLogic {
    func connectToQuotes()
    func disconnectFromQuotes()
    func toggleVisibility(for symbol: String)
}

final class OnlineQuotesInteractor: OnlineQuotesBusinessLogic, OnlineQuotesWorkerDelegate {
    
    var presenter: OnlineQuotesPresentationLogic?
    private let worker = OnlineQuotesWorker()
    private var allQuotes: [OnlineQuote] = []
    var hiddenSymbols: Set<String> = []
    
    init() {
        worker.delegate = self
    }
    
    func connectToQuotes() {
        worker.connect()
    }
    
    func disconnectFromQuotes() {
        worker.disconnect()
    }
    
    func toggleVisibility(for symbol: String) {
        if hiddenSymbols.contains(symbol) {
            hiddenSymbols.remove(symbol)
        } else {
            hiddenSymbols.insert(symbol)
        }
        filterAndPresentQuotes()
    }
    
    private func filterAndPresentQuotes() {
        let visibleQuotes = allQuotes.filter { !hiddenSymbols.contains($0.symbol) }
//        print(visibleQuotes)
        presenter?.presentQuotes(visibleQuotes)
//        presenter?.presentQuotes(allQuotes)
    }
    
    func showAllHiddenQuotes() {
        hiddenSymbols.removeAll()
        filterAndPresentQuotes()
    }
}

extension OnlineQuotesInteractor: OnlineQuotesServiceDelegate {
    
    func didReceiveQuotes(_ quotes: [OnlineQuote]) {
        guard !quotes.isEmpty else { return }
        allQuotes = quotes
        filterAndPresentQuotes()
    }
    
    func didUpdateConnectionStatus(connected: Bool) {
        presenter?.presentConnectionStatus(isConnected: connected)
    }
}

