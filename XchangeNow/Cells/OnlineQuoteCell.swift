//
//  OnlineQuoteCell.swift
//  XchangeNow
//
//  Created by Elmira Qurbanova on 04.04.25.
//

import UIKit

protocol OnlineQuoteCellDelegate: AnyObject {
    func hideElement(with symbol: String)
}

final class OnlineQuoteCell: UITableViewCell {
    
    static let reuseID = "OnlineQuoteCell"
    weak var delegate: OnlineQuoteCellDelegate?

    private let hideButton = UIButton(type: .system)
    private var currentSymbol: String?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHideButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupHideButton() {
        hideButton.setImage(UIImage(systemName: "trash"), for: .normal)
        hideButton.tintColor = .systemRed
        hideButton.addTarget(self, action: #selector(hideTapped), for: .touchUpInside)
        hideButton.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        accessoryView = hideButton
    }

    @objc private func hideTapped() {
        guard let symbol = currentSymbol else { return }
        delegate?.hideElement(with: symbol)
    }

    func configure(with viewModel: OnlineQuoteViewModel, isHidden: Bool) {
        currentSymbol = viewModel.symbol

        let arrow = viewModel.trend == "up" ? "⬆️" : "⬇️"
        var content = defaultContentConfiguration()
        content.text = "\(viewModel.symbol) \(arrow)"
        content.secondaryText = "Bid: \(viewModel.bid)    Ask: \(viewModel.ask)   Spread: \(viewModel.spread)\nLow price: \(viewModel.low)    High price: \(viewModel.high)\nLast update time: \(formatTime(viewModel.time))"
        content.secondaryTextProperties.numberOfLines = 3
        contentConfiguration = content
    }

    private func formatTime(_ isoString: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: isoString) {
            let output = DateFormatter()
            output.dateFormat = "HH:mm:ss"
            return output.string(from: date)
        }
        return isoString
    }
}
