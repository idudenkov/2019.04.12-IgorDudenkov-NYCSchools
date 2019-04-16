//
//  ApiError.swift
//  NYC Schools
//
//  Created by Igor Dudenkov on 12/04/2019.
//  Copyright © 2019 Igor Dudenkov. All rights reserved.
//

import Foundation

enum ApiError: Error {
    case unknown
    case wrongPath
    case noResponse
    case noData
    case failedToDecode(Error)
}
