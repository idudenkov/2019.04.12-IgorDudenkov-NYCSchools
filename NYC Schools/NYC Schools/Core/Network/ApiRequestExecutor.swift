//
//  ApiRequestExecutor.swift
//  NYC Schools
//
//  Created by Igor Dudenkov on 12/04/2019.
//  Copyright © 2019 Igor Dudenkov. All rights reserved.
//

import Foundation

extension Result {

    public var value: Success? {
        if case let .success(value) = self {
            return value
        }
        return nil
    }
}

final class ApiRequestExecutor {

    static let defaultTimeOut: TimeInterval = 30.0
    private let request: URLRequest

    init(endpoint: String, timeout: TimeInterval = ApiRequestExecutor.defaultTimeOut, additionalHeaders: [String: String] = [:]) throws {
        guard let url = URL(string: endpoint) else { throw ApiError.wrongPath }
        var request = URLRequest(url: url, timeoutInterval: timeout)

        for (key, value) in additionalHeaders {
            request.setValue(value, forHTTPHeaderField: key)
        }

        self.request = request
    }

    func execute<Value>(completionQueue: DispatchQueue = .main, completion: @escaping (ApiResponse<Value>) -> Void) where Value: Decodable {
        let urlSession = URLSession.shared
        urlSession.dataTask(with: request)  { data, response, error in
            let response: ApiResponse<Value> = self.procces(data: data, response: response, error: error)
            completion(response)
        }.resume()
    }
}

private extension ApiRequestExecutor {

    func procces<Value>(data: Data?, response: URLResponse?, error: Error?) -> ApiResponse<Value>  where Value: Decodable  {
        guard error == nil else { return .failure(nil, ApiError.unknown) }

        guard let data = data else { return .failure(nil, ApiError.noData) }

        guard let response = response as? HTTPURLResponse else { return .failure(nil, ApiError.noResponse) }

        do {
            let value = try JSONDecoder().decode(Value.self, from: data)
            return .success(response, value)
        }
        catch let error {
            return .failure(response, ApiError.failedToDecode(error))
        }
    }
}
