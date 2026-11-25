//
//  MockCitySearchRepository.swift
//  Collinson_Test
//
//  Created by Rahul Rathod on 25/11/26.
//

import XCTest
@testable import Collinson_Test
import Combine

class MockCitySearchRepository: CitySearchRepository {
    func getCity(cityName: String) -> AnyPublisher<[City], ServiceError> {
        Just([City(name: "New York", latitude: 40.710335, longitude: -73.99308)])
        .setFailureType(to: ServiceError.self)
        .eraseToAnyPublisher()
    }
}
