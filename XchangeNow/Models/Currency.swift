//
//  Currency.swift
//  XchangeNow
//
//  Created by Elmira on 03.04.25.
//

import Foundation

struct Currency: Decodable {
    let code: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case code
        case name = "en" 
    }
}
