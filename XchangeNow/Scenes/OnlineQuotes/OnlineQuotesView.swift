//
//  OnlineQuotesView.swift
//  XchangeNow
//
//  Created by Elmira Qurbanova on 04.04.25.
//

import UIKit

final class OnlineQuotesView: UIView {

    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(OnlineQuoteCell.self, forCellReuseIdentifier: OnlineQuoteCell.reuseID)
        table.backgroundColor = .clear
        return table
    }()

    let connectionStatusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .systemGray
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .systemGray6
        addSubview(connectionStatusLabel)
        addSubview(tableView)

        connectionStatusLabel.anchor(top: safeAreaLayoutGuide.topAnchor, paddingTop: 16)
        connectionStatusLabel.setDimensions(height: 24, width: 200)
        connectionStatusLabel.centerX(inView: self)
        
        tableView.anchor(top: connectionStatusLabel.bottomAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingTop: 16)
        
    }

    func updateConnectionStatus(isConnected: Bool) {
        connectionStatusLabel.text = isConnected ? "Connected" : "Disconnected"
        connectionStatusLabel.backgroundColor = isConnected ? .systemGreen : .systemRed
    }
}
