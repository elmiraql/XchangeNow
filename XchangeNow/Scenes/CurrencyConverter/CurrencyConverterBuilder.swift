//
//  CurrencyConverterBuilder.swift
//  XchangeNow
//
//  Created by Elmira on 03.04.25.
//

import UIKit

enum CurrencyConverterBuilder {
    static func build() -> UIViewController {
        let viewController = CurrencyConverterViewController()
        let presenter = CurrencyConverterPresenter()
        let worker = CurrencyConverterWorker()
        let interactor = CurrencyConverterInteractor(worker: worker, presenter: presenter)
        let router = CurrencyConverterRouter()

        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController

        return viewController
    }
}
