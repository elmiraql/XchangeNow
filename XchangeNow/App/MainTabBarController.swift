//
//  MainTabBarController.swift
//  XchangeNow
//
//  Created by Elmira Qurbanova on 03.04.25.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        setupTabs()
        
        tabBar.barTintColor = .black
        tabBar.tintColor = .purple
        tabBar.unselectedItemTintColor = .lightGray
    }
    
    private func setupTabs() {
        let currencyVC = CurrencyConverterBuilder.build()
        currencyVC.tabBarItem = UITabBarItem(title: "Converter", image: UIImage(systemName: "dollarsign.circle"), tag: 0)
        
        let quotesVC = OnlineQuotesBuilder.build()
        quotesVC.tabBarItem = UITabBarItem(title: "Quotes", image: UIImage(systemName: "chart.bar"), tag: 1)
        
        viewControllers = [currencyVC, quotesVC]
    }
}
