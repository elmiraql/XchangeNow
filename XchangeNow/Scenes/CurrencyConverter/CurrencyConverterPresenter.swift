//
//  CurrencyConverterPresenter.swift
//  XchangeNow
//
//  Created by Elmira Qurbanova on 03.04.25.
//

import Foundation

protocol CurrencyConverterPresentationLogic {
    func presentCurrencyList(_ currencies: [Currency])
    func presentConversionResult(_ result: Double)
    func presentError(_ message: String)
}
 
class CurrencyConverterPresenter: CurrencyConverterPresentationLogic {

    weak var viewController: CurrencyConverterDisplayLogic?

    func presentCurrencyList(_ currencies: [Currency]) {
//        let items = currencies.map { "\($0.code) - \($0.name)" }
        viewController?.displayCurrencyList(currencies)
    }

    func presentConversionResult(_ result: Double) {
        let formatted = String(format: "≈ %.2f", result)
        print(formatted)
        viewController?.displayConvertedAmount(formatted)
    }

    func presentError(_ message: String) {
        print(message)
        viewController?.displayError(message)
    }
}
