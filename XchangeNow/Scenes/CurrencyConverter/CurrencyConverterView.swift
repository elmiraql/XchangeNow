//
//  CurrencyConverterView.swift
//  XchangeNow
//
//  Created by Elmira Qurbanova on 03.04.25.
//

import UIKit

enum CurrencyType {
    case from
    case to
}

final class CurrencyConverterView: UIView {
    
    private var fromDropdown: ReusableDropdown?
    private var toDropdown: ReusableDropdown?
    
    var title: UILabel = {
        let label = UILabel()
        label.text = "Convert any \nCurrency"
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 32)
        return label
    }()
    
    var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        return view
    }()

    let fromCurrencyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("base curr", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    var toLabel: UILabel = {
        let label = UILabel()
        label.text = "to"
        label.textAlignment = .center
        return label
    }()

    let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter amount"
        textField.borderStyle = .none
        textField.keyboardType = .decimalPad
        textField.layer.cornerRadius = 20
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.layer.masksToBounds = true
        textField.setLeftPaddingPoints(12)
        return textField
    }()

    let toCurrencyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("target curr", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    let resultLabel: UILabel = {
        let label = UILabel()
//        label.text = "≈ 0.00"
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func setupLayout() {
        backgroundColor = UIColor(named: "purpleColor")
        
        let hStack = UIStackView(arrangedSubviews: [
        fromCurrencyButton, toLabel, toCurrencyButton
        ])
        hStack.spacing = 16
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.axis = .horizontal

        let vStack = UIStackView(arrangedSubviews: [
            hStack, amountTextField, resultLabel
        ])
        vStack.axis = .vertical
        vStack.spacing = 16
        vStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(bgView)
        addSubViews(title)
        addSubview(vStack)
        
        title.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)

        bgView.anchor(top: title.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        vStack.anchor(top: bgView.topAnchor, left: bgView.leftAnchor, bottom: bgView.bottomAnchor, right: bgView.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
        vStack.centerY(inView: bgView)

        fromCurrencyButton.setDimensions(height: 60, width: 100)
        toCurrencyButton.setDimensions(height: 60, width: 100)
        amountTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true

    }
    
    func showDropdown(options: [String], for type: CurrencyType, selectionHandler: @escaping (String) -> Void) {
        let dropdown = ReusableDropdown()

        switch type {
        case .from:
            fromDropdown?.dismiss()
            fromDropdown = dropdown
            dropdown.present(
                options: options,
                anchorView: fromCurrencyButton,
                in: self,
                onSelect: { [weak self] selected in
                    self?.fromCurrencyButton.setTitle(selected, for: .normal)
                    selectionHandler(selected)
                    self?.fromDropdown = nil
                }
            )
        case .to:
            toDropdown?.dismiss()
            toDropdown = dropdown
            dropdown.present(
                options: options,
                anchorView: toCurrencyButton,
                in: self,
                onSelect: { [weak self] selected in
                    self?.toCurrencyButton.setTitle(selected, for: .normal)
                    selectionHandler(selected)
                    self?.toDropdown = nil
                }
            )
        }
    }
}

