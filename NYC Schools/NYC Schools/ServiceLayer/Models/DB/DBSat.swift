//
//  DBSat.swift
//  NYC Schools
//
//  Created by Igor Dudenkov on 17/04/2019.
//  Copyright © 2019 Igor Dudenkov. All rights reserved.
//

import Foundation
import CoreData

final class DBSat: NSManagedObject {
    @NSManaged var identifer: String
    @NSManaged var schoolName: String
    @NSManaged var mathScore: String
    @NSManaged var readingScore: String
    @NSManaged var writingScore: String
}

extension DBSat {
    static var entityName: String { return "Sat" }

    static var url: URL {
        return Bundle.main.url(forResource: "NYC_Schools", withExtension: "momd")!
    }

    func update(dto: SatDto) {
        identifer = dto.identifer
        schoolName = dto.schoolName
        mathScore = dto.mathScore
        readingScore = dto.readingScore
        writingScore = dto.writingScore
    }

    func toDto() -> SatDto {
        return SatDto(identifer: identifer, schoolName: schoolName, mathScore: mathScore, readingScore: readingScore, writingScore: writingScore)
    }
}
