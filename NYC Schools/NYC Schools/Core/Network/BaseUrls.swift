//
//  BaseUrls.swift
//  NYC Schools
//
//  Created by Igor Dudenkov on 16/04/2019.
//  Copyright © 2019 Igor Dudenkov. All rights reserved.
//

import Foundation

enum BaseUrls {
    static let baseURL = "https://data.cityofnewyork.us/resource"
    static let schoolURL = "/97mf-9njv.json"
    static let satScoresURL =  "/734v-jeq5.json"

    static let secretToken: String = "hRBLH4heMrfg66zIyV1CUN0aP"
}

enum QueriesComponent {
    case dbn(String)

    var rawValue: String {
        switch self {
        case .dbn(let id): return "?dbn=\(id)"
        }
    }
}
