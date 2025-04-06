//
//  OnlineQuotesInteractor.swift
//  XchangeNow
//
//  Created by Elmira on 03.04.25.
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
    private var lastCacheTime: Date?
    
    init() {
        loadCachedQuotes()
        worker.delegate = self
//        clearQuotesCache()
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
        presenter?.presentQuotes(visibleQuotes)
//        presenter?.presentQuotes(allQuotes)
    }
    
    func showAllHiddenQuotes() {
        hiddenSymbols.removeAll()
        filterAndPresentQuotes()
    }
    
    private func cacheQuotes(_ quotes: [OnlineQuote]) {
        do {
            let data = try JSONEncoder().encode(quotes)
            UserDefaults.standard.set(data, forKey: "cachedQuotes")
            print("кэш сохранился")
        } catch {
            print("кэш не сохранился:", error)
        }
    }
    
    private func loadCachedQuotes() {
        guard let data = UserDefaults.standard.data(forKey: "cachedQuotes") else { return }
        do {
            let quotes = try JSONDecoder().decode([OnlineQuote].self, from: data)
            self.allQuotes = quotes
            filterAndPresentQuotes()
            print("кэш извлечен")
        } catch {
            print("ошибка чтения кэша:", error)
        }
    }
    
    func clearQuotesCache() {
        UserDefaults.standard.removeObject(forKey: "cachedQuotes")
        print("кэш очищен")
    }
    
    private func snapshot(from quotes: [OnlineQuote]) -> [String: String] {
        Dictionary(uniqueKeysWithValues:
            quotes.map { quote in
                let key = quote.symbol
                let value = "\(quote.bidPrice)-\(quote.askPrice)-\(quote.spread)"
                return (key, value)
            }
        )
    }
}

extension OnlineQuotesInteractor: OnlineQuotesServiceDelegate {
    
    func didReceiveQuotes(_ quotes: [OnlineQuote]) {
        guard !quotes.isEmpty else { return }

        let newSnapshot = snapshot(from: quotes)

        let now = Date()
        let hasChanged = newSnapshot != snapshot(from: allQuotes)
        let hasEnoughDelay = lastCacheTime.map { now.timeIntervalSince($0) > 5 } ?? true

        if hasChanged && hasEnoughDelay {
            cacheQuotes(quotes)
            lastCacheTime = now
        }

        allQuotes = quotes
        filterAndPresentQuotes()
    }
    
    func didUpdateConnectionStatus(connected: Bool) {
        presenter?.presentConnectionStatus(isConnected: connected)
    }
}

