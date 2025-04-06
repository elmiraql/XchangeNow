//
//  OnlineQuotesWorker.swift
//  XchangeNow
//
//  Created by Elmira on 03.04.25.
//

import Foundation

protocol OnlineQuotesWorkerDelegate: AnyObject {
    func didReceiveQuotes(_ quotes: [OnlineQuote])
    func didUpdateConnectionStatus(connected: Bool)
}

final class OnlineQuotesWorker {
    weak var delegate: OnlineQuotesWorkerDelegate?
    private let service = OnlineQuotesService()

    init() {
        service.delegate = self
    }

    func connect() {
        service.connect()
    }

    func disconnect() {
        service.disconnect()
    }
}

extension OnlineQuotesWorker: OnlineQuotesServiceDelegate {
    func didReceiveQuotes(_ quotes: [OnlineQuote]) {
        delegate?.didReceiveQuotes(quotes)
    }

    func didUpdateConnectionStatus(connected: Bool) {
        delegate?.didUpdateConnectionStatus(connected: connected)
    }
}
