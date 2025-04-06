//
//  Quote.swift
//  XchangeNow
//
//  Created by Elmira on 03.04.25.
//

import Foundation

struct OnlineQuote: Codable {
    
    let trend: String
    let symbol: String
    let bidPrice: String
    let askPrice: String
    let lowPrice: String
    let highPrice: String
    let spread: String
    let lastTime: String

    init?(from array: [String: String]) {
        guard let trend = array["0"],
            let symbol = array["1"],
            let bidPrice = array["2"],
            let askPrice = array["3"],
            let lowPrice = array["4"],
            let highPrice = array["5"],
            let spread = array["6"],
            let lastTime = array["7"]
        else {
            return nil
        }

        self.trend = trend
        self.symbol = symbol
        self.bidPrice = bidPrice
        self.askPrice = askPrice
        self.lowPrice = lowPrice
        self.highPrice = highPrice
        self.spread = spread
        self.lastTime = lastTime
    }
}
