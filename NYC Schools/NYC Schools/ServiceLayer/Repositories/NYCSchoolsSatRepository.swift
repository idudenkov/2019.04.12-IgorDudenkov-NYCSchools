//
//  NYCSchoolsSatRepository.swift
//  NYC Schools
//
//  Created by Igor Dudenkov on 17/04/2019.
//  Copyright © 2019 Igor Dudenkov. All rights reserved.
//

import Foundation

protocol NYCSchoolsSatRepositoryProtocol {
    func getSat(forSchool identifer: String) -> Sat?
    func fetchSat(forSchool identifer: String, completion: @escaping (Result<[Sat], ApiError>) -> Void)
}

final class NYCSchoolsSatRepository: NYCSchoolsSatRepositoryProtocol {

    private let apiService: NYCSchoolsSatApiServiceProtocol
    private let storageService: NYCSchoolsSatStorageServiceProtocol

    init(apiService: NYCSchoolsSatApiServiceProtocol = NYCSchoolsSatApiService(),
         storageService: NYCSchoolsSatStorageServiceProtocol = NYCSchoolsSatStorageService()) {
        self.apiService = apiService
        self.storageService = storageService
    }

    func getSat(forSchool identifer: String) -> Sat? {
        return storageService.getSat(forSchool: identifer)?.toDomain()
    }

    func fetchSat(forSchool identifer: String, completion: @escaping (Result<[Sat], ApiError>) -> Void) {
        apiService.fetchSat(forSchool: identifer) { result in
            let satDto = result.value
            let result = result.map { $0.map { $0.toDomain() } }

            guard let dto = satDto?.first else {
                completion(result)
                return
            }

            self.storageService.save(sat: dto) { completion(result) }
        }
    }

}
