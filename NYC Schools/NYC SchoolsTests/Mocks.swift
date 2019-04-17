//
//  Mocks.swift
//  NYC SchoolsTests
//
//  Created by Igor Dudenkov on 17/04/2019.
//  Copyright © 2019 Igor Dudenkov. All rights reserved.
//

import Foundation
@testable import NYC_Schools

final class NYCSchoolsApiServiceMock: NYCSchoolsApiServiceProtocol {

    var fetchSchoolsResult: Result<[SchoolDto], ApiError> = .failure(.noResponse)
    func fetchSchools(completion: @escaping (Result<[SchoolDto], ApiError>) -> Void) {
        completion(fetchSchoolsResult)
    }

}

final class NYCSchoolsSatApiServiceMock: NYCSchoolsSatApiServiceProtocol {

    var fetchSatResult: Result<[SatDto], ApiError> = .failure(.noResponse)
    func fetchSat(forSchool identifer: String, completion: @escaping (Result<[SatDto], ApiError>) -> Void) {
        completion(fetchSatResult)
    }

}

final class NYCSchoolsStorageServiceMock: NYCSchoolsStorageServiceProtocol {

    func save(schools: [SchoolDto], completion: @escaping () -> Void) {
        self.schools = schools
        completion()
    }

    var schools: [SchoolDto] = []
    func getSchools() -> [SchoolDto] {
        return schools
    }

}

final class NYCSchoolsSatStorageServiceMock: NYCSchoolsSatStorageServiceProtocol {
    func save(sat: SatDto, completion: @escaping () -> Void) {
        self.sat = sat
        completion()
    }

    var sat: SatDto?
    func getSat(forSchool identifer: String) -> SatDto? {
        return sat
    }

}
