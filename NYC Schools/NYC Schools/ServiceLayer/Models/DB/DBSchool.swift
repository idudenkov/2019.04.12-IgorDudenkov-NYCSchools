//
//  DBSchool.swift
//  NYC Schools
//
//  Created by Igor Dudenkov on 16/04/2019.
//  Copyright © 2019 Igor Dudenkov. All rights reserved.
//

import Foundation
import CoreData

final class DBSchool: NSManagedObject {
    @NSManaged var identifer: String
    @NSManaged var name: String
    @NSManaged var address: String
    @NSManaged var totalStudents: String
    @NSManaged var phoneNumber: String?
    @NSManaged var website: String?
    @NSManaged var latitude: String?
    @NSManaged var longitude: String?
}

extension DBSchool {

    static var entityName: String { return "School" }

    static var url: URL {
        return Bundle.main.url(forResource: "NYC_Schools", withExtension: "momd")!
    }

    func update(dto: SchoolDto) {
        identifer = dto.identifer
        name = dto.name
        address = dto.address
        totalStudents = dto.totalStudents
        phoneNumber = dto.phoneNumber
        website = dto.website
        latitude = dto.latitude
        longitude = dto.longitude
    }

    func toDto() -> SchoolDto {
        return SchoolDto(identifer: identifer,
                         name: name,
                         address: address,
                         totalStudents: totalStudents,
                         phoneNumber: phoneNumber,
                         website: website,
                         latitude: latitude,
                         longitude: longitude)
    }
}

