//
//  ApiResponse.swift
//  NYC Schools
//
//  Created by Igor Dudenkov on 12/04/2019.
//  Copyright © 2019 Igor Dudenkov. All rights reserved.
//

import Foundation

enum ApiResponse<Value> {
    case success(HTTPURLResponse, Value)
    case failure(HTTPURLResponse?, ApiError)

    var result: Result<Value, ApiError> {
        switch self {
        case .success(_, let value):
            return .success(value)
        case .failure(_, let error):
            return .failure(error)
        }
    }
}
