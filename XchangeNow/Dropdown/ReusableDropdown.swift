//
//  DropdownView.swift
//  XchangeNow
//
//  Created by Elmira on 04.04.25.
//

import UIKit

final class ReusableDropdown: UIView, UITableViewDelegate, UITableViewDataSource {

    private let tableView = UITableView()
    private let overlayView = UIView()

    private var options: [String] = []
    private var onSelect: ((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.systemGray.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 4
        clipsToBounds = true

        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        addSubview(tableView)
        tableView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }


    func present(options: [String], anchorView: UIView, in parentView: UIView, onSelect: @escaping (String) -> Void) {
        self.options = options
        self.onSelect = onSelect
        tableView.reloadData()

        overlayView.frame = parentView.bounds
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.01)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        overlayView.addGestureRecognizer(tap)
        parentView.addSubview(overlayView)

        let anchorFrame = anchorView.convert(anchorView.bounds, to: parentView)
        let height = min(CGFloat(options.count) * 44, 220)
        let width = max(anchorFrame.width, 100)
        self.frame = CGRect(
            x: anchorFrame.origin.x,
            y: anchorFrame.maxY + 4,
            width: width,
            height: height
        )

        self.alpha = 0
        self.transform = CGAffineTransform(translationX: 0, y: -10)
        parentView.addSubview(self)

        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut]) {
            self.alpha = 1
            self.transform = .identity
        }
    }

    @objc func dismiss() {
        self.removeFromSuperview()
        overlayView.removeFromSuperview()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = options[indexPath.row]
        onSelect?(selected)
        dismiss()
    }
}
