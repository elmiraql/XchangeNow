//
//  OnlineQuotesBuilder.swift
//  XchangeNow
//
//  Created by Elmira Qurbanova on 03.04.25.
//

import UIKit

enum OnlineQuotesBuilder {
    
    static func build() -> UIViewController {
        let viewController = OnlineQuotesViewController()
        let interactor = OnlineQuotesInteractor()
        let presenter = OnlineQuotesPresenter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        
        return viewController
    }
}
