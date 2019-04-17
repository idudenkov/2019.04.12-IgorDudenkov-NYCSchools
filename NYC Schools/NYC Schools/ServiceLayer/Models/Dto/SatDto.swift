//
//  SatDto.swift
//  NYC Schools
//
//  Created by Igor Dudenkov on 17/04/2019.
//  Copyright © 2019 Igor Dudenkov. All rights reserved.
//

import Foundation

struct SatDto {
    let identifer: String
    let schoolName: String
    let mathScore: String
    let readingScore: String
    let writingScore: String
}

extension SatDto {

    func toDomain() -> Sat {
        return Sat(identifer: identifer,
                   schoolName: schoolName,
                   mathScore: mathScore,
                   readingScore: readingScore,
                   writingScore: writingScore)
    }
}
