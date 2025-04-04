//
//  CurrencyConverterBuilder.swift
//  XchangeNow
//
//  Created by Elmira Qurbanova on 03.04.25.
//

import UIKit

enum CurrencyConverterBuilder {
    static func build() -> UIViewController {
        let viewController = CurrencyConverterViewController()
        let interactor = CurrencyConverterInteractor()
        let presenter = CurrencyConverterPresenter()
        let router = CurrencyConverterRouter()
        let worker = CurrencyConverterWorker()

        viewController.interactor = interactor
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController

        return viewController
    }
}
