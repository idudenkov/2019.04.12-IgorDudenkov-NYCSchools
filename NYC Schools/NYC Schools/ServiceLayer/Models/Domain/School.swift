//
//  School.swift
//  NYC Schools
//
//  Created by Igor Dudenkov on 16/04/2019.
//  Copyright © 2019 Igor Dudenkov. All rights reserved.
//

import Foundation

struct School {

    struct Location {
        let latitude: Double
        let longitude: Double
    }

    let identifer: String
    let name: String
    let address: String
    let totalStudents: Int
    let phoneNumber: String?
    let website: String?
    let location: Location?
}
