//
//  OnlineQuotesService.swift
//  XchangeNow
//
//  Created by Elmira on 04.04.25.
//

import Foundation

protocol OnlineQuotesServiceDelegate: AnyObject {
    func didReceiveQuotes(_ quotes: [OnlineQuote])
    func didUpdateConnectionStatus(connected: Bool)
}

final class OnlineQuotesService: NSObject {
    
    weak var delegate: OnlineQuotesServiceDelegate?
    
    private var webSocketTask: URLSessionWebSocketTask?
    private var isConnected = false
    
    func connect() {
        
        guard let url = URL(string: "wss://investaz.az/quotes") else { return }
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        
        isConnected = true
        delegate?.didUpdateConnectionStatus(connected: true)
        receive()
        
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
//                       self?.disconnect()
//                   }
    }
    
    func disconnect() {
        isConnected = false
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        delegate?.didUpdateConnectionStatus(connected: false)
    }
    
    private func receive() {
        webSocketTask?.receive { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .failure(let error):
                print("websocket error:", error)
                self.isConnected = false
                self.delegate?.didUpdateConnectionStatus(connected: false)
                self.reconnect()
            case .success(let message):
                switch message {
                case .string(let text):
                    self.handleIncomingMessage(text)
                    
                default:
                    break
                }
                self.receive()
            }
        }
    }
    
    private func handleIncomingMessage(_ text: String) {
        guard let data = text.data(using: .utf8) else { return }
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data) as? [[String: String]] {
                let quotes = jsonArray.compactMap { OnlineQuote(from: $0) }
//                print("сырые данные: \(text)")
                delegate?.didReceiveQuotes(quotes)
            }
        } catch {
            print("parsing error:", error)
        }
    }
    
    private func reconnect() {
        guard !isConnected else { return }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.connect()
        }
    }
}

extension OnlineQuotesService: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask,
                    didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                    reason: Data?) {
        print("вебсокет закрылся")
        isConnected = false
        delegate?.didUpdateConnectionStatus(connected: false)
        reconnect()
    }
}
