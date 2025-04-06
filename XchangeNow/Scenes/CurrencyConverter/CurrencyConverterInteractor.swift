//
//  CurrencyConverterInteractor.swift
//  XchangeNow
//
//  Created by Elmira on 03.04.25.
//

import Foundation

protocol CurrencyConverterBusinessLogic {
    func loadCurrencyList() async
    func convertCurrency(from: String, to: String, amount: Double) async
}

class CurrencyConverterInteractor: CurrencyConverterBusinessLogic {
    
    var presenter: CurrencyConverterPresentationLogic?
    var worker = CurrencyConverterWorker()
    
    func loadCurrencyList() async {
        do {
            let currencies = try await worker.fetchCurrencyList()
            presenter?.presentCurrencyList(currencies)
        } catch {
            presenter?.presentError("failed to load currency list")
        }
    }
    
    func convertCurrency(from: String, to: String, amount: Double) async {
        let date = currentDate()

        do {
            let rates = try await worker.fetchRate(from: from, date: date)

            if let rate = rates.first(where: { $0.from == from && $0.to == to }) {
                let converted = amount * rate.result
                presenter?.presentConversionResult(converted)

            } else if let reverseRate = rates.first(where: { $0.from == to && $0.to == from }) {
                let converted = amount / reverseRate.result
                presenter?.presentConversionResult(converted)

            } else {
                presenter?.presentError("rate not found for \(from) → \(to)")
            }

        } catch {
            presenter?.presentError("conversion failed: \(error.localizedDescription)")
        }
    }
    
    private func currentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}
