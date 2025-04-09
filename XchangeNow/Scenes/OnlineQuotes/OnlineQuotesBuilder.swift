//
//  OnlineQuotesBuilder.swift
//  XchangeNow
//
//  Created by Elmira on 03.04.25.
//

import UIKit

enum OnlineQuotesBuilder {
    
    static func build() -> UIViewController {
        let viewController = OnlineQuotesViewController()
        let presenter = OnlineQuotesPresenter()
        let interactor = OnlineQuotesInteractor(presenter: presenter)
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        
        return viewController
    }
}
