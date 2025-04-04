//
//  CurrencyRate.swift
//  XchangeNow
//
//  Created by Elmira Qurbanova on 04.04.25.
//

import Foundation

struct CurrencyRate: Decodable {
    let from: String
    let to: String
    let result: Double
    let date: String
}
