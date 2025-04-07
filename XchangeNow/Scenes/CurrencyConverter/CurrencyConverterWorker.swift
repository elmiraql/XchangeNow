//
//  CurrencyConverterWorker.swift
//  XchangeNow
//
//  Created by Elmira on 03.04.25.
//

import Foundation

protocol CurrencyConverterWorking {
    func fetchCurrencyList() async throws -> [Currency]
    func fetchRate(from baseCurrency: String, date: String) async throws -> [CurrencyRate]
}

final class CurrencyConverterWorker: CurrencyConverterWorking {

    private let service = CurrencyService()

    func fetchCurrencyList() async throws -> [Currency] {
        return try await service.fetchCurrencyList()
    }

    func fetchRate(from baseCurrency: String, date: String) async throws -> [CurrencyRate] {
        return try await service.fetchRate(from: baseCurrency, date: date)
    }
}
