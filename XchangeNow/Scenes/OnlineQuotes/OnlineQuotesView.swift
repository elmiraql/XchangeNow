//
//  OnlineQuotesView.swift
//  XchangeNow
//
//  Created by Elmira on 04.04.25.
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
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .clear // .systemGray
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        return label
    }()
    
    let connectionIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.layer.cornerRadius = 8
        return view
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
        addSubViews(connectionIndicator)

        connectionStatusLabel.anchor(top: safeAreaLayoutGuide.topAnchor, paddingTop: 16)
        connectionStatusLabel.centerX(inView: self)
        
        connectionIndicator.setDimensions(height: 16, width: 16)
        connectionIndicator.anchor(right: connectionStatusLabel.leftAnchor, paddingRight: 8)
        connectionIndicator.centerY(inView: connectionStatusLabel)
        
        tableView.anchor(top: connectionStatusLabel.bottomAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingTop: 16)
        
    }

    func updateConnectionStatus(isConnected: Bool) {
        connectionStatusLabel.text = isConnected ? "Connected" : "Disconnected"        
        connectionIndicator.backgroundColor = isConnected ? .systemGreen : .systemRed
    }
}
