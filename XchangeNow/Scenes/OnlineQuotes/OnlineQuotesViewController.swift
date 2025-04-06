//
//  OnlineQuotesViewController.swift
//  XchangeNow
//
//  Created by Elmira Qurbanova on 03.04.25.
//

import UIKit

protocol OnlineQuotesDisplayLogic: AnyObject {
    func displayQuotes(_ quotes: [OnlineQuoteViewModel])
    func displayConnectionStatus(isConnected: Bool)
}

class OnlineQuotesViewController: UIViewController {
    
    var interactor: OnlineQuotesBusinessLogic?
    private var quotes: [OnlineQuoteViewModel] = []
    private var contentView: OnlineQuotesView!
    
    override func loadView() {
        super.loadView()
        contentView = OnlineQuotesView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Quotes"
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        interactor?.connectToQuotes()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show Hidden", style: .plain, target: self, action: #selector(showHiddenQuotes))
    }
    
    deinit {
        interactor?.disconnectFromQuotes()
    }
    
    @objc private func showHiddenQuotes() {
        guard let interactor = interactor as? OnlineQuotesInteractor else { return }
        interactor.showAllHiddenQuotes()
    }
}

extension OnlineQuotesViewController: OnlineQuotesDisplayLogic {

    func displayQuotes(_ quotes: [OnlineQuoteViewModel]) {
        DispatchQueue.main.async {
            self.quotes = quotes
            self.contentView.tableView.reloadData()
        }
    }
    
    func displayConnectionStatus(isConnected: Bool) {
        DispatchQueue.main.async {
            self.contentView.updateConnectionStatus(isConnected: isConnected)
        }
    }
}

extension OnlineQuotesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = quotes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: OnlineQuoteCell.reuseID, for: indexPath) as! OnlineQuoteCell
        cell.configure(with: viewModel, isHidden: false)
        cell.delegate = self
        return cell
    }
    
}

extension OnlineQuotesViewController: OnlineQuoteCellDelegate {
    func hideElement(with symbol: String) {
        self.interactor?.toggleVisibility(for: symbol)
    }
}
