//
//  SchoolDto.swift
//  NYC Schools
//
//  Created by Igor Dudenkov on 16/04/2019.
//  Copyright © 2019 Igor Dudenkov. All rights reserved.
//

import Foundation

struct SchoolDto {
    let identifer: String
    let name: String
    let address: String
    let totalStudents: String
    let phoneNumber: String?
    let website: String?
    let latitude: String?
    let longitude: String?
}

extension SchoolDto {

    func toDomain() -> School {
        var location: School.Location?
        if let latitude = latitude.map({ Double($0) }) ?? nil, let longitude = longitude.map({ Double($0) }) ?? nil {
            location = School.Location(latitude: latitude, longitude: longitude)
        }
        
        return School(identifer: identifer,
               name: name,
               address: address,
               totalStudents: Int(totalStudents) ?? 0,
               phoneNumber: phoneNumber,
               website: website,
               location: location)
    }
}
