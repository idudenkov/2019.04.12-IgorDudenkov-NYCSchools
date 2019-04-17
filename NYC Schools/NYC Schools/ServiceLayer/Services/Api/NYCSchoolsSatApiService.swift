//
//  NYCSchoolsSatApiService.swift
//  NYC Schools
//
//  Created by Igor Dudenkov on 17/04/2019.
//  Copyright © 2019 Igor Dudenkov. All rights reserved.
//

import Foundation

protocol NYCSchoolsSatApiServiceProtocol {
    func fetchSat(forSchool identifer: String, completion: @escaping (Result<[SatDto], ApiError>) -> Void)
}

final class NYCSchoolsSatApiService: NYCSchoolsSatApiServiceProtocol {

    func fetchSat(forSchool identifer: String, completion: @escaping (Result<[SatDto], ApiError>) -> Void) {
        let path = BaseUrls.baseURL + BaseUrls.satScoresURL + QueriesComponent.dbn(identifer).rawValue
        let executor = try? ApiRequestExecutor(endpoint: path)
        executor?.execute(completionQueue: .global()) { response in
            DispatchQueue.main.async {
                completion(response.result)
            }
        }
    }
}

extension SatDto: Decodable {
    enum CodingKeys: String, CodingKey {
        case identifer = "dbn"
        case schoolName = "school_name"
        case mathScore = "sat_math_avg_score"
        case readingScore = "sat_critical_reading_avg_score"
        case writingScore = "sat_writing_avg_score"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifer = try container.decode(String.self, forKey: .identifer)
        schoolName = try container.decode(String.self, forKey: .schoolName)
        mathScore = try container.decode(String.self, forKey: .mathScore)
        readingScore = try container.decode(String.self, forKey: .readingScore)
        writingScore = try container.decode(String.self, forKey: .writingScore)
    }
}
