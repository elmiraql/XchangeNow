//
//  CurrencyService.swift
//  XchangeNow
//
//  Created by Elmira on 04.04.25.
//


import Foundation

final class CurrencyService {

    private let baseURL = "https://valyuta.com/api"

    func fetchCurrencyList() async throws -> [Currency] {
        let url = URL(string: "\(baseURL)/get_currency_list_for_app")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let currencies = try JSONDecoder().decode([Currency].self, from: data)
        return currencies
    }

    func fetchRate(from baseCurrency: String, date: String) async throws -> [CurrencyRate] {
        let url = URL(string: "\(baseURL)/get_currency_rate_for_app/\(baseCurrency)/\(date)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let rates = try JSONDecoder().decode([CurrencyRate].self, from: data)
        print(rates)
        return rates
    }
}
