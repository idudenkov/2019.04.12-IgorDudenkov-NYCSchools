//
//  Result+additional.swift
//  NYC Schools
//
//  Created by Igor Dudenkov on 17/04/2019.
//  Copyright © 2019 Igor Dudenkov. All rights reserved.
//

import Foundation

extension Result {

    public var value: Success? {
        if case let .success(value) = self {
            return value
        }
        return nil
    }
}
