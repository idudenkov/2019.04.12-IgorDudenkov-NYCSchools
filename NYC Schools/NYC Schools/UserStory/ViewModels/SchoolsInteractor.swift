//
//  SchoolsInteractor.swift
//  NYC Schools
//
//  Created by Igor Dudenkov on 17/04/2019.
//  Copyright © 2019 Igor Dudenkov. All rights reserved.
//

import Foundation

protocol SchoolsInteractorProtocol {
    var schools: [School] { get }

    func fetchSat(forSchool identifer: String, completion: @escaping (Result<[Sat], ApiError>) -> Void)
    func fetchSchools(completion: @escaping (Result<[School], ApiError>) -> Void)
    func getSat(forSchool identifer: String) -> Sat?

}

final class SchoolsInteractor: SchoolsInteractorProtocol {

    typealias RepositoryContiner = (schools: NYCSchoolsRepositoryProtocol, sat: NYCSchoolsSatRepositoryProtocol)
    private let repositoryContiner: RepositoryContiner

    init(repositoryContiner: RepositoryContiner = (NYCSchoolsRepository(), NYCSchoolsSatRepository())) {
        self.repositoryContiner = repositoryContiner
    }

    var schools: [School] {
        return repositoryContiner.schools.fetchedSchools()
    }

    func fetchSat(forSchool identifer: String, completion: @escaping (Result<[Sat], ApiError>) -> Void) {
        repositoryContiner.sat.fetchSat(forSchool: identifer, completion: completion)
    }

    func fetchSchools(completion: @escaping (Result<[School], ApiError>) -> Void) {
        repositoryContiner.schools.fetchSchools(completion: completion)
    }

    func getSat(forSchool identifer: String) -> Sat? {
        return repositoryContiner.sat.getSat(forSchool: identifer)
    }
}
