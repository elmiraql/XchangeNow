//
//  OnlineQuoteCell.swift
//  XchangeNow
//
//  Created by Elmira on 04.04.25.
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
        hideButton.setTitle("Hide", for: .normal)
        hideButton.setTitleColor(.red, for: .normal)
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
        content.textProperties.font = .boldSystemFont(ofSize: 17)
        content.secondaryText = "Bid: \(viewModel.bid)    Ask: \(viewModel.ask)   Spread: \(viewModel.spread)\nLow price: \(viewModel.low)    High price: \(viewModel.high)\nLast update time: \(formatToShortDate(viewModel.time))"
        content.secondaryTextProperties.numberOfLines = 3
        contentConfiguration = content
    }

    private func formatToShortDate(_ isoString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        if let date = inputFormatter.date(from: isoString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd.MM.yyyy"
            return outputFormatter.string(from: date)
        }

        return isoString
    }
}
