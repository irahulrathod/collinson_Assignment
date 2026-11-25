//
//  APISerview.swift
//  Collinson_Test
//
//  Created by Rahul Rathod on 25/11/26.
//

import Foundation
import Combine

enum ServiceError: Error {
    case unableToLoad
}

protocol APIService {
    func executeService<T: Decodable>(endpoint: String, responseModel: T.Type) -> AnyPublisher<T, ServiceError>
}

class APIServiceImplemenation: APIService {
    
    func executeService<T>(endpoint: String, responseModel: T.Type) -> AnyPublisher<T, ServiceError> where T : Decodable {
        guard let request = createRequest(endpoint: endpoint) else {
            return Fail(error: ServiceError.unableToLoad).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: request).tryMap({ data, response in

            guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                throw ServiceError.unableToLoad
            }
            return data
        })
        .decode(type: T.self, decoder: JSONDecoder())
        .mapError({ error -> ServiceError in
            error as? ServiceError ?? .unableToLoad
        })
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    private func createRequest(endpoint: String) -> URLRequest? {

        guard let serviceURL = URL(string: String(format: endpoint)) else {
            return nil
        }

        var request = URLRequest(url: serviceURL)
        request.httpMethod = "GET"

        return request
    }
}
