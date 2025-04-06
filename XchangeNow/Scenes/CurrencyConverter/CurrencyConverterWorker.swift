//
//  CurrencyConverterWorker.swift
//  XchangeNow
//
//  Created by Elmira on 03.04.25.
//

import Foundation

final class CurrencyConverterWorker {

    private let service = CurrencyService()

    func fetchCurrencyList() async throws -> [Currency] {
        return try await service.fetchCurrencyList()
    }

    func fetchRate(from baseCurrency: String, date: String) async throws -> [CurrencyRate] {
        return try await service.fetchRate(from: baseCurrency, date: date)
    }
}
