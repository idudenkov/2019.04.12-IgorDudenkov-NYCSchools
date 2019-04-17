//
//  NYCSchoolsApiService.swift
//  NYC Schools
//
//  Created by Igor Dudenkov on 16/04/2019.
//  Copyright © 2019 Igor Dudenkov. All rights reserved.
//

import Foundation

protocol NYCSchoolsApiServiceProtocol {
    func fetchSchools(completion: @escaping (Result<[SchoolDto], ApiError>) -> Void)
}

final class NYCSchoolsApiService: NYCSchoolsApiServiceProtocol {

    func fetchSchools(completion: @escaping (Result<[SchoolDto], ApiError>) -> Void) {
        let executor = try? ApiRequestExecutor(endpoint: BaseUrls.baseURL + BaseUrls.schoolURL)
        executor?.execute(completionQueue: .global()) { response in
            DispatchQueue.main.async {
                completion(response.result)
            }
        }
    }
}

extension SchoolDto: Decodable {

    enum CodingKeys: String, CodingKey {
        case identifer = "dbn"
        case name = "school_name"
        case address = "primary_address_line_1"
        case totalStudents = "total_students"
        case phoneNumber = "phone_number"
        case website
        case latitude
        case longitude
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifer = try container.decode(String.self, forKey: .identifer)
        name = try container.decode(String.self, forKey: .name)
        address = try container.decode(String.self, forKey: .address)
        totalStudents = try container.decode(String.self, forKey: .totalStudents)
        phoneNumber = try? container.decode(String.self, forKey: .phoneNumber)
        website = try? container.decode(String.self, forKey: .website)
        latitude = try? container.decode(String.self, forKey: .latitude)
        longitude = try? container.decode(String.self, forKey: .longitude)
    }
}
