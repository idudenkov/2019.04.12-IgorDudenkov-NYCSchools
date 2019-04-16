//
//  NYCSchoolsRepository.swift
//  NYC Schools
//
//  Created by Igor Dudenkov on 16/04/2019.
//  Copyright © 2019 Igor Dudenkov. All rights reserved.
//

import Foundation

protocol NYCSchoolsRepositoryProtocol {
    func fetchedSchools() -> [School]
    func fetchSchools(completion: @escaping (Result<[School], ApiError>) -> Void)
}

final class NYCSchoolsRepository: NYCSchoolsRepositoryProtocol {

    private let apiService: NYCSchoolsApiServiceProtocol
    private let storageService: NYCSchoolsStorageServiceProtocol

    init(apiService: NYCSchoolsApiServiceProtocol = NYCSchoolsApiService(),
         storageService: NYCSchoolsStorageServiceProtocol = NYCSchoolsStorageService()) {
        self.apiService = apiService
        self.storageService = storageService
    }

    func fetchedSchools() -> [School] {
        return storageService.getSchools().map { $0.toDomain() }
    }

    func fetchSchools(completion: @escaping (Result<[School], ApiError>) -> Void) {
        apiService.fetchSchools { result in
            let schoolsDto = result.value
            let result = result.map { $0.map { $0.toDomain() } }

            if let schoolsDto = schoolsDto {
                self.storageService.save(schools: schoolsDto) { completion(result) }
            }

            completion(result)
        }
    }

}
