//
//  CurrencyConverterViewController.swift
//  XchangeNow
//
//  Created by Elmira Qurbanova on 03.04.25.
//

import UIKit

protocol CurrencyConverterDisplayLogic: AnyObject {
    func displayCurrencyList(_ currencies: [Currency])
    func displayConvertedAmount(_ amount: String)
    func displayError(_ message: String)
}

class CurrencyConverterViewController: UIViewController {
    
    var converterView: CurrencyConverterView!
    var interactor: CurrencyConverterInteractor?
    private var currencyList: [Currency] = []
    private var debounceTimer: Timer?

    override func loadView() {
        super.loadView()
        let contentView = CurrencyConverterView()
        view = contentView
        converterView = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        converterView.fromCurrencyButton.addTarget(self, action: #selector(selectFromCurrency), for: .touchUpInside)
        converterView.toCurrencyButton.addTarget(self, action: #selector(selectToCurrency), for: .touchUpInside)
        converterView.amountTextField.addTarget(self, action: #selector(amountDidChange), for: .editingChanged)
        
        Task {
            await interactor?.loadCurrencyList()
        }
        
    }
    
    @objc private func selectFromCurrency() {
        converterView.showDropdown(options: currencyList.map { $0.code }, for: .from) { [weak self] selected in
            print("from : \(selected)")
            self?.convertIfNeeded(fromCode: selected)
        }
    }

    @objc private func selectToCurrency() {
        converterView.showDropdown(options: currencyList.map { $0.code }, for: .to) { [weak self] selected in
            print("to : \(selected)")
            self?.convertIfNeeded(toCode: selected)
        }
    }
    
    @objc private func amountDidChange() {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { [weak self] _ in
            self?.convertIfNeeded()
        }
    }
    
    private func convertIfNeeded(
        fromCode: String? = nil,
        toCode: String? = nil
    ) {
        let from = fromCode ?? converterView.fromCurrencyButton.title(for: .normal)
        let to = toCode ?? converterView.toCurrencyButton.title(for: .normal)

        guard
            let from = from,
            let to = to,
            let text = converterView.amountTextField.text,
            let amount = Double(text),
            !from.contains("curr"),
            !to.contains("curr")
        else {
            return
        }

        Task {
            await interactor?.convertCurrency(from: from, to: to, amount: amount)
        }
    }
    
}
extension CurrencyConverterViewController: CurrencyConverterDisplayLogic {
    func displayCurrencyList(_ currencies: [Currency]) {
        self.currencyList = currencies
    }

    func displayConvertedAmount(_ amount: String) {
        DispatchQueue.main.async {
            self.converterView.resultLabel.text = amount
            print(amount)
        }
    }

    func displayError(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}
